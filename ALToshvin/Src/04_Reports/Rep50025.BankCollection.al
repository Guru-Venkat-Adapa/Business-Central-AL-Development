report 50025 "Bank Collection"
{
    ApplicationArea = All;
    Caption = 'Bank Collection';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(BankAccLedgerEntries; "Bank Account Ledger Entry")
        {
            DataItemTableView = sorting("Posting Date");
            trigger OnAfterGetRecord()
            begin
                ProcessBankEntry();
            end;

            trigger OnPreDataItem()
            var
                MinDate: Date;
                MaxDate: Date;
                BankLedger: Record "Bank Account Ledger Entry";
            begin
                if BankAccountNo <> '' then
                    SetRange("Bank Account No.", BankAccountNo);
                BankLedger.Reset();
                if BankAccountNo <> '' then
                    BankLedger.SetRange("Bank Account No.", BankAccountNo);
                BankLedger.SetCurrentKey("Posting Date");
                if StartDate = 0D then begin
                    if BankLedger.FindFirst() then
                        MinDate := BankLedger."Posting Date"
                    else
                        MinDate := WorkDate();
                end else
                    MinDate := StartDate;
                if EndDate = 0D then begin
                    if BankLedger.FindLast() then
                        MaxDate := BankLedger."Posting Date"
                    else
                        MaxDate := WorkDate();
                end else
                    MaxDate := EndDate;
                if MinDate > MaxDate then
                    Error('Start Date should not be greater than End Date.');
                SetRange("Posting Date", MinDate, MaxDate);

                CreateExcelHeader();
                DocumentTracker.DeleteAll();
                DocumentCounter := 0;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(DateFilter)
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
                    field(BankAccountNo; BankAccountNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Account No.';
                        TableRelation = "Bank Account"."No.";
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
        Dimension: Record "Dimension Value";
        Customer: Record Customer;
        Narration: Record "Posted Narration";
        DocumentTracker: Record "Name/Value Buffer" temporary;
        PostedSalesInvoice: Record "Sales Invoice Header";
        PostedSalesLine: Record "Sales Invoice Line";
        DetailedCustLedEntry: Record "Cust. Ledger Entry";
        StartDate: Date;
        EndDate: Date;
        BankAccountNo: Code[20];
        BankAccountComments: Text;
        DocumentCounter: Integer;
        IsFirstOccurrence: Boolean;
        InvoiceTotal: Decimal;
        InvoiceTaxAmt: Decimal;

    local procedure ProcessBankEntry()
    var
        SalesHeader: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        PostedSalesInvoice: Record "Sales Invoice Header";
        ExternalDocNo: Code[35];
        InvoiceFound: Boolean;
        AppliedDocNo: Code[20];
        AppliedAmount: Decimal;
    begin
        // 1. Get Posted comments of bank account ledger entries
        BankAccountComments := '';
        Narration.Reset();
        Narration.SetRange("Transaction No.", BankAccLedgerEntries."Transaction No.");
        if Narration.FindFirst() then
            BankAccountComments := CopyStr(Narration.Narration, 1, 250);
        // BankAccountComments := Narration.Narration;
        CheckDocumentOccurrence();
        // 2. Find Customer Ledger Entries for this bank entry WHERE Customer No. is NOT blank
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Document No.", BankAccLedgerEntries."Document No.");
        CustLedgerEntry.SetFilter("Customer No.", '<>%1', '');
        if CustLedgerEntry.FindSet() then
            repeat
                // 3. Get Customer record
                Clear(Customer);
                if Customer.Get(CustLedgerEntry."Customer No.") then
                    // 4. Look for applied documents on this Customer Ledger Entry
                    InvoiceFound := false;
                // Pass 1: invoice entries that were closed BY this payment entry
                DetailedCustLedEntry.Reset();
                DetailedCustLedEntry.SetRange("Closed by Entry No.", CustLedgerEntry."Entry No.");
                if DetailedCustLedEntry.FindSet() then begin
                    repeat
                        DetailedCustLedEntry.CalcFields(Amount);
                        AppliedDocNo := DetailedCustLedEntry."Document No.";
                        if DetailedCustLedEntry.Amount <> 0 then
                            AppliedAmount := DetailedCustLedEntry.Amount;
                        Clear(SalesHeader);
                        Clear(SalesHeaderArchive);
                        Clear(PostedSalesInvoice);

                        if PostedSalesInvoice.Get(AppliedDocNo) then begin
                            // Applied document found in Posted Sales Invoice — show full invoice details
                            InvoiceFound := true;
                            GetSalesOrderFromInvoice(PostedSalesInvoice, SalesHeader, SalesHeaderArchive);
                            WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice, '', 0);
                        end else begin
                            // Applied document NOT found in Posted Sales Invoice —put its document no. in the Invoice No.& amount column, leave date blank
                            InvoiceFound := true;
                            WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice, AppliedDocNo, AppliedAmount);
                        end;
                    until DetailedCustLedEntry.Next() = 0;
                end else begin
                    // Pass 2: this ledger entry was closed by another entry — look it up
                    DetailedCustLedEntry.Reset();
                    DetailedCustLedEntry.SetRange("Entry No.", CustLedgerEntry."Closed by Entry No.");
                    if DetailedCustLedEntry.FindSet() then begin
                        repeat
                            DetailedCustLedEntry.CalcFields(Amount);
                            AppliedDocNo := DetailedCustLedEntry."Document No.";
                            if DetailedCustLedEntry.Amount <> 0 then
                                AppliedAmount := DetailedCustLedEntry.Amount;
                            Clear(SalesHeader);
                            Clear(SalesHeaderArchive);
                            Clear(PostedSalesInvoice);

                            if PostedSalesInvoice.Get(AppliedDocNo) then begin
                                // Applied document found in Posted Sales Invoice — show full invoice details
                                InvoiceFound := true;
                                GetSalesOrderFromInvoice(PostedSalesInvoice, SalesHeader, SalesHeaderArchive);
                                WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice, '', 0);
                            end else begin
                                // Applied document NOT found in Posted Sales Invoice —put its document no. in the Invoice No.& amount column, leave date blank
                                InvoiceFound := true;
                                WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice, AppliedDocNo, AppliedAmount);
                            end;
                        until DetailedCustLedEntry.Next() = 0;
                    end;
                end;
                // 5. No applied documents found — write one row with SO lookup but no invoice
                if not InvoiceFound then begin
                    Clear(PostedSalesInvoice);
                    Clear(SalesHeader);
                    Clear(SalesHeaderArchive);
                    ExternalDocNo := CopyStr(BankAccLedgerEntries."External Document No.", 1, 20);
                    GetSalesOrderByExternalDoc(ExternalDocNo, SalesHeader, SalesHeaderArchive);
                    WriteExcelRow(SalesHeader, SalesHeaderArchive, Customer, PostedSalesInvoice, '', 0);
                end;
            until CustLedgerEntry.Next() = 0;
    end;

    local procedure GetSalesOrderFromInvoice(PostedInvoice: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header"; var SalesHeaderArchive: Record "Sales Header Archive")
    var
        OrderNo: Code[20];
        ExternalDocNo: Code[35];
    begin
        Clear(SalesHeader);
        Clear(SalesHeaderArchive);

        OrderNo := PostedInvoice."Order No.";
        if OrderNo <> '' then begin
            SalesHeader.Reset();
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.SetRange("No.", OrderNo);
            if not SalesHeader.FindFirst() then begin
                SalesHeaderArchive.Reset();
                SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
                SalesHeaderArchive.SetRange("No.", OrderNo);
                if SalesHeaderArchive.FindLast() then;
            end;
        end;

        if (SalesHeader."No." = '') and (SalesHeaderArchive."No." = '') then begin
            ExternalDocNo := CopyStr(BankAccLedgerEntries."External Document No.", 1, 20);
            GetSalesOrderByExternalDoc(ExternalDocNo, SalesHeader, SalesHeaderArchive);
        end;
    end;

    local procedure GetSalesOrderByExternalDoc(ExternalDocNo: Code[35]; var SalesHeader: Record "Sales Header"; var SalesHeaderArchive: Record "Sales Header Archive")
    begin
        Clear(SalesHeader);
        Clear(SalesHeaderArchive);

        if ExternalDocNo <> '' then begin
            SalesHeader.Reset();
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.SetRange("No.", ExternalDocNo);
            if not SalesHeader.FindFirst() then begin
                SalesHeaderArchive.Reset();
                SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
                SalesHeaderArchive.SetRange("No.", ExternalDocNo);
                if SalesHeaderArchive.FindLast() then;
            end;
        end;
    end;

    local procedure CheckDocumentOccurrence()
    var
        DocNo: Code[20];
    begin
        DocNo := BankAccLedgerEntries."Document No.";
        IsFirstOccurrence := false;
        if DocNo = '' then begin
            IsFirstOccurrence := true;
            exit;
        end;
        DocumentTracker.Reset();
        DocumentTracker.SetRange(Name, DocNo);
        if not DocumentTracker.FindFirst() then begin
            IsFirstOccurrence := true;
            DocumentCounter += 1;
            DocumentTracker.Init();
            DocumentTracker.ID := DocumentCounter;
            DocumentTracker.Name := DocNo;
            DocumentTracker.Value := Format(BankAccLedgerEntries."Amount (LCY)");
            DocumentTracker.Insert();
        end else
            IsFirstOccurrence := false;
    end;

    local procedure WriteExcelRow(SalesHeader: Record "Sales Header"; SalesHeaderArchive: Record "Sales Header Archive"; Cust: Record Customer; PostedInvoice: Record "Sales Invoice Header"; FallbackInvoiceNo: Code[20]; AppliedAmount: Decimal)
    var
        DimensionValue: Text;
        SalesLine: Record "Sales Line";
        SalesLineArchive: Record "Sales Line Archive";
        PostedSalesLine: Record "Sales Invoice Line";
        InvoiceTotal: Decimal;
        InvoiceTaxableAmt: Decimal;
        SOTotal: Decimal;
        SOTaxableAmt: Decimal;
        AmountToShow: Decimal;
        DebitAmtToShow: Decimal;
        CreditAmtToShow: Decimal;
        DebitAmountwithoutTax: Decimal; //TBC-1049
        TotalDebitAmountwithoutTax: Decimal;//TBC-1049
        FinalTotalDebitAmountwithoutTax: Decimal;//TBC-1049
        //TBC-1075 ---->
        DetGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        SGSTPer: Decimal;
        LineCGSTAmt: Decimal;
        LineSGSTAmt: Decimal;
        LineIGSTAmt: Decimal;
    //TBC-1075 <---
    begin
        ExcelBuffer.NewRow();
        if IsFirstOccurrence then begin
            AmountToShow := BankAccLedgerEntries."Amount (LCY)";
            DebitAmtToShow := BankAccLedgerEntries."Debit Amount";
            CreditAmtToShow := BankAccLedgerEntries."Credit Amount";
        end else begin
            AmountToShow := 0;
            DebitAmtToShow := 0;
            CreditAmtToShow := 0;
        end;
        //OLd Code Commnet By HG 08 July 2026 --->
        // Invoice line totals
        // InvoiceTotal := 0;
        // InvoiceTaxableAmt := 0;
        // if PostedInvoice."No." <> '' then begin
        //     PostedSalesLine.Reset();
        //     PostedSalesLine.SetRange("Document No.", PostedInvoice."No.");
        //     if PostedSalesLine.FindSet() then
        //         repeat
        //             InvoiceTaxableAmt += PostedSalesLine."Line Amount";
        //             InvoiceTotal += PostedSalesLine."Line Amount" +
        //                            PostedSalesLine."CGST Amount" +
        //                            PostedSalesLine."SGST Amount" +
        //                            PostedSalesLine."IGST Amount";
        //         until PostedSalesLine.Next() = 0;
        // end;
        //OLd Code Commnet By HG 08 July 2026 <---

        //TBC-1075 ------>
        InvoiceTotal := 0;
        InvoiceTaxableAmt := 0;
        Clear(IGSTAmt);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        Clear(IGSTPer);
        Clear(CGSTPer);
        Clear(SGSTPer);

        if PostedInvoice."No." <> '' then begin
            PostedSalesLine.Reset();
            PostedSalesLine.SetRange("Document No.", PostedInvoice."No.");
            if PostedSalesLine.FindSet() then
                repeat
                    InvoiceTaxableAmt += PostedSalesLine."Line Amount";

                    // reset per-line accumulators
                    LineCGSTAmt := 0;
                    LineSGSTAmt := 0;
                    LineIGSTAmt := 0;

                    DetGSTLedgerEntry.Reset();
                    DetGSTLedgerEntry.SetRange("Document No.", PostedInvoice."No.");
                    DetGSTLedgerEntry.SetRange("Document Line No.", PostedSalesLine."Line No.");
                    DetGSTLedgerEntry.SetRange("Document Type", DetGSTLedgerEntry."Document Type"::Invoice);
                    if DetGSTLedgerEntry.FindSet() then
                        repeat
                            case DetGSTLedgerEntry."GST Component Code" of
                                'IGST':
                                    LineIGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                                'CGST':
                                    LineCGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                                'SGST':
                                    LineSGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            end;
                        until DetGSTLedgerEntry.Next() = 0;

                    // accumulate invoice-level totals (for footer/summary if needed)
                    CGSTAmt += LineCGSTAmt;
                    SGSTAmt += LineSGSTAmt;
                    IGSTAmt += LineIGSTAmt;

                    // correct per-line contribution
                    InvoiceTotal += PostedSalesLine."Line Amount" + LineCGSTAmt + LineSGSTAmt + LineIGSTAmt;
                until PostedSalesLine.Next() = 0;
        end;
        //TBC-1075 <-----

        // SO line totals
        SOTotal := 0;
        SOTaxableAmt := 0;
        DebitAmountwithoutTax := 0; //TBC-1049

        if SalesHeader."No." <> '' then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            if SalesLine.FindSet() then
                repeat
                    SOTaxableAmt += SalesLine."Line Amount";
                    SOTotal += SalesLine."Line Amount" +
                              SalesLine."CGST Amount" +
                              SalesLine."SGST Amount" +
                              SalesLine."IGST Amount";
                    DebitAmountwithoutTax += SalesLine."CGST Amount" + SalesLine."SGST Amount" + SalesLine."IGST Amount"; //TBC-1049
                until SalesLine.Next() = 0;
        end else if SalesHeaderArchive."No." <> '' then begin
            SalesLineArchive.Reset();
            SalesLineArchive.SetRange("Document Type", SalesHeaderArchive."Document Type");
            SalesLineArchive.SetRange("Document No.", SalesHeaderArchive."No.");
            SalesLineArchive.SetRange("Doc. No. Occurrence", SalesHeaderArchive."Doc. No. Occurrence");
            SalesLineArchive.SetRange("Version No.", SalesHeaderArchive."Version No.");
            SalesLineArchive.SetRange(Type, SalesLineArchive.Type::Item);
            if SalesLineArchive.FindSet() then
                repeat
                    SOTaxableAmt += SalesLineArchive."Line Amount";
                    SOTotal += SalesLineArchive."Line Amount" +
                              SalesLineArchive."CGST Amount" +
                              SalesLineArchive."SGST Amount" +
                              SalesLineArchive."IGST Amount";
                    DebitAmountwithoutTax += SalesLineArchive."CGST Amount" + SalesLineArchive."SGST Amount" + SalesLineArchive."IGST Amount"; //TBC-1049
                until SalesLineArchive.Next() = 0;
        end;
        // Regional Office Name (Dimension 2 Name)
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
        ExcelBuffer.AddColumn(BankAccLedgerEntries."Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(BankAccLedgerEntries."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        // Customer Details
        if Cust."No." <> '' then begin
            ExcelBuffer.AddColumn(Cust.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(Cust."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(Cust.City, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end else begin
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end;
        // Type of Order
        if SalesHeader."No." <> '' then
            ExcelBuffer.AddColumn(SalesHeader."Sales Order Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else if SalesHeaderArchive."No." <> '' then
            ExcelBuffer.AddColumn(SalesHeaderArchive."Sales Order Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        // Department Name (Dimension 1 Name)
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
        // Cheque Details
        ExcelBuffer.AddColumn(BankAccLedgerEntries."Cheque No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(BankAccLedgerEntries."Cheque Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(AmountToShow, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        // Team Code (Dimension 3 Name)
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
        // SO Details
        if SalesHeader."No." <> '' then begin
            ExcelBuffer.AddColumn(SalesHeader."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SalesHeader."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        end else if SalesHeaderArchive."No." <> '' then begin
            ExcelBuffer.AddColumn(SalesHeaderArchive."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SalesHeaderArchive."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        end else begin
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end;
        // Invoice Details
        // Case 1: Real Posted Sales Invoice found — show all details
        // Case 2: Applied doc exists but NOT in PSI — show FallbackInvoiceNo in Invoice No. column only
        // Case 3: No applied doc — leave blank
        if PostedInvoice."No." <> '' then begin
            ExcelBuffer.AddColumn(PostedInvoice."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PostedInvoice."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
            ExcelBuffer.AddColumn(InvoiceTotal, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        end else if FallbackInvoiceNo <> '' then begin
            ExcelBuffer.AddColumn(FallbackInvoiceNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(AppliedAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        end else begin
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        end;
        // Debit / Credit / Taxable Amounts
        ExcelBuffer.AddColumn(DebitAmtToShow, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(CreditAmtToShow, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(InvoiceTaxableAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        // SO Amount
        ExcelBuffer.AddColumn(SOTotal, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //TBC-1049 --->
        TotalDebitAmountwithoutTax := 0;
        FinalTotalDebitAmountwithoutTax := 0;
        if (PostedInvoice."No." = '') AND (SOTotal <> 0) then begin
            TotalDebitAmountwithoutTax := (DebitAmtToShow * DebitAmountwithoutTax) / SOTotal;
            FinalTotalDebitAmountwithoutTax := DebitAmtToShow - TotalDebitAmountwithoutTax;
        end else
            if PostedInvoice."No." <> '' then begin
                PostedInvoice.CalcFields(Amount);
                FinalTotalDebitAmountwithoutTax := PostedInvoice.Amount;
            end;
        ExcelBuffer.AddColumn(FinalTotalDebitAmountwithoutTax, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        //TBC-1049 <---


        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Total Payment Received
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Balance Payment
        // Customer PO Details
        if SalesHeader."No." <> '' then begin
            ExcelBuffer.AddColumn(SalesHeader."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SalesHeader."Customer PO Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        end else if SalesHeaderArchive."No." <> '' then begin
            ExcelBuffer.AddColumn(SalesHeaderArchive."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SalesHeaderArchive."Customer PO Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        end else begin
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end;
        // Executive Master Details
        if SalesHeader."No." <> '' then begin
            ExcelBuffer.AddColumn(SalesHeader."Executive Master", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SalesHeader."Executive Master2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SalesHeader.Service_Type_, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end else if SalesHeaderArchive."No." <> '' then begin
            ExcelBuffer.AddColumn(SalesHeaderArchive."Executive Master", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SalesHeaderArchive."Executive Master2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SalesHeaderArchive.Service_Type_, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end else begin
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end;
        // Transaction Narration
        ExcelBuffer.AddColumn(BankAccountComments, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        // Key / Non Key
        if Cust."No." <> '' then
            ExcelBuffer.AddColumn(Cust."KEY/NON KEY(Schimatzu)", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        IsFirstOccurrence := false;
    end;

    local procedure CreateExcelHeader()
    begin
        // First row with note
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('If Payment is not tagged it will remain blank', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        // Header row
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Regional Office Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Document No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('City Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Type of Order', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Department Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cheque No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cheque Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cheque Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Teams Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO. No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO. Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Debit Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Credit Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Amount of Invoice', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO Amount (Including Tax)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Debit Amount without Tax', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); //TBC-1049
        ExcelBuffer.AddColumn('Total Payment Received against SO', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Balance Payment to be received against SO', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer PO No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer PO Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Executive Master Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Executive Master2 Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Service Type Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Transaction Narration', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Key / Non Key', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('Bank Account Collection');
        ExcelBuffer.WriteSheet('Bank Collection', '', '');
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Bank Account Collection');
        ExcelBuffer.OpenExcel();
    end;
}
