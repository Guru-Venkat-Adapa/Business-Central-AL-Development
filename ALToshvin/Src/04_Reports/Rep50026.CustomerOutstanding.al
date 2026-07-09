report 50026 "Customer Outstanding"
{
    ApplicationArea = All;
    Caption = 'Customer Outstanding';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Posting Date");

            trigger OnPreDataItem()
            var
                MinDate: Date;
                MaxDate: Date;
            begin
                // Auto-calculate FlowField so filter works on Remaining Amount
                SetAutoCalcFields("Remaining Amount", Amount);
                if CustomerNo <> '' then
                    SetRange("Customer No.", CustomerNo);

                SetFilter("Remaining Amount", '<>%1', 0);
                SetFilter("Document Type", '%1|%2|%3', "Document Type"::Invoice, "Document Type"::Payment, "Document Type"::"Credit Memo");
                if StartDate = 0D then begin
                    CustLedgerEntry.SetCurrentKey("Posting Date");
                    if CustLedgerEntry.FindFirst() then
                        MinDate := CustLedgerEntry."Posting Date"
                    else
                        MinDate := WorkDate();
                end else
                    MinDate := StartDate;

                if EndDate = 0D then begin
                    CustLedgerEntry.SetCurrentKey("Posting Date");
                    if CustLedgerEntry.FindLast() then
                        MaxDate := CustLedgerEntry."Posting Date"
                    else
                        MaxDate := WorkDate();
                end else
                    MaxDate := EndDate;

                if MinDate > MaxDate then
                    Error('Start Date should not be greater than End Date.');

                SetRange("Posting Date", MinDate, MaxDate);

                //TBC-1011 --->
                if DocumentType <> DocumentType::" " then
                    SetRange("Document Type", DocumentType);

                // TBC-1011 Region Filter --->
                if Region <> '' then begin
                    RegionName := GetRegionName(Region);
                    RegionFilter := GetRegionFilter(Region);
                    SetFilter("Global Dimension 2 Code", RegionFilter);
                end;
                // TBC-1011 <------
                //TBC-1011 <-----
                CreateExcelHeader();
            end;

            trigger OnAfterGetRecord()
            begin
                ProcessCustLedgerEntry();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(DataFilter)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                    field(CustomerNo; CustomerNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer No.';
                        TableRelation = Customer."No.";
                    }
                    field(DocumentType; DocumentType)
                    {
                        ApplicationArea = All;
                        Caption = 'Document Type';
                    }
                    field(Region; Region)
                    {
                        ApplicationArea = All;
                        Caption = 'Region';
                        TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        CreateExcelBook();
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Customer: Record Customer;
        DetailedCustLedEntry: Record "Cust. Ledger Entry";
        PostedSalesInvoice: Record "Sales Invoice Header";
        DocumentTracker: Record "Name/Value Buffer" temporary;
        Dimension: Record "Dimension Value";
        StartDate: Date;
        EndDate: Date;
        CustomerNo: Code[20];
        IsFirstOccurrenceOfLedgerEntry: Boolean;
        IsFirstInvoiceRow: Boolean;
        DocumentCounter: Integer;
        DocumentType: Enum "Gen. Journal Document Type";
        Amt0_30: Decimal;
        Amt31_60: Decimal;
        Amt61_90: Decimal;
        Amt91_120: Decimal;
        AmtMore120: Decimal;
        OutstandingDays: Integer;
        Region: Code[20];
        SalesCommentLine: Record "Sales Comment Line";
        OrderComment: Text;
        DetGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";

        LineAmount: Decimal;

        RegionFilter: Text;
        RegionName: Text[100];
        ZoneName: Text[100];
        HeadingName: Text[100];

    local procedure ProcessCustLedgerEntry()
    var
        SalesHeader: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
        ExternalDocNo: Code[20];
        InvoiceFound: Boolean;
    begin
        CustLedgerEntry.CalcFields("Remaining Amount", Amount);

        Clear(Customer);
        if not Customer.Get(CustLedgerEntry."Customer No.") then
            exit;

        // Check if this DocNo + CustNo combination has been seen before
        CheckDocumentOccurrence();

        InvoiceFound := false;
        // Reset per-ledger-entry invoice row flag
        IsFirstInvoiceRow := true;

        // ---------------------------------------------------------------
        // INVOICE Document Type: fetch Posted Sales Invoice directly
        // using CustLedgerEntry."Document No." as the primary lookup,
        // then get the related Sales Order from PostedSalesInvoice."Order No."
        // ---------------------------------------------------------------
        if CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice then begin
            if PostedSalesInvoice.Get(CustLedgerEntry."Document No.") then begin
                InvoiceFound := true;
                Clear(SalesHeader);
                Clear(SalesHeaderArchive);
                GetSalesOrderDetails(PostedSalesInvoice."Order No.", SalesHeader, SalesHeaderArchive);
                WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice);
                IsFirstInvoiceRow := false;
            end;
        end;

        // ---------------------------------------------------------------
        // For Payment / Credit Memo OR if Invoice lookup above failed,
        // fall back to Detailed Cust. Ledger Entry lookup
        // ---------------------------------------------------------------
        if not InvoiceFound then begin
            // Attempt 1: Find via Closed by Entry No.
            DetailedCustLedEntry.Reset();
            DetailedCustLedEntry.SetRange("Closed by Entry No.", CustLedgerEntry."Entry No.");
            if DetailedCustLedEntry.FindSet() then begin
                repeat
                    if PostedSalesInvoice.Get(DetailedCustLedEntry."Document No.") then begin
                        InvoiceFound := true;
                        Clear(SalesHeader);
                        Clear(SalesHeaderArchive);
                        GetSalesOrderDetails(PostedSalesInvoice."Order No.", SalesHeader, SalesHeaderArchive);
                        WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice);
                        IsFirstInvoiceRow := false;
                    end;
                until DetailedCustLedEntry.Next() = 0;
            end else begin
                // Attempt 2: Find via Entry No. = Closed by Entry No.
                DetailedCustLedEntry.Reset();
                DetailedCustLedEntry.SetRange("Entry No.", CustLedgerEntry."Closed by Entry No.");
                if DetailedCustLedEntry.FindSet() then begin
                    repeat
                        if PostedSalesInvoice.Get(DetailedCustLedEntry."Document No.") then begin
                            InvoiceFound := true;
                            Clear(SalesHeader);
                            Clear(SalesHeaderArchive);
                            GetSalesOrderDetails(PostedSalesInvoice."Order No.", SalesHeader, SalesHeaderArchive);
                            WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice);
                            IsFirstInvoiceRow := false;
                        end;
                    until DetailedCustLedEntry.Next() = 0;
                end;
            end;
        end;

        // ---------------------------------------------------------------
        // No invoice found at all - fallback to External Document No.
        // for Sales Order lookup and write a row without invoice details
        // ---------------------------------------------------------------
        if not InvoiceFound then begin
            Clear(SalesHeader);
            Clear(SalesHeaderArchive);
            Clear(PostedSalesInvoice);
            ExternalDocNo := CopyStr(CustLedgerEntry."External Document No.", 1, 20);
            if ExternalDocNo <> '' then
                GetSalesOrderDetails(ExternalDocNo, SalesHeader, SalesHeaderArchive);
            WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice);
        end;
    end;

    local procedure GetSalesOrderDetails(OrderNo: Code[20]; var SalesHeader: Record "Sales Header"; var SalesHeaderArchive: Record "Sales Header Archive")
    begin
        Clear(SalesHeader);
        Clear(SalesHeaderArchive);
        if OrderNo = '' then
            exit;
        // 1. First try active Sales Orders
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("No.", OrderNo);
        if SalesHeader.FindFirst() then
            exit;
        // 2. Not found - try Sales Header Archive
        SalesHeaderArchive.Reset();
        SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
        SalesHeaderArchive.SetRange("No.", OrderNo);
        if SalesHeaderArchive.FindLast() then;
    end;

    local procedure CheckDocumentOccurrence()
    var
        DocNo: Code[20];
        CustNo: Code[20];
        CompositeKey: Text[50];
    begin
        DocNo := CustLedgerEntry."Document No.";
        CustNo := CustLedgerEntry."Customer No.";
        IsFirstOccurrenceOfLedgerEntry := false;

        if DocNo = '' then begin
            IsFirstOccurrenceOfLedgerEntry := true;
            exit;
        end;

        CompositeKey := CopyStr(DocNo + '|' + CustNo, 1, 50);

        DocumentTracker.Reset();
        DocumentTracker.SetRange(Name, CompositeKey);
        if not DocumentTracker.FindFirst() then begin
            // First time this DocNo + CustNo combination is seen
            IsFirstOccurrenceOfLedgerEntry := true;
            DocumentCounter += 1;
            DocumentTracker.Init();
            DocumentTracker.ID := DocumentCounter;
            DocumentTracker.Name := CompositeKey;
            DocumentTracker.Value := Format(CustLedgerEntry."Amount (LCY)");
            DocumentTracker.Insert();
        end else
            IsFirstOccurrenceOfLedgerEntry := false;
    end;

    procedure WriteExcelRow(SalesHeader: Record "Sales Header"; SalesHeaderArchive: Record "Sales Header Archive"; Cust: Record Customer; PostedInvoice: Record "Sales Invoice Header")
    var
        SalesLine: Record "Sales Line";
        ItemMaster: Record Item;
        SalesLineArchive: Record "Sales Line Archive";
        ServiceType: Record "ServiceType";
        DimensionValue: Text;
        Department: Text;
        Branch: Text;
        Teams: Text;
        TotalInvoiceAmount: Decimal;
        RemainingAmount: Decimal;
        Principal: Code[20];
        PaymentTermDetail: Text[250];
        ServiceDescription: Text[250];
    begin
        ExcelBuffer.NewRow();

        if IsFirstOccurrenceOfLedgerEntry and IsFirstInvoiceRow then begin
            TotalInvoiceAmount := CustLedgerEntry.Amount;
            RemainingAmount := CustLedgerEntry."Remaining Amount";
        end else begin
            TotalInvoiceAmount := 0;
            RemainingAmount := 0;
        end;
        // Get Principal from Sales Line or Sales Line Archive
        Principal := '';
        if SalesHeader."No." <> '' then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            if SalesLine.FindFirst() then
                Principal := SalesLine.Principal;
        end else if SalesHeaderArchive."No." <> '' then begin
            SalesLineArchive.Reset();
            SalesLineArchive.SetRange("Document Type", SalesHeaderArchive."Document Type");
            SalesLineArchive.SetRange("Document No.", SalesHeaderArchive."No.");
            SalesLineArchive.SetRange("Doc. No. Occurrence", SalesHeaderArchive."Doc. No. Occurrence");
            SalesLineArchive.SetRange("Version No.", SalesHeaderArchive."Version No.");
            SalesLineArchive.SetRange(Type, SalesLineArchive.Type::Item);
            if SalesLineArchive.FindFirst() then
                Principal := SalesLineArchive.Principal;
        end;
        // Zone Name
        Clear(ZoneName);
        ZoneName := GetZoneName(SalesHeader."Shortcut Dimension 2 Code");
        ExcelBuffer.AddColumn(ZoneName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);



        //Branch Nane
        // Branch Name - Shortcut Dimension 2 from SO or SO Archive
        DimensionValue := '';
        if SalesHeader."No." <> '' then begin
            Dimension.Reset();
            Dimension.SetRange(Code, SalesHeader."Shortcut Dimension 2 Code");
            if Dimension.FindFirst() then
                DimensionValue := Dimension.Name;
        end else if SalesHeaderArchive."No." <> '' then begin
            Dimension.Reset();
            Dimension.SetRange(Code, SalesHeaderArchive."Shortcut Dimension 2 Code");
            if Dimension.FindFirst() then
                DimensionValue := Dimension.Name;
        end;
        ExcelBuffer.AddColumn(DimensionValue, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Department Name - Shortcut Dimension 1 from SO or SO Archive
        DimensionValue := '';
        if SalesHeader."No." <> '' then begin
            Dimension.Reset();
            Dimension.SetRange(Code, SalesHeader."Shortcut Dimension 1 Code");
            if Dimension.FindFirst() then
                DimensionValue := Dimension.Name;
        end else if SalesHeaderArchive."No." <> '' then begin
            Dimension.Reset();
            Dimension.SetRange(Code, SalesHeaderArchive."Shortcut Dimension 1 Code");
            if Dimension.FindFirst() then
                DimensionValue := Dimension.Name;
        end;
        ExcelBuffer.AddColumn(DimensionValue, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //Entry No.
        ExcelBuffer.AddColumn(CustLedgerEntry."Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //Posting Date
        ExcelBuffer.AddColumn(CustLedgerEntry."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        //Customer No.
        ExcelBuffer.AddColumn(Cust."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //Focus customer code
        ExcelBuffer.AddColumn(Cust."Focus Customer No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //Customer Name
        ExcelBuffer.AddColumn(Cust.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //Invoice No. & Invoice Date
        if PostedInvoice."No." <> '' then begin
            ExcelBuffer.AddColumn(PostedInvoice."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PostedInvoice."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        end else begin
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end;
        //Total Amount
        ExcelBuffer.AddColumn(TotalInvoiceAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        //Unapplied Amount
        ExcelBuffer.AddColumn(RemainingAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Total Amount Incl. of GST
        Clear(IGSTAmt);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        Clear(LineAmount);
        if SalesHeader."No." <> '' then begin
            SalesInvHeader.Reset();
            SalesInvHeader.SetRange("Order No.", SalesHeader."No.");
            if SalesInvHeader.FindFirst() then begin
                SalesInvLine.Reset();
                SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
                SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
                if SalesInvLine.FindSet() then
                    repeat
                        LineAmount += SalesInvLine.Amount;
                        DetGSTLedgerEntry.Reset();
                        DetGSTLedgerEntry.SetRange("Document No.", SalesInvHeader."No.");
                        DetGSTLedgerEntry.SetRange("Document Line No.", SalesInvLine."Line No.");
                        DetGSTLedgerEntry.SetRange("Document Type", DetGSTLedgerEntry."Document Type"::Invoice);
                        if DetGSTLedgerEntry.FindSet() then
                            repeat
                                case DetGSTLedgerEntry."GST Component Code" of
                                    'IGST':
                                        IGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                                    'CGST':
                                        CGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                                    'SGST':
                                        SGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                                end;
                            until DetGSTLedgerEntry.Next() = 0;
                    until SalesInvLine.Next() = 0;
            end;
        end;
        ExcelBuffer.AddColumn(LineAmount + CGSTAmt + SGSTAmt + IGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Sales Order Type from sales Order
        if SalesHeader."No." <> '' then
            ExcelBuffer.AddColumn(SalesHeader."Sales Order Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else if SalesHeaderArchive."No." <> '' then
            ExcelBuffer.AddColumn(SalesHeaderArchive."Sales Order Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //SO No,SO Date
        PaymentTermDetail := '';
        if SalesHeader."No." <> '' then begin
            ExcelBuffer.AddColumn(SalesHeader."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SalesHeader."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
            ExcelBuffer.AddColumn(SalesHeader."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SalesHeader."Customer PO Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
            ExcelBuffer.AddColumn(SalesHeader."Payment Terms Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            PaymentTermDetail := CopyStr(SalesHeader."Payment Term Details", 1, 250);
            ExcelBuffer.AddColumn(PaymentTermDetail, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end else if SalesHeaderArchive."No." <> '' then begin
            ExcelBuffer.AddColumn(SalesHeaderArchive."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SalesHeaderArchive."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
            ExcelBuffer.AddColumn(SalesHeaderArchive."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SalesHeaderArchive."Customer PO Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
            ExcelBuffer.AddColumn(SalesHeaderArchive."Payment Terms Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            PaymentTermDetail := CopyStr(SalesHeaderArchive."Payment Term Details", 1, 250);
            ExcelBuffer.AddColumn(PaymentTermDetail, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end else begin
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end;

        //Service TYpe
        ServiceDescription := '';
        if SalesHeader."No." <> '' then begin
            ServiceType.Reset();
            ServiceType.SetRange(Code, SalesHeader.Service_Type_);
            if ServiceType.FindFirst() then
                ServiceDescription := ServiceType."Service Name";
        end else if SalesHeaderArchive."No." <> '' then begin
            ServiceType.Reset();
            ServiceType.SetRange(Code, SalesHeaderArchive.Service_Type_);
            if ServiceType.FindFirst() then
                ServiceDescription := ServiceType."Service Name";
        end;
        ExcelBuffer.AddColumn(ServiceDescription, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Teams Name - Shortcut Dimension 3 from SO or SO Archive
        DimensionValue := '';
        if SalesHeader."No." <> '' then begin
            Dimension.Reset();
            Dimension.SetRange(Code, SalesHeader."Shortcut Dimension 3 Code");
            if Dimension.FindFirst() then
                DimensionValue := Dimension.Name;
        end else if SalesHeaderArchive."No." <> '' then begin
            Dimension.Reset();
            Dimension.SetRange(Code, SalesHeaderArchive."Shortcut Dimension 3 Code");
            if Dimension.FindFirst() then
                DimensionValue := Dimension.Name;
        end;
        ExcelBuffer.AddColumn(DimensionValue, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //Priniciapl
        ExcelBuffer.AddColumn(Principal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        // Key / Non Key
        ExcelBuffer.AddColumn(Cust."KEY/NON KEY(Schimatzu)", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //Due DAte
        ExcelBuffer.AddColumn(CustLedgerEntry."Due Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //Contract From & Contract To
        if SalesHeader."No." <> '' then begin
            ExcelBuffer.AddColumn(SalesHeader."Contract Start Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
            ExcelBuffer.AddColumn(SalesHeader."Contract End Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        end else begin
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end;
        //Group
        ExcelBuffer.AddColumn(Cust."Group Master", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //Engg. Name 1
        if SalesHeader."No." <> '' then
            ExcelBuffer.AddColumn(SalesHeader."Executive Master", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            if SalesHeaderArchive."No." <> '' then
                ExcelBuffer.AddColumn(SalesHeaderArchive."Executive Master", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Engg. Name 2
        if SalesHeader."No." <> '' then
            ExcelBuffer.AddColumn(SalesHeader."Executive Master2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            if SalesHeaderArchive."No." <> '' then
                ExcelBuffer.AddColumn(SalesHeaderArchive."Executive Master2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Engg. Name 3
        if SalesHeader."No." <> '' then
            ExcelBuffer.AddColumn(SalesHeader."Executive Master3", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            if SalesHeaderArchive."No." <> '' then
                ExcelBuffer.AddColumn(SalesHeaderArchive."Executive Master3", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);


        //Engg. Name 4
        if SalesHeader."No." <> '' then
            ExcelBuffer.AddColumn(SalesHeader."Executive Master4", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            if SalesHeaderArchive."No." <> '' then
                ExcelBuffer.AddColumn(SalesHeaderArchive."Executive Master4", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Assg. User ID
        if SalesHeader."No." <> '' then
            ExcelBuffer.AddColumn(SalesHeader."Custom Assigned User ID", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Order Comment
        Clear(OrderComment);
        SalesCommentLine.Reset();
        SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::Order);
        SalesCommentLine.SetRange("No.", SalesHeader."No.");
        SalesCommentLine.SetRange("Document Line No.", 0);
        if SalesCommentLine.FindSet() then
            repeat
                if OrderComment = '' then
                    OrderComment := SalesCommentLine.Comment
                else
                    OrderComment := OrderComment + ' ' + SalesCommentLine.Comment;
            until SalesCommentLine.Next() = 0;

        //Order Comment
        if OrderComment <> '' then
            ExcelBuffer.AddColumn(OrderComment, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Outstading Days
        OutstandingDays := Today - StartDate;
        ExcelBuffer.AddColumn(OutstandingDays, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        Clear(Amt0_30);
        Clear(Amt31_60);
        Clear(Amt61_90);
        Clear(Amt91_120);
        Clear(AmtMore120);

        if OutstandingDays <= 30 then
            Amt0_30 := CustLedgerEntry."Remaining Amount"
        else
            if (OutstandingDays >= 31) and (OutstandingDays <= 60) then
                Amt31_60 := CustLedgerEntry."Remaining Amount"
            else
                if (OutstandingDays >= 61) and (OutstandingDays <= 90) then
                    Amt61_90 := CustLedgerEntry."Remaining Amount"
                else
                    if (OutstandingDays >= 91) and (OutstandingDays <= 120) then
                        Amt91_120 := CustLedgerEntry."Remaining Amount"
                    else
                        if OutstandingDays > 120 then
                            AmtMore120 := CustLedgerEntry."Remaining Amount";
        //0-30 
        ExcelBuffer.AddColumn(Amt0_30, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        //31-60
        ExcelBuffer.AddColumn(Amt31_60, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        //61-90
        ExcelBuffer.AddColumn(Amt61_90, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        //91-120
        ExcelBuffer.AddColumn(Amt91_120, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        //120-more
        ExcelBuffer.AddColumn(AmtMore120, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

    end;

    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('Customer Outstanding');
        ExcelBuffer.WriteSheet('Customer Outstanding', '', '');
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Customer Outstanding');
        ExcelBuffer.OpenExcel();
    end;

    local procedure CreateExcelHeader()
    begin
        ExcelBuffer.NewRow();
        //ExcelBuffer.AddColumn('Details / Report of invoice wise outstanding report including unapplied bank receipts', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        HeadingName := 'Outstanding report for period ' + Format(StartDate) + ' to ' + Format(EndDate);
        ExcelBuffer.AddColumn(HeadingName, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Zone', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Branch Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Department', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Entry No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Posting Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MBD Customer No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Focus customer code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Unapplied Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Amount Incl. of GST', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sales order Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO Number', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PO Number', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PO Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Payment Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Payment Terms', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Service Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Teams Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Principal', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Key/ Non Key', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Due Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Contract From', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Contract To', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Group', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Engineer Name 1', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Engineer Name 2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Engineer Name 3', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Engineer Name 4', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Assigned User ID', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Order Comment', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Outstanding Days', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('0-30 Days', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('31-60 Days', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('61-90 Days', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('91-120 Days', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('120-More Days', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

    end;


    local procedure GetRegionFilter(SelectedRegion: Text): Text
    var
        RegionList: List of [Text];
        RegionCode: Text;
        RegionFilter: Text;
        TempFilter: Text;
    begin
        if SelectedRegion = '' then
            exit('');

        RegionList := SelectedRegion.Split('|');

        foreach RegionCode in RegionList do begin
            TempFilter := GetSingleRegionFilter(CopyStr(RegionCode, 1, 20));

            if TempFilter <> '' then begin
                if RegionFilter <> '' then
                    RegionFilter += '|';

                RegionFilter += TempFilter;
            end;
        end;

        exit(RegionFilter);
    end;

    local procedure GetSingleRegionFilter(SelectedRegion: Code[20]): Text
    var
        DimValue: Record "Dimension Value";
        BeginTotalDimValue: Record "Dimension Value";
        EndTotalDimValue: Record "Dimension Value";
        RegionDimValue: Record "Dimension Value";
        RegionFilter: Text;
    begin
        if SelectedRegion = '' then
            exit('');

        if not DimValue.Get('REGION', SelectedRegion) then
            exit('');

        // Standard Value
        if DimValue."Dimension Value Type" =
           DimValue."Dimension Value Type"::Standard then
            exit(SelectedRegion);

        // Begin-Total selected
        if DimValue."Dimension Value Type" =
           DimValue."Dimension Value Type"::"Begin-Total" then begin

            EndTotalDimValue.Reset();
            EndTotalDimValue.SetRange("Dimension Code", DimValue."Dimension Code");
            EndTotalDimValue.SetRange("Dimension Value Type",
                                      EndTotalDimValue."Dimension Value Type"::"End-Total");

            if EndTotalDimValue.FindSet() then
                repeat
                    if StrPos(EndTotalDimValue.Totaling, DimValue.Code) > 0 then begin

                        RegionDimValue.Reset();
                        RegionDimValue.SetRange("Dimension Code", DimValue."Dimension Code");
                        RegionDimValue.SetRange("Dimension Value Type",
                                                RegionDimValue."Dimension Value Type"::Standard);
                        RegionDimValue.SetFilter(Code, EndTotalDimValue.Totaling);

                        if RegionDimValue.FindSet() then
                            repeat
                                if RegionFilter <> '' then
                                    RegionFilter += '|';

                                RegionFilter += RegionDimValue.Code;
                            until RegionDimValue.Next() = 0;

                        exit(RegionFilter);
                    end;
                until EndTotalDimValue.Next() = 0;
        end;

        // End-Total selected
        if DimValue."Dimension Value Type" =
           DimValue."Dimension Value Type"::"End-Total" then begin

            RegionDimValue.Reset();
            RegionDimValue.SetRange("Dimension Code", DimValue."Dimension Code");
            RegionDimValue.SetRange("Dimension Value Type",
                                    RegionDimValue."Dimension Value Type"::Standard);
            RegionDimValue.SetFilter(Code, DimValue.Totaling);

            if RegionDimValue.FindSet() then
                repeat
                    if RegionFilter <> '' then
                        RegionFilter += '|';

                    RegionFilter += RegionDimValue.Code;
                until RegionDimValue.Next() = 0;

            exit(RegionFilter);
        end;

        exit('');
    end;

    local procedure GetRegionName(SelectedRegions: Text): Text
    var
        RegionList: List of [Text];
        RegionCode: Text;
        SelectedDimValue: Record "Dimension Value";
        BeginTotalDimValue: Record "Dimension Value";
        EndTotalDimValue: Record "Dimension Value";
        RegionName: Text;
        Result: Text;
    begin
        if SelectedRegions = '' then
            exit('');

        RegionList := SelectedRegions.Split('|');

        foreach RegionCode in RegionList do begin

            if not SelectedDimValue.Get('REGION', CopyStr(RegionCode, 1, 20)) then
                continue;

            Clear(RegionName);

            // Begin Total
            if SelectedDimValue."Dimension Value Type" =
               SelectedDimValue."Dimension Value Type"::"Begin-Total" then
                RegionName := SelectedDimValue.Name

            // End Total
            else
                if SelectedDimValue."Dimension Value Type" =
                   SelectedDimValue."Dimension Value Type"::"End-Total" then begin

                    BeginTotalDimValue.Reset();
                    BeginTotalDimValue.SetRange("Dimension Code", SelectedDimValue."Dimension Code");
                    BeginTotalDimValue.SetRange(
                        "Dimension Value Type",
                        BeginTotalDimValue."Dimension Value Type"::"Begin-Total");

                    BeginTotalDimValue.SetFilter(Code, '<%1', SelectedDimValue.Code);

                    if BeginTotalDimValue.FindLast() then
                        RegionName := BeginTotalDimValue.Name;
                end

                // Standard Value
                else begin
                    EndTotalDimValue.Reset();
                    EndTotalDimValue.SetRange("Dimension Code", SelectedDimValue."Dimension Code");
                    EndTotalDimValue.SetRange(
                        "Dimension Value Type",
                        EndTotalDimValue."Dimension Value Type"::"End-Total");

                    if EndTotalDimValue.FindSet() then
                        repeat
                            if StrPos(EndTotalDimValue.Totaling, SelectedDimValue.Code) > 0 then begin

                                BeginTotalDimValue.Reset();
                                BeginTotalDimValue.SetRange("Dimension Code", SelectedDimValue."Dimension Code");
                                BeginTotalDimValue.SetRange(
                                    "Dimension Value Type",
                                    BeginTotalDimValue."Dimension Value Type"::"Begin-Total");

                                BeginTotalDimValue.SetFilter(Code, '<=%1', SelectedDimValue.Code);

                                if BeginTotalDimValue.FindLast() then begin
                                    RegionName := BeginTotalDimValue.Name;
                                    break;
                                end;
                            end;
                        until EndTotalDimValue.Next() = 0;
                end;

            if (RegionName <> '') and
               (StrPos('|' + Result + '|', '|' + RegionName + '|') = 0) then begin

                if Result <> '' then
                    Result += ' | ';

                Result += RegionName;
            end;
        end;

        exit(Result);
    end;

    local procedure GetZoneName(RegionCode: Code[20]): Text
    var
        DimValue: Record "Dimension Value";
        BeginTotalDimValue: Record "Dimension Value";
    begin
        if RegionCode = '' then
            exit('');

        if not DimValue.Get('REGION', RegionCode) then
            exit('');

        // If already Begin-Total
        if DimValue."Dimension Value Type" =
           DimValue."Dimension Value Type"::"Begin-Total" then
            exit(DimValue.Name);

        // Find nearest previous Begin-Total
        BeginTotalDimValue.Reset();
        BeginTotalDimValue.SetRange("Dimension Code", DimValue."Dimension Code");
        BeginTotalDimValue.SetRange(
            "Dimension Value Type",
            BeginTotalDimValue."Dimension Value Type"::"Begin-Total");
        BeginTotalDimValue.SetFilter(Code, '<=%1', RegionCode);

        if BeginTotalDimValue.FindLast() then
            exit(BeginTotalDimValue.Name);

        exit('');
    end;




}


//Old Code COmmented by HG 26 May 2026 --->
// report 50026 "Customer Outstanding"
// {
//     ApplicationArea = All;
//     Caption = 'Customer Outstanding';
//     UsageCategory = ReportsAndAnalysis;
//     ProcessingOnly = true;

//     dataset
//     {
//         dataitem(CustLedgerEntry; "Cust. Ledger Entry")
//         {
//             DataItemTableView = sorting("Posting Date");

//             trigger OnPreDataItem()
//             var
//                 MinDate: Date;
//                 MaxDate: Date;
//             begin
//                 // Auto-calculate FlowField so filter works on Remaining Amount
//                 SetAutoCalcFields("Remaining Amount", Amount);
//                 if CustomerNo <> '' then
//                     SetRange("Customer No.", CustomerNo);

//                 SetFilter("Remaining Amount", '<>%1', 0);
//                 SetFilter("Document Type", '%1|%2|%3', "Document Type"::Invoice, "Document Type"::Payment, "Document Type"::"Credit Memo");
//                 if StartDate = 0D then begin
//                     CustLedgerEntry.SetCurrentKey("Posting Date");
//                     if CustLedgerEntry.FindFirst() then
//                         MinDate := CustLedgerEntry."Posting Date"
//                     else
//                         MinDate := WorkDate();
//                 end else
//                     MinDate := StartDate;

//                 if EndDate = 0D then begin
//                     CustLedgerEntry.SetCurrentKey("Posting Date");
//                     if CustLedgerEntry.FindLast() then
//                         MaxDate := CustLedgerEntry."Posting Date"
//                     else
//                         MaxDate := WorkDate();
//                 end else
//                     MaxDate := EndDate;

//                 if MinDate > MaxDate then
//                     Error('Start Date should not be greater than End Date.');

//                 SetRange("Posting Date", MinDate, MaxDate);

//                 CreateExcelHeader();
//             end;

//             trigger OnAfterGetRecord()
//             begin
//                 ProcessCustLedgerEntry();
//             end;
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group(DataFilter)
//                 {
//                     field(StartDate; StartDate)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Start Date';
//                     }
//                     field(EndDate; EndDate)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'End Date';
//                     }
//                     field(CustomerNo; CustomerNo)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Customer No.';
//                         TableRelation = Customer."No.";
//                     }
//                 }
//             }
//         }
//     }

//     trigger OnPostReport()
//     begin
//         CreateExcelBook();
//     end;

//     var
//         ExcelBuffer: Record "Excel Buffer" temporary;
//         Customer: Record Customer;
//         DetailedCustLedEntry: Record "Cust. Ledger Entry";
//         PostedSalesInvoice: Record "Sales Invoice Header";
//         DocumentTracker: Record "Name/Value Buffer" temporary;
//         Dimension: Record "Dimension Value";
//         StartDate: Date;
//         EndDate: Date;
//         CustomerNo: Code[20];
//         IsFirstOccurrenceOfLedgerEntry: Boolean;
//         IsFirstInvoiceRow: Boolean;
//         DocumentCounter: Integer;

//     local procedure ProcessCustLedgerEntry()
//     var
//         SalesHeader: Record "Sales Header";
//         SalesHeaderArchive: Record "Sales Header Archive";
//         ExternalDocNo: Code[20];
//         InvoiceFound: Boolean;
//     begin
//         CustLedgerEntry.CalcFields("Remaining Amount", Amount);

//         Clear(Customer);
//         if not Customer.Get(CustLedgerEntry."Customer No.") then
//             exit;

//         // Check if this DocNo + CustNo combination has been seen before
//         CheckDocumentOccurrence();

//         InvoiceFound := false;
//         // Reset per-ledger-entry invoice row flag
//         IsFirstInvoiceRow := true;

//         // ---------------------------------------------------------------
//         // INVOICE Document Type: fetch Posted Sales Invoice directly
//         // using CustLedgerEntry."Document No." as the primary lookup,
//         // then get the related Sales Order from PostedSalesInvoice."Order No."
//         // ---------------------------------------------------------------
//         if CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice then begin
//             if PostedSalesInvoice.Get(CustLedgerEntry."Document No.") then begin
//                 InvoiceFound := true;
//                 Clear(SalesHeader);
//                 Clear(SalesHeaderArchive);
//                 GetSalesOrderDetails(PostedSalesInvoice."Order No.", SalesHeader, SalesHeaderArchive);
//                 WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice);
//                 IsFirstInvoiceRow := false;
//             end;
//         end;

//         // ---------------------------------------------------------------
//         // For Payment / Credit Memo OR if Invoice lookup above failed,
//         // fall back to Detailed Cust. Ledger Entry lookup
//         // ---------------------------------------------------------------
//         if not InvoiceFound then begin
//             // Attempt 1: Find via Closed by Entry No.
//             DetailedCustLedEntry.Reset();
//             DetailedCustLedEntry.SetRange("Closed by Entry No.", CustLedgerEntry."Entry No.");
//             if DetailedCustLedEntry.FindSet() then begin
//                 repeat
//                     if PostedSalesInvoice.Get(DetailedCustLedEntry."Document No.") then begin
//                         InvoiceFound := true;
//                         Clear(SalesHeader);
//                         Clear(SalesHeaderArchive);
//                         GetSalesOrderDetails(PostedSalesInvoice."Order No.", SalesHeader, SalesHeaderArchive);
//                         WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice);
//                         IsFirstInvoiceRow := false;
//                     end;
//                 until DetailedCustLedEntry.Next() = 0;
//             end else begin
//                 // Attempt 2: Find via Entry No. = Closed by Entry No.
//                 DetailedCustLedEntry.Reset();
//                 DetailedCustLedEntry.SetRange("Entry No.", CustLedgerEntry."Closed by Entry No.");
//                 if DetailedCustLedEntry.FindSet() then begin
//                     repeat
//                         if PostedSalesInvoice.Get(DetailedCustLedEntry."Document No.") then begin
//                             InvoiceFound := true;
//                             Clear(SalesHeader);
//                             Clear(SalesHeaderArchive);
//                             GetSalesOrderDetails(PostedSalesInvoice."Order No.", SalesHeader, SalesHeaderArchive);
//                             WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice);
//                             IsFirstInvoiceRow := false;
//                         end;
//                     until DetailedCustLedEntry.Next() = 0;
//                 end;
//             end;
//         end;

//         // ---------------------------------------------------------------
//         // No invoice found at all - fallback to External Document No.
//         // for Sales Order lookup and write a row without invoice details
//         // ---------------------------------------------------------------
//         if not InvoiceFound then begin
//             Clear(SalesHeader);
//             Clear(SalesHeaderArchive);
//             Clear(PostedSalesInvoice);
//             ExternalDocNo := CopyStr(CustLedgerEntry."External Document No.", 1, 20);
//             if ExternalDocNo <> '' then
//                 GetSalesOrderDetails(ExternalDocNo, SalesHeader, SalesHeaderArchive);
//             WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice);
//         end;
//     end;

//     local procedure GetSalesOrderDetails(OrderNo: Code[20]; var SalesHeader: Record "Sales Header"; var SalesHeaderArchive: Record "Sales Header Archive")
//     begin
//         Clear(SalesHeader);
//         Clear(SalesHeaderArchive);
//         if OrderNo = '' then
//             exit;
//         // 1. First try active Sales Orders
//         SalesHeader.Reset();
//         SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
//         SalesHeader.SetRange("No.", OrderNo);
//         if SalesHeader.FindFirst() then
//             exit;
//         // 2. Not found - try Sales Header Archive
//         SalesHeaderArchive.Reset();
//         SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
//         SalesHeaderArchive.SetRange("No.", OrderNo);
//         if SalesHeaderArchive.FindLast() then;
//     end;

//     local procedure CheckDocumentOccurrence()
//     var
//         DocNo: Code[20];
//         CustNo: Code[20];
//         CompositeKey: Text[50];
//     begin
//         DocNo := CustLedgerEntry."Document No.";
//         CustNo := CustLedgerEntry."Customer No.";
//         IsFirstOccurrenceOfLedgerEntry := false;

//         if DocNo = '' then begin
//             IsFirstOccurrenceOfLedgerEntry := true;
//             exit;
//         end;

//         CompositeKey := CopyStr(DocNo + '|' + CustNo, 1, 50);

//         DocumentTracker.Reset();
//         DocumentTracker.SetRange(Name, CompositeKey);
//         if not DocumentTracker.FindFirst() then begin
//             // First time this DocNo + CustNo combination is seen
//             IsFirstOccurrenceOfLedgerEntry := true;
//             DocumentCounter += 1;
//             DocumentTracker.Init();
//             DocumentTracker.ID := DocumentCounter;
//             DocumentTracker.Name := CompositeKey;
//             DocumentTracker.Value := Format(CustLedgerEntry."Amount (LCY)");
//             DocumentTracker.Insert();
//         end else
//             IsFirstOccurrenceOfLedgerEntry := false;
//     end;

//     procedure WriteExcelRow(SalesHeader: Record "Sales Header"; SalesHeaderArchive: Record "Sales Header Archive"; Cust: Record Customer; PostedInvoice: Record "Sales Invoice Header")
//     var
//         SalesLine: Record "Sales Line";
//         SalesLineArchive: Record "Sales Line Archive";
//         ServiceType: Record ServiceType;
//         DimensionValue: Text;
//         TotalInvoiceAmount: Decimal;
//         RemainingAmount: Decimal;
//         Principal: Code[20];
//         PaymentTermDetail: Text[250];
//         ServiceDescription: Text[250];
//     begin
//         ExcelBuffer.NewRow();

//         if IsFirstOccurrenceOfLedgerEntry and IsFirstInvoiceRow then begin
//             TotalInvoiceAmount := CustLedgerEntry.Amount;
//             RemainingAmount := CustLedgerEntry."Remaining Amount";
//         end else begin
//             TotalInvoiceAmount := 0;
//             RemainingAmount := 0;
//         end;
//         // Get Principal from Sales Line or Sales Line Archive
//         Principal := '';
//         if SalesHeader."No." <> '' then begin
//             SalesLine.Reset();
//             SalesLine.SetRange("Document Type", SalesHeader."Document Type");
//             SalesLine.SetRange("Document No.", SalesHeader."No.");
//             SalesLine.SetRange(Type, SalesLine.Type::Item);
//             if SalesLine.FindFirst() then
//                 Principal := SalesLine.Principal;
//         end else if SalesHeaderArchive."No." <> '' then begin
//             SalesLineArchive.Reset();
//             SalesLineArchive.SetRange("Document Type", SalesHeaderArchive."Document Type");
//             SalesLineArchive.SetRange("Document No.", SalesHeaderArchive."No.");
//             SalesLineArchive.SetRange("Doc. No. Occurrence", SalesHeaderArchive."Doc. No. Occurrence");
//             SalesLineArchive.SetRange("Version No.", SalesHeaderArchive."Version No.");
//             SalesLineArchive.SetRange(Type, SalesLineArchive.Type::Item);
//             if SalesLineArchive.FindFirst() then
//                 Principal := SalesLineArchive.Principal;
//         end;
//         // Customer Details
//         ExcelBuffer.AddColumn(Cust."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn(Cust.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn(Cust.City, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         // Sales Order Type from sales Order
//         if SalesHeader."No." <> '' then
//             ExcelBuffer.AddColumn(SalesHeader."Sales Order Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
//         else if SalesHeaderArchive."No." <> '' then
//             ExcelBuffer.AddColumn(SalesHeaderArchive."Sales Order Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
//         else
//             ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         // Posted Sales Invoice Details
//         if PostedInvoice."No." <> '' then begin
//             ExcelBuffer.AddColumn(PostedInvoice."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             ExcelBuffer.AddColumn(PostedInvoice."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
//         end else begin
//             ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         end;
//         // Customer Ledger Entry Details
//         ExcelBuffer.AddColumn(TotalInvoiceAmount, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
//         ExcelBuffer.AddColumn(CustLedgerEntry."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
//         ExcelBuffer.AddColumn(RemainingAmount, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
//         ExcelBuffer.AddColumn(CustLedgerEntry."Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn(CustLedgerEntry."Due Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
//         // Principal
//         ExcelBuffer.AddColumn(Principal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         // Branch Name - Shortcut Dimension 2 from SO or SO Archive
//         DimensionValue := '';
//         if SalesHeader."No." <> '' then begin
//             Dimension.Reset();
//             Dimension.SetRange(Code, SalesHeader."Shortcut Dimension 2 Code");
//             if Dimension.FindFirst() then
//                 DimensionValue := Dimension.Name;
//         end else if SalesHeaderArchive."No." <> '' then begin
//             Dimension.Reset();
//             Dimension.SetRange(Code, SalesHeaderArchive."Shortcut Dimension 2 Code");
//             if Dimension.FindFirst() then
//                 DimensionValue := Dimension.Name;
//         end;
//         ExcelBuffer.AddColumn(DimensionValue, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         // Teams Name - Shortcut Dimension 2 from SO or SO Archive
//         DimensionValue := '';
//         if SalesHeader."No." <> '' then begin
//             Dimension.Reset();
//             Dimension.SetRange(Code, SalesHeader."Shortcut Dimension 3 Code");
//             if Dimension.FindFirst() then
//                 DimensionValue := Dimension.Name;
//         end else if SalesHeaderArchive."No." <> '' then begin
//             Dimension.Reset();
//             Dimension.SetRange(Code, SalesHeaderArchive."Shortcut Dimension 3 Code");
//             if Dimension.FindFirst() then
//                 DimensionValue := Dimension.Name;
//         end;
//         ExcelBuffer.AddColumn(DimensionValue, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         //Service Type Description
//         ServiceDescription := '';
//         if SalesHeader."No." <> '' then begin
//             ServiceType.Reset();
//             ServiceType.SetRange(Code, SalesHeader.Service_Type_);
//             if ServiceType.FindFirst() then
//                 ServiceDescription := ServiceType."Service Name";
//         end else if SalesHeaderArchive."No." <> '' then begin
//             ServiceType.Reset();
//             ServiceType.SetRange(Code, SalesHeaderArchive.Service_Type_);
//             if ServiceType.FindFirst() then
//                 ServiceDescription := ServiceType."Service Name";
//         end;
//         ExcelBuffer.AddColumn(ServiceDescription, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         PaymentTermDetail := '';
//         // SO Details - from active Sales Order or Archive
//         if SalesHeader."No." <> '' then begin
//             ExcelBuffer.AddColumn(SalesHeader."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             ExcelBuffer.AddColumn(SalesHeader."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
//             ExcelBuffer.AddColumn(SalesHeader."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             ExcelBuffer.AddColumn(SalesHeader."Customer PO Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
//             ExcelBuffer.AddColumn(SalesHeader."Executive Master", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             PaymentTermDetail := CopyStr(SalesHeader."Payment Term Details", 1, 250);
//             ExcelBuffer.AddColumn(PaymentTermDetail, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         end else if SalesHeaderArchive."No." <> '' then begin
//             ExcelBuffer.AddColumn(SalesHeaderArchive."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             ExcelBuffer.AddColumn(SalesHeaderArchive."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
//             ExcelBuffer.AddColumn(SalesHeaderArchive."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             ExcelBuffer.AddColumn(SalesHeaderArchive."Customer PO Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
//             ExcelBuffer.AddColumn(SalesHeaderArchive."Executive Master", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             PaymentTermDetail := CopyStr(SalesHeaderArchive."Payment Term Details", 1, 250);
//             ExcelBuffer.AddColumn(PaymentTermDetail, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         end else begin
//             ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//             ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         end;
//         // Key / Non Key
//         ExcelBuffer.AddColumn(Cust."KEY/NON KEY(Schimatzu)", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//     end;

//     local procedure CreateExcelBook()
//     begin
//         ExcelBuffer.CreateNewBook('Customer Outstanding');
//         ExcelBuffer.WriteSheet('Customer Outstanding', '', '');
//         ExcelBuffer.CloseBook();
//         ExcelBuffer.SetFriendlyFilename('Customer Outstanding');
//         ExcelBuffer.OpenExcel();
//     end;

//     local procedure CreateExcelHeader()
//     begin
//         ExcelBuffer.NewRow();
//         ExcelBuffer.AddColumn('Details / Report of invoice wise outstanding report including unapplied bank receipts', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.NewRow();
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.NewRow();
//         ExcelBuffer.AddColumn('Customer No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('City', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Sales order Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Invoice No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Invoice Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Total Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Posting Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Unapplied Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Entry No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Due Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Principal', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Branch Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Teams Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Service Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('SO Number', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('SO Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('PO Number', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('PO Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Engineer Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Payment Terms', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Key/ Non Key', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//     end;
// }
//Old Code COmmented by HG 26 May 2026 <---