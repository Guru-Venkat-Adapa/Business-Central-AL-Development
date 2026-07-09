

report 50030 "Landed Cost"
{
    ApplicationArea = All;
    Caption = 'Net Margin Report';
    UsageCategory = None;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");

            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Shipment Header";
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = const(Item), Quantity = filter(> 0));

                trigger OnAfterGetRecord()
                begin
                    CreateExcelBody();
                end;
            }

            trigger OnPreDataItem()
            begin
                if (StartDate = 0D) or (EndDate = 0D) then
                    Error('Start Date and End Date must not be blank.');

                if StartDate > EndDate then
                    Error('Start Date cannot be greater than End Date.');

                SetRange("Posting Date", StartDate, EndDate);

                if SalesOrdeType <> SalesOrdeType::" " then
                    SetRange("Sales Order Type", Format(SalesOrdeType));

                if SalesOrderNo <> '' then
                    SetRange("Order No.", SalesOrderNo);

                CreateExceHeader();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
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

                    field(SalesOrdeType; SalesOrdeType)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Order Type';
                        OptionCaption = ' ,AMC,CLAIMS,CMC,CONSUMBALE,INSTRUMENT,SPARES,SERVICES';
                    }

                    field(SalesOrderNo; SalesOrderNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Order No.';
                        TableRelation = "Sales Header"."No."
                        where("Document Type" = const(Order));
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
        Dimension: Record "Dimension Value";
        SalesCommentLine: Record "Sales Comment Line";
        SalesInvoiceLine: Record "Sales Invoice Line";

        StartDate: Date;
        EndDate: Date;

        SalesOrdeType: Option " ",AMC,CLAIMS,CMC,CONSUMBALE,INSTRUMENT,SPARES,SERVICES;

        SalesOrderNo: Code[20];

        LineComments: Text;

        ImportRateUSD: Decimal;
        INRAccessibleValue: Decimal;
        InsuranceAmount: Decimal;
        Shipmentmode: Code[50];
        CustomDuty: Decimal;
        ExchageRate: Decimal;
        CurrCode: Code[20];
        GstRatePercentage: Record "Gst Rate Percentage";
        ClearingForwarding: Decimal;
        ClearingAmount: Decimal;
        FreightAmount: Decimal;
        IGST: Decimal;
        LandedCost: Decimal;
        BCD: Decimal;
        OtherCharges: Decimal;

    local procedure CreateExcelBody()
    var
        PurchaseRate: Decimal;
        PurchaseValue: Decimal;
        MarginValue: Decimal;
        DimensionValue: Text;
        LotNo: Code[50];
        FolioNo: Code[100];
    begin
        Clear(PurchaseRate);
        Clear(PurchaseValue);
        Clear(MarginValue);
        Clear(DimensionValue);
        Clear(LotNo);
        Clear(FolioNo);

        Clear(ImportRateUSD);
        Clear(INRAccessibleValue);
        Clear(InsuranceAmount);
        Clear(Shipmentmode);

        ExcelBuffer.NewRow();

        // Line Comment
        Clear(LineComments);

        SalesCommentLine.Reset();
        SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::Shipment);
        SalesCommentLine.SetRange("No.", "Sales Shipment Line"."Document No.");
        SalesCommentLine.SetRange("Document Line No.", "Sales Shipment Line"."Line No.");
        if SalesCommentLine.FindSet() then
            repeat
                if LineComments = '' then
                    LineComments := SalesCommentLine.Comment
                else
                    LineComments += ' ' + SalesCommentLine.Comment;
            until SalesCommentLine.Next() = 0;

        // Main Cost Logic
        GetCostFromShipmentLine("Sales Shipment Line", "Sales Shipment Line"."No.", PurchaseRate, LotNo, FolioNo);

        if Customer.Get("Sales Shipment Header"."Sell-to Customer No.") then;

        // Invoice No
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Shipment No.", "Sales Shipment Header"."No.");
        if SalesInvoiceLine.FindFirst() then
            ExcelBuffer.AddColumn(SalesInvoiceLine."Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Doc No
        ExcelBuffer.AddColumn("Sales Shipment Header"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Posting Date
        ExcelBuffer.AddColumn("Sales Shipment Header"."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

        // Department
        Clear(DimensionValue);
        Dimension.Reset();
        Dimension.SetRange(Code, "Sales Shipment Header"."Shortcut Dimension 1 Code");
        if Dimension.FindFirst() then
            DimensionValue := Dimension.Name;

        ExcelBuffer.AddColumn(DimensionValue, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Regional Office
        Clear(DimensionValue);
        Dimension.Reset();
        Dimension.SetRange(Code, "Sales Shipment Header"."Shortcut Dimension 2 Code");
        if Dimension.FindFirst() then
            DimensionValue := Dimension.Name;

        ExcelBuffer.AddColumn(DimensionValue, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Customer
        ExcelBuffer.AddColumn("Sales Shipment Header"."Sell-to Customer No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(Customer.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Item
        ExcelBuffer.AddColumn("Sales Shipment Line"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Shipment Line".Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Quantity
        ExcelBuffer.AddColumn("Sales Shipment Line".Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // Rate
        ExcelBuffer.AddColumn("Sales Shipment Line"."Unit Price", false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Gross
        ExcelBuffer.AddColumn("Sales Shipment Line"."Unit Price" * "Sales Shipment Line".Quantity, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Taxable Value
        ExcelBuffer.AddColumn("Sales Shipment Line"."Unit Price" * "Sales Shipment Line".Quantity, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Purchase Rate
        ExcelBuffer.AddColumn(PurchaseRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Purchase Value
        IF ExchageRate <> 0 then
            PurchaseValue := (PurchaseRate * "Sales Shipment Line".Quantity) * ExchageRate
        ELSE
            PurchaseValue := (PurchaseRate * "Sales Shipment Line".Quantity);

        ExcelBuffer.AddColumn(PurchaseValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Batch Rate
        ExcelBuffer.AddColumn(PurchaseRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Batch
        ExcelBuffer.AddColumn(LotNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Margin
        MarginValue := ("Sales Shipment Line"."Unit Price" * "Sales Shipment Line".Quantity) - PurchaseValue;

        ExcelBuffer.AddColumn(MarginValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //CUrrency Code
        ExcelBuffer.AddColumn(CurrCode, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Currecny Rate
        ExcelBuffer.AddColumn(ExchageRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Import Rate USD
        ExcelBuffer.AddColumn(ImportRateUSD, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Assessable INR
        ExcelBuffer.AddColumn(INRAccessibleValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Insurance
        ExcelBuffer.AddColumn(InsuranceAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Cutom Duty
        ExcelBuffer.AddColumn(CustomDuty, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Clearing & Forwarding
        ExcelBuffer.AddColumn(ClearingForwarding, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Freight Amount
        ExcelBuffer.AddColumn(FreightAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // IGST
        ExcelBuffer.AddColumn(IGST, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Landed Cost
        LandedCost := PurchaseValue + InsuranceAmount + ClearingForwarding + FreightAmount + CustomDuty;
        ExcelBuffer.AddColumn(LandedCost, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Shipment Mode
        ExcelBuffer.AddColumn(Shipmentmode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Folio
        ExcelBuffer.AddColumn(FolioNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Blank Columns
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Regional Group
        Clear(DimensionValue);

        Dimension.Reset();
        Dimension.SetRange(Code, "Sales Shipment Header"."Shortcut Dimension 3 Code");
        if Dimension.FindFirst() then
            DimensionValue := Dimension.Name;

        ExcelBuffer.AddColumn(DimensionValue, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Order No
        ExcelBuffer.AddColumn("Sales Shipment Header"."Order No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Line Comment
        ExcelBuffer.AddColumn(LineComments, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure GetCostFromShipmentLine(
        SalesShipmentLine: Record "Sales Shipment Line";
        ItemNo: Code[20];
        var PurchaseRate: Decimal;
        var LotNo: Code[50];
        var FolioNo: Code[100])
    var
        SaleILE: Record "Item Ledger Entry";
        AppliedILE: Record "Item Ledger Entry";
        ItemApplicationEntry: Record "Item Application Entry";
        ValueEntry: Record "Value Entry";

        PurchInvLine: Record "Purch. Inv. Line";
        PurchInvHeader: Record "Purch. Inv. Header";

        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";

        PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
    begin
        Clear(PurchaseRate);
        Clear(ExchageRate);
        Clear(CustomDuty);
        Clear(INRAccessibleValue);
        Clear(OtherCharges);
        Clear(InsuranceAmount);
        Clear(IGST);
        Clear(ImportRateUSD);
        Clear(ClearingForwarding);
        Clear(FreightAmount);
        Clear(ClearingAmount);
        Clear(Shipmentmode);
        Clear(CurrCode);

        // Find Sale ILE
        SaleILE.Reset();
        SaleILE.SetRange("Document No.", SalesShipmentLine."Document No.");
        SaleILE.SetRange("Document Line No.", SalesShipmentLine."Line No.");
        SaleILE.SetRange("Item No.", ItemNo);
        SaleILE.SetRange("Entry Type", SaleILE."Entry Type"::Sale);
        if not SaleILE.FindFirst() then
            exit;

        LotNo := SaleILE."Lot No.";

        // Find Applied Entry
        ItemApplicationEntry.Reset();
        ItemApplicationEntry.SetRange("Outbound Item Entry No.", SaleILE."Entry No.");
        if not ItemApplicationEntry.FindFirst() then
            exit;

        if not AppliedILE.Get(ItemApplicationEntry."Inbound Item Entry No.")
        then
            exit;

        // Purchase Receipt Logic
        if AppliedILE."Entry Type" = AppliedILE."Entry Type"::Purchase then begin
            if AppliedILE."Document Type" = AppliedILE."Document Type"::"Purchase Receipt" then begin
                if PurchRcptHeader.Get(AppliedILE."Document No.") then begin
                    FolioNo := PurchRcptHeader."Folio No.";

                    PurchRcptLine.Reset();
                    PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
                    PurchRcptLine.SetRange("No.", AppliedILE."Item No.");
                    PurchRcptLine.SetRange("Line No.", AppliedILE."Document Line No.");
                    if PurchRcptLine.FindFirst() then begin
                        // Shipment Mode from Posted Warehouse Receipt
                        if PurchRcptLine."Posted Warehouse Rec No" <> '' then begin
                            if PostedWhseReceiptHeader.Get(PurchRcptLine."Posted Warehouse Rec No")
                            then
                                Shipmentmode := PostedWhseReceiptHeader."Mode Of Shipment";
                        end;
                    end;
                end;
            end;
        end;

        // Value Entry Logic
        ValueEntry.Reset();
        ValueEntry.SetRange("Item Ledger Entry No.", AppliedILE."Entry No.");
        ValueEntry.SetRange("Item No.", ItemNo);
        ValueEntry.SetFilter("Item Charge No.", '=%1', '');
        ValueEntry.SetFilter("Cost per Unit", '<>%1', 0);
        if ValueEntry.FindSet() then
            repeat
                if AppliedILE."Entry Type" = AppliedILE."Entry Type"::"Positive Adjmt." then
                    PurchaseRate += ValueEntry."Cost per Unit"
                else
                    if ValueEntry."Document Type" = ValueEntry."Document Type"::"Purchase Invoice" then
                        PurchaseRate += ValueEntry."Cost per Unit";
                // ONLY Purchase Invoice should populate Import Values
                if ValueEntry."Document Type" = ValueEntry."Document Type"::"Purchase Invoice" then begin
                    if ValueEntry."Item Charge No." = '' then
                        if PurchInvLine.Get(ValueEntry."Document No.", ValueEntry."Document Line No.") then begin
                            ImportRateUSD := PurchInvLine."Direct Unit Cost";
                            if PurchInvHeader.Get(PurchInvLine."Document No.") then begin
                                if (PurchInvHeader."Currency Code" <> '') and
                                   (PurchInvHeader."Currency Factor" <> 0)
                                then begin
                                    INRAccessibleValue := (PurchInvLine.Quantity * PurchInvLine."Direct Unit Cost") * (1 / PurchInvHeader."Currency Factor");
                                    InsuranceAmount := PurchInvLine."Insurance Amount" * (1 / PurchInvHeader."Currency Factor");
                                    OtherCharges := ROUND((PurchInvLine."Line Amount" + PurchInvLine."Freight Amount" + PurchInvLine."Insurance Amount") * BCD / 100, 0.01, '=');
                                    CustomDuty := ROUND(OtherCharges * (1 / PurchInvHeader."Currency Factor"), 0.01, '=');
                                    IGST := IGSTAmount(PurchInvLine);
                                    ExchageRate := 1 / PurchInvHeader."Currency Factor";
                                    CurrCode := PurchInvHeader."Currency Code";
                                end
                                else begin
                                    INRAccessibleValue := PurchInvLine.Quantity * PurchInvLine."Direct Unit Cost";
                                    InsuranceAmount := PurchInvLine."Insurance Amount";
                                    CustomDuty := Round((PurchInvLine."Line Amount" + PurchInvLine."Freight Amount" + PurchInvLine."Insurance Amount") * BCD / 100, 0.01, '=');
                                    IGST := IGSTAmount(PurchInvLine);
                                    ExchageRate := 0;
                                    CurrCode := PurchInvHeader."Currency Code";
                                end;
                            end;
                        end;
                end;
            until ValueEntry.Next() = 0;

        // Positive Adjustment Logic
        // if AppliedILE."Entry Type" = AppliedILE."Entry Type"::"Positive Adjmt." then begin
        //     ValueEntry.Reset();
        //     ValueEntry.SetRange("Item Ledger Entry No.", AppliedILE."Entry No.");
        //     ValueEntry.SetRange("Item No.", ItemNo);
        //     ValueEntry.SetFilter("Cost per Unit", '>%1', 0);
        //     if ValueEntry.FindFirst() then begin
        //         PurchaseRate := ValueEntry."Cost per Unit";
        //         // DO NOT POPULATE IMPORT RATE
        //         // DO NOT POPULATE ACCESSIBLE VALUE
        //         // DO NOT POPULATE INSURANCE
        //     end;
        // end;

        // FINAL SAFETY CHECK
        // If Purchase Invoice not found then clear import fields
        if ImportRateUSD = 0 then begin
            INRAccessibleValue := 0;
            InsuranceAmount := 0;
            OtherCharges := 0;
            CustomDuty := 0;
            IGST := 0;
            OtherCharges := 0;

        end;

        ////Clearing & Forwarding  and freight Amount Calculation --->
        Clear(ClearingForwarding);
        Clear(FreightAmount);
        Clear(ClearingAmount);
        ValueEntry.Reset();
        ValueEntry.SetRange("Item Ledger Entry No.", AppliedILE."Entry No.");
        ValueEntry.SetRange("Item No.", ItemNo);
        ValueEntry.SetFilter("Cost per Unit", '>%1', 0);
        if ValueEntry.FindSet() then begin
            repeat
                PurchInvLine.Reset();
                PurchInvLine.SetRange("Document No.", ValueEntry."Document No.");
                PurchInvLine.SetRange(Type, PurchInvLine.Type::"Charge (Item)");
                PurchInvLine.SetRange("No.", ValueEntry."Item Charge No.");
                PurchInvLine.SetRange("Line No.", ValueEntry."Document Line No.");
                if PurchInvLine.FindFirst() then begin
                    if ValueEntry."Valued Quantity" <> 0 then begin

                        // CLEARING CHARGES
                        if PurchInvLine."No." = 'CLEARING CHARGES' then begin

                            if PurchInvHeader.Get(PurchInvLine."Document No.") then begin

                                if (PurchInvHeader."Currency Code" <> '') and
                                   (PurchInvHeader."Currency Factor" <> 0)
                                then
                                    ClearingForwarding +=
                                        ((ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
                                        * "Sales Shipment Line".Quantity)
                                        * (1 / PurchInvHeader."Currency Factor")
                                else
                                    ClearingForwarding +=
                                        (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
                                        * "Sales Shipment Line".Quantity;
                            end;
                        end;
                        // FOREIGN FREIGHT
                        if PurchInvLine."No." = 'FOREIGN FREIGHT' then begin
                            if PurchInvHeader.Get(PurchInvLine."Document No.") then begin
                                if (PurchInvHeader."Currency Code" <> '') and
                                   (PurchInvHeader."Currency Factor" <> 0)
                                then
                                    FreightAmount +=
                                        ((ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
                                        * "Sales Shipment Line".Quantity)
                                        * (1 / PurchInvHeader."Currency Factor")
                                else
                                    FreightAmount +=
                                        (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
                                        * "Sales Shipment Line".Quantity;
                            end;
                        end;
                    end;
                end;
            until ValueEntry.Next() = 0;
        end;
        ////Clearing & Forwarding  and freight Amount  Calculation <----

    end;



    procedure CreateExceHeader()
    begin
        //1st Header Line
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TOSHVIN ANALYTICAL PVT.LTD.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        //2nd header line
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        // if SalesOrdeType <> SalesOrdeType::" " then
        ExcelBuffer.AddColumn('Margin Statement Detail DC ' + Format(SalesOrdeType), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        // else
        //     ExcelBuffer.AddColumn('Margin Statement Detail DC', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        //3rd header line
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //4th header line
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(' [ Date range ' + Format(StartDate, 0, '<Day,2>/<Month,2>/<Year4>') + ' to ' + Format(EndDate, 0, '<Day,2>/<Month,2>/<Year4>') + ' ]', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        //5th header line
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //6th header line
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Invoice #', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Doc No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Department Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regional Office Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer AC Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer AC Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Gross', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Batch Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Batch', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Margin Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Currency Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Curreancy Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Import Rate/Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Accessible Value in INR', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Insurance Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Custom Duty', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Clearing & Forwarding', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Freight Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IGST', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Landed Cost ', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Shipment mode', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Folio No Master Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Narration', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Programmable Field', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Batch Rate Testing', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BTrt', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regional Group Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Order No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Order Master Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Base Link doc. Number', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Line Comment', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;


    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('Net Margin Report');
        ExcelBuffer.WriteSheet('Net Margin Report', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Net Margin Report');
        ExcelBuffer.OpenExcel();
    end;

    local procedure IGSTAmount(var PurInvLine: Record "Purch. Inv. Line"): Decimal
    var
        DetGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        DetGSTLedgerEntry.Reset();
        DetGSTLedgerEntry.SetRange("Document No.", PurInvLine."Document No.");
        DetGSTLedgerEntry.SetRange("Document Line No.", PurInvLine."Line No.");
        DetGSTLedgerEntry.SetRange("No.", PurInvLine."No.");
        DetGSTLedgerEntry.SetRange("Document Type", DetGSTLedgerEntry."Document Type"::Invoice);
        if DetGSTLedgerEntry.FindSet() then
            if DetGSTLedgerEntry."GST Component Code" = 'IGST' then
                exit(Abs(DetGSTLedgerEntry."GST Amount"));
    end;

}

//Olde code comment by 20/05/20 ----->
// report 50030 "Landed Cost"
// {
//     ApplicationArea = All;
//     Caption = 'Net Margin Report';
//     UsageCategory = ReportsAndAnalysis;
//     ProcessingOnly = true;

//     dataset
//     {
//         dataitem("Sales Shipment Header"; "Sales Shipment Header")
//         {
//             DataItemTableView = sorting("No.");

//             dataitem("Sales Shipment Line"; "Sales Shipment Line")
//             {
//                 DataItemLink = "Document No." = field("No.");
//                 DataItemLinkReference = "Sales Shipment Header";

//                 DataItemTableView = sorting("Document No.", "Line No.")
//                                     where(Type = const(Item),
//                                           Quantity = filter(> 0));

//                 trigger OnAfterGetRecord()
//                 begin
//                     CreateExcelBody();
//                 end;
//             }

//             trigger OnPreDataItem()
//             begin
//                 if (StartDate = 0D) or (EndDate = 0D) then
//                     Error('Start Date and End Date must not be blank.');

//                 if StartDate > EndDate then
//                     Error('Start Date cannot be greater than End Date.');

//                 SetRange("Posting Date", StartDate, EndDate);

//                 if SalesOrdeType <> SalesOrdeType::" " then
//                     SetRange("Sales Order Type", Format(SalesOrdeType));

//                 if SalesOrderNo <> '' then
//                     SetRange("Order No.", SalesOrderNo);

//                 CreateExceHeader();
//             end;
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group(Options)
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

//                     field(SalesOrdeType; SalesOrdeType)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Sales Order Type';
//                         OptionCaption = ' ,AMC,CLAIMS,CMC,CONSUMBALE,INSTRUMENT,SPARES,SERVICES';
//                     }

//                     field(SalesOrderNo; SalesOrderNo)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Sales Order No.';
//                         TableRelation = "Sales Header"."No."
//                         where("Document Type" = const(Order));
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
//         Dimension: Record "Dimension Value";
//         SalesCommentLine: Record "Sales Comment Line";
//         SalesInvoiceLine: Record "Sales Invoice Line";

//         StartDate: Date;
//         EndDate: Date;

//         SalesOrdeType: Option " ",AMC,CLAIMS,CMC,CONSUMBALE,INSTRUMENT,SPARES,SERVICES;

//         SalesOrderNo: Code[20];

//         LineComments: Text;

//         ImportRateUSD: Decimal;
//         INRAccessibleValue: Decimal;
//         InsuranceAmount: Decimal;
//         Shipmentmode: Code[50];
//         CustomDuty: Decimal;
//         GstRatePercentage: Record "Gst Rate Percentage";
//         ClearingForwarding: Decimal;
//         ClearingAmount: Decimal;
//         FreightAmount: Decimal;
//         IGST: Decimal;
//         LandedCost: Decimal;
//         BCD: Decimal;
//         OtherCharges: Decimal;


//     local procedure CreateExcelBody()
//     var
//         PurchaseRate: Decimal;
//         PurchaseValue: Decimal;
//         MarginValue: Decimal;
//         DimensionValue: Text;
//         LotNo: Code[50];
//         FolioNo: Code[100];
//     begin
//         Clear(PurchaseRate);
//         Clear(PurchaseValue);
//         Clear(MarginValue);
//         Clear(DimensionValue);
//         Clear(LotNo);
//         Clear(FolioNo);

//         Clear(ImportRateUSD);
//         Clear(INRAccessibleValue);
//         Clear(InsuranceAmount);
//         Clear(Shipmentmode);

//         ExcelBuffer.NewRow();

//         // Line Comment
//         Clear(LineComments);

//         SalesCommentLine.Reset();
//         SalesCommentLine.SetRange("Document Type",
//                                   SalesCommentLine."Document Type"::Shipment);
//         SalesCommentLine.SetRange("No.",
//                                   "Sales Shipment Line"."Document No.");
//         SalesCommentLine.SetRange("Document Line No.",
//                                   "Sales Shipment Line"."Line No.");

//         if SalesCommentLine.FindSet() then
//             repeat
//                 if LineComments = '' then
//                     LineComments := SalesCommentLine.Comment
//                 else
//                     LineComments += ' ' + SalesCommentLine.Comment;
//             until SalesCommentLine.Next() = 0;

//         // Main Cost Logic
//         GetCostFromShipmentLine(
//             "Sales Shipment Line",
//             "Sales Shipment Line"."No.",
//             PurchaseRate,
//             LotNo,
//             FolioNo);

//         if Customer.Get("Sales Shipment Header"."Sell-to Customer No.") then;

//         // Invoice No
//         SalesInvoiceLine.Reset();
//         SalesInvoiceLine.SetRange("Shipment No.",
//                                   "Sales Shipment Header"."No.");

//         if SalesInvoiceLine.FindFirst() then
//             ExcelBuffer.AddColumn(SalesInvoiceLine."Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
//         else
//             ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         // Doc No
//         ExcelBuffer.AddColumn("Sales Shipment Header"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         // Posting Date
//         ExcelBuffer.AddColumn("Sales Shipment Header"."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

//         // Department
//         Clear(DimensionValue);
//         Dimension.Reset();
//         Dimension.SetRange(Code, "Sales Shipment Header"."Shortcut Dimension 1 Code");

//         if Dimension.FindFirst() then
//             DimensionValue := Dimension.Name;

//         ExcelBuffer.AddColumn(DimensionValue, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         // Regional Office
//         Clear(DimensionValue);
//         Dimension.Reset();
//         Dimension.SetRange(Code, "Sales Shipment Header"."Shortcut Dimension 2 Code");

//         if Dimension.FindFirst() then
//             DimensionValue := Dimension.Name;

//         ExcelBuffer.AddColumn(DimensionValue, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         // Customer
//         ExcelBuffer.AddColumn("Sales Shipment Header"."Sell-to Customer No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn(Customer.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         // Item
//         ExcelBuffer.AddColumn("Sales Shipment Line"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn("Sales Shipment Line".Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         // Quantity
//         ExcelBuffer.AddColumn("Sales Shipment Line".Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

//         // Rate
//         ExcelBuffer.AddColumn("Sales Shipment Line"."Unit Price", false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         // Gross
//         ExcelBuffer.AddColumn(
//             "Sales Shipment Line"."Unit Price" *
//             "Sales Shipment Line".Quantity,
//             false, '', false, false, false, '#,##0.00',
//             ExcelBuffer."Cell Type"::Number);

//         // Taxable Value
//         ExcelBuffer.AddColumn(
//             "Sales Shipment Line"."Unit Price" *
//             "Sales Shipment Line".Quantity,
//             false, '', false, false, false, '#,##0.00',
//             ExcelBuffer."Cell Type"::Number);

//         // Purchase Rate
//         ExcelBuffer.AddColumn(
//             PurchaseRate,
//             false, '', false, false, false, '#,##0.00',
//             ExcelBuffer."Cell Type"::Number);

//         // Purchase Value
//         PurchaseValue := PurchaseRate * "Sales Shipment Line".Quantity;

//         ExcelBuffer.AddColumn(
//             PurchaseValue,
//             false, '', false, false, false, '#,##0.00',
//             ExcelBuffer."Cell Type"::Number);

//         // Batch Rate
//         ExcelBuffer.AddColumn(
//             PurchaseRate,
//             false, '', false, false, false, '#,##0.00',
//             ExcelBuffer."Cell Type"::Number);

//         // Batch
//         ExcelBuffer.AddColumn(
//             LotNo,
//             false, '', false, false, false, '',
//             ExcelBuffer."Cell Type"::Text);

//         // Margin
//         MarginValue :=
//             ("Sales Shipment Line"."Unit Price" *
//              "Sales Shipment Line".Quantity)
//              - PurchaseValue;

//         ExcelBuffer.AddColumn(
//             MarginValue,
//             false, '', false, false, false, '#,##0.00',
//             ExcelBuffer."Cell Type"::Number);

//         // Import Rate USD
//         ExcelBuffer.AddColumn(
//             ImportRateUSD,
//             false, '', false, false, false, '#,##0.00',
//             ExcelBuffer."Cell Type"::Number);

//         // Assessable INR
//         ExcelBuffer.AddColumn(
//             INRAccessibleValue,
//             false, '', false, false, false, '#,##0.00',
//             ExcelBuffer."Cell Type"::Number);

//         // Insurance
//         ExcelBuffer.AddColumn(
//             InsuranceAmount,
//             false, '', false, false, false, '#,##0.00',
//             ExcelBuffer."Cell Type"::Number);

//         //Cutom Duty
//         ExcelBuffer.AddColumn(CustomDuty, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         //Clearing & Forwarding
//         ExcelBuffer.AddColumn(ClearingForwarding, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         //Freight Amount
//         ExcelBuffer.AddColumn(FreightAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         // IGST
//         ExcelBuffer.AddColumn(IGST, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         //Landed Cost
//         LandedCost := ("Sales Shipment Line".Quantity * PurchaseRate) + InsuranceAmount + ClearingForwarding + FreightAmount;
//         ExcelBuffer.AddColumn(LandedCost, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);


//         // Shipment Mode
//         ExcelBuffer.AddColumn(
//             Shipmentmode,
//             false, '', false, false, false, '',
//             ExcelBuffer."Cell Type"::Text);

//         // Folio
//         ExcelBuffer.AddColumn(
//             FolioNo,
//             false, '', false, false, false, '',
//             ExcelBuffer."Cell Type"::Text);

//         // Blank Columns
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         // Regional Group
//         Clear(DimensionValue);

//         Dimension.Reset();
//         Dimension.SetRange(Code,
//                            "Sales Shipment Header"."Shortcut Dimension 3 Code");

//         if Dimension.FindFirst() then
//             DimensionValue := Dimension.Name;

//         ExcelBuffer.AddColumn(
//             DimensionValue,
//             false, '', false, false, false, '',
//             ExcelBuffer."Cell Type"::Text);

//         // Order No
//         ExcelBuffer.AddColumn(
//             "Sales Shipment Header"."Order No.",
//             false, '', false, false, false, '',
//             ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         // Line Comment
//         ExcelBuffer.AddColumn(
//             LineComments,
//             false, '', false, false, false, '',
//             ExcelBuffer."Cell Type"::Text);
//     end;

//     local procedure GetCostFromShipmentLine(
//         SalesShipmentLine: Record "Sales Shipment Line";
//         ItemNo: Code[20];
//         var PurchaseRate: Decimal;
//         var LotNo: Code[50];
//         var FolioNo: Code[100])
//     var
//         SaleILE: Record "Item Ledger Entry";
//         AppliedILE: Record "Item Ledger Entry";
//         ItemApplicationEntry: Record "Item Application Entry";
//         ValueEntry: Record "Value Entry";

//         PurchInvLine: Record "Purch. Inv. Line";
//         PurchInvHeader: Record "Purch. Inv. Header";

//         PurchRcptHeader: Record "Purch. Rcpt. Header";
//         PurchRcptLine: Record "Purch. Rcpt. Line";

//         PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
//     begin
//         Clear(PurchaseRate);

//         // Find Sale ILE
//         SaleILE.Reset();
//         SaleILE.SetRange("Document No.",
//                          SalesShipmentLine."Document No.");

//         SaleILE.SetRange("Document Line No.",
//                          SalesShipmentLine."Line No.");

//         SaleILE.SetRange("Item No.", ItemNo);

//         SaleILE.SetRange("Entry Type",
//                          SaleILE."Entry Type"::Sale);

//         if not SaleILE.FindFirst() then
//             exit;

//         LotNo := SaleILE."Lot No.";

//         // Find Applied Entry
//         ItemApplicationEntry.Reset();
//         ItemApplicationEntry.SetRange(
//             "Outbound Item Entry No.",
//             SaleILE."Entry No.");

//         if not ItemApplicationEntry.FindFirst() then
//             exit;

//         if not AppliedILE.Get(
//             ItemApplicationEntry."Inbound Item Entry No.")
//         then
//             exit;

//         // Purchase Receipt Logic
//         if AppliedILE."Entry Type" =
//            AppliedILE."Entry Type"::Purchase
//         then begin

//             if AppliedILE."Document Type" =
//                AppliedILE."Document Type"::"Purchase Receipt"
//             then begin

//                 if PurchRcptHeader.Get(AppliedILE."Document No.") then begin

//                     FolioNo := PurchRcptHeader."Folio No.";

//                     PurchRcptLine.Reset();
//                     PurchRcptLine.SetRange("Document No.",
//                                            PurchRcptHeader."No.");

//                     PurchRcptLine.SetRange("No.",
//                                            AppliedILE."Item No.");

//                     PurchRcptLine.SetRange("Line No.",
//                                            AppliedILE."Document Line No.");

//                     if PurchRcptLine.FindFirst() then begin

//                         // Shipment Mode from Posted Warehouse Receipt
//                         if PurchRcptLine."Posted Warehouse Rec No" <> '' then begin

//                             if PostedWhseReceiptHeader.Get(
//                                PurchRcptLine."Posted Warehouse Rec No")
//                             then
//                                 Shipmentmode :=
//                                   PostedWhseReceiptHeader."Mode Of Shipment";
//                         end;
//                     end;
//                 end;
//             end;
//         end;

//         // Value Entry Logic
//         ValueEntry.Reset();
//         ValueEntry.SetRange(
//             "Item Ledger Entry No.",
//             AppliedILE."Entry No.");

//         ValueEntry.SetRange("Item No.", ItemNo);

//         ValueEntry.SetFilter("Cost per Unit", '>%1', 0);

//         if ValueEntry.FindSet() then
//             repeat

//                 if ValueEntry."Cost per Unit" <> 0 then
//                     PurchaseRate := ValueEntry."Cost per Unit";

//                 // ONLY Purchase Invoice should populate Import Values
//                 if ValueEntry."Document Type" =
//                    ValueEntry."Document Type"::"Purchase Invoice"
//                 then begin

//                     if PurchInvLine.Get(
//                         ValueEntry."Document No.",
//                         ValueEntry."Document Line No.")
//                     then begin

//                         ImportRateUSD :=
//                             PurchInvLine."Direct Unit Cost";



//                         if PurchInvHeader.Get(
//                             PurchInvLine."Document No.")
//                         then begin

//                             if (PurchInvHeader."Currency Code" <> '') and
//                                (PurchInvHeader."Currency Factor" <> 0)
//                             then begin
//                                 INRAccessibleValue :=
//                                   (PurchInvLine.Quantity *
//                                    PurchInvLine."Direct Unit Cost") /
//                                   PurchInvHeader."Currency Factor";
//                                 InsuranceAmount := PurchInvLine."Insurance Amount" / PurchInvHeader."Currency Factor";
//                                 OtherCharges := ROUND((PurchInvLine."Line Amount" + PurchInvLine."Freight Amount" + PurchInvLine."Insurance Amount") * BCD / 100, 0.01, '=');
//                                 CustomDuty := ROUND(OtherCharges * (1 / PurchInvHeader."Currency Factor"), 0.01, '=');
//                                 IGST := IGSTAmount(PurchInvLine);
//                             end else begin
//                                 INRAccessibleValue :=
//                                   PurchInvLine.Quantity *
//                                   PurchInvLine."Direct Unit Cost";
//                                 InsuranceAmount := PurchInvLine."Insurance Amount";
//                                 CustomDuty := Round((PurchInvLine."Line Amount" + PurchInvLine."Freight Amount" + PurchInvLine."Insurance Amount") * BCD / 100, 0.01, '=');
//                                 IGST := IGSTAmount(PurchInvLine);
//                             end;
//                         end;
//                     end;
//                 end;

//             until ValueEntry.Next() = 0;

//         // Positive Adjustment Logic
//         if AppliedILE."Entry Type" =
//            AppliedILE."Entry Type"::"Positive Adjmt."
//         then begin

//             ValueEntry.Reset();
//             ValueEntry.SetRange(
//                 "Item Ledger Entry No.",
//                 AppliedILE."Entry No.");

//             ValueEntry.SetRange("Item No.", ItemNo);

//             ValueEntry.SetFilter("Cost per Unit", '>%1', 0);

//             if ValueEntry.FindFirst() then begin
//                 PurchaseRate := ValueEntry."Cost per Unit";

//                 // DO NOT POPULATE IMPORT RATE
//                 // DO NOT POPULATE ACCESSIBLE VALUE
//                 // DO NOT POPULATE INSURANCE
//             end;
//         end;

//         // FINAL SAFETY CHECK
//         // If Purchase Invoice not found then clear import fields
//         if ImportRateUSD = 0 then begin
//             INRAccessibleValue := 0;
//             InsuranceAmount := 0;
//             InsuranceAmount := 0;
//             OtherCharges := 0;
//             CustomDuty := 0;
//             IGST := 0;
//             OtherCharges := 0;
//         end;

//         ////Clearing & Forwarding  and freight Amount Calculation --->
//         Clear(ClearingForwarding);
//         Clear(FreightAmount);
//         Clear(ClearingAmount);
//         ValueEntry.Reset();
//         ValueEntry.SetRange("Item Ledger Entry No.", AppliedILE."Entry No.");
//         ValueEntry.SetRange("Item No.", ItemNo);
//         ValueEntry.SetFilter("Cost per Unit", '>%1', 0);
//         if ValueEntry.FindSet() then begin
//             PurchInvLine.Reset();
//             PurchInvLine.SetRange("Document No.", ValueEntry."Document No.");
//             PurchInvLine.SetRange(Type, PurchInvLine.Type::"Charge (Item)");
//             PurchInvLine.SetRange("No.", ValueEntry."Item Charge No.");
//             PurchInvLine.SetRange("Line No.", ValueEntry."Document Line No.");
//             if PurchInvLine.FindFirst() then begin
//                 if PurchInvLine."No." = 'CLEARING CHARGES' then begin
//                     if PurchInvHeader.Get(PurchInvLine."Document No.") then begin

//                         if (PurchInvHeader."Currency Code" <> '') and
//                            (PurchInvHeader."Currency Factor" <> 0)
//                         then
//                             ClearingForwarding :=
//                                ((ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
//                                * "Sales Shipment Line".Quantity)
//                                * (1 / PurchInvHeader."Currency Factor")
//                         else
//                             ClearingForwarding :=
//                                 (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
//                                 * "Sales Shipment Line".Quantity;

//                     end;
//                 end
//                 else
//                     if PurchInvLine."No." = 'FOREIGN FREIGHT' then begin
//                         if PurchInvHeader.Get(PurchInvLine."Document No.") then begin

//                             if (PurchInvHeader."Currency Code" <> '') and
//                                (PurchInvHeader."Currency Factor" <> 0)
//                             then
//                                 FreightAmount :=
//                                     ((ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
//                                     * "Sales Shipment Line".Quantity)
//                                     * (1 / PurchInvHeader."Currency Factor")
//                             else
//                                 FreightAmount :=
//                                     (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
//                                     * "Sales Shipment Line".Quantity;

//                         end;
//                     end;
//             end;
//         end;
//         ////Clearing & Forwarding  and freight Amount  Calculation <----

//     end;

//     local procedure IGSTAmount(var PurInvLine: Record "Purch. Inv. Line"): Decimal
//     var
//         DetGSTLedgerEntry: Record "Detailed GST Ledger Entry";
//     begin
//         DetGSTLedgerEntry.Reset();
//         DetGSTLedgerEntry.SetRange("Document No.", PurInvLine."Document No.");
//         DetGSTLedgerEntry.SetRange("Document Line No.", PurInvLine."Line No.");
//         DetGSTLedgerEntry.SetRange("No.", PurInvLine."No.");
//         DetGSTLedgerEntry.SetRange("Document Type", DetGSTLedgerEntry."Document Type"::Invoice);
//         if DetGSTLedgerEntry.FindSet() then
//             if DetGSTLedgerEntry."GST Component Code" = 'IGST' then
//                 exit(Abs(DetGSTLedgerEntry."GST Amount"));
//     end;

//     procedure CreateExceHeader()
//     begin
//         //1st Header Line
//         ExcelBuffer.NewRow();
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('TOSHVIN ANALYTICAL PVT.LTD.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         //2nd header line
//         ExcelBuffer.NewRow();
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         // if SalesOrdeType <> SalesOrdeType::" " then
//         ExcelBuffer.AddColumn('Margin Statement Detail DC ' + Format(SalesOrdeType), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         // else
//         //     ExcelBuffer.AddColumn('Margin Statement Detail DC', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         //3rd header line
//         ExcelBuffer.NewRow();
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         //4th header line
//         ExcelBuffer.NewRow();
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn(' [ Date range ' + Format(StartDate, 0, '<Day,2>/<Month,2>/<Year4>') + ' to ' + Format(EndDate, 0, '<Day,2>/<Month,2>/<Year4>') + ' ]', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         //5th header line
//         ExcelBuffer.NewRow();
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         //6th header line
//         ExcelBuffer.NewRow();
//         ExcelBuffer.AddColumn('Invoice #', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Doc No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Department Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Regional Office Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Customer AC Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Customer AC Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Item Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Item Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Gross', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Taxable Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Purchase Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Purchase Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Batch Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Batch', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Margin Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn('Import Rate/Value (USD) ', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Accessible Value in INR', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Insurance Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Custom Duty', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Clearing & Forwarding', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Freight Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('IGST', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Landed Cost ', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Shipment mode', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn('Folio No Master Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Narration', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Programmable Field', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Batch Rate Testing', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('BTrt', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Regional Group Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Order No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Order Master Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Base Link doc. Number', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Line Comment', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//     end;


//     local procedure CreateExcelBook()
//     begin
//         ExcelBuffer.CreateNewBook('Net Margin Report');
//         ExcelBuffer.WriteSheet('Net Margin Report', CompanyName, UserId);
//         ExcelBuffer.CloseBook();
//         ExcelBuffer.SetFriendlyFilename('Net Margin Report');
//         ExcelBuffer.OpenExcel();
//     end;
// }
//Old Comment by HG 20/05/2026 <----
