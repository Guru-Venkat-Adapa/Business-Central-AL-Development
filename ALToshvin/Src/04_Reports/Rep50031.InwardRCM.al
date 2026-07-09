report 50031 "Inward & RCM"
{
    ApplicationArea = All;
    Caption = 'Inward & RCM';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = sorting("No.");


            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLinkReference = "Purch. Inv. Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter(<> " "));

                trigger OnAfterGetRecord()
                begin
                    MakeExcelDataBody();
                end;
            }

            trigger OnPreDataItem()
            begin
                if (StartDate = 0D) or (EndDate = 0D) then
                    Error('From Date and To Date should not be blank.');

                if StartDate > EndDate then
                    Error('From Date should not be greater than To Date.');

                SetRange("Posting Date", StartDate, EndDate);

                if LocationCode <> '' then
                    SetRange("Location Code", LocationCode);

                MakeExcelDataHeader();
            end;
        }
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = sorting("No.");

            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemLinkReference = "Purch. Cr. Memo Hdr.";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter(<> " "));

                trigger OnAfterGetRecord()
                begin
                    MakeExcelDataBody_CrMemo();
                end;
            }

            trigger OnPreDataItem()
            begin

                if (StartDate = 0D) or (EndDate = 0D) then
                    Error('From Date and To Date should not be blank.');

                if StartDate > EndDate then
                    Error('From Date should not be greater than To Date.');

                SetRange("Posting Date", StartDate, EndDate);

                if LocationCode <> '' then
                    SetRange("Location Code", LocationCode);
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
                    Caption = 'Filters';
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
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Location Code';
                        TableRelation = Location.Code;
                    }
                }
            }
        }
    }


    trigger OnPreReport()
    begin
        Clear(TotalTaxableInv);
        Clear(TotalTaxableCrMemo);
        Clear(FinalTaxableTotal);
        Clear(TotalInvIGSTAmt);
        Clear(TotalCrMemoIGSTAmt);
        Clear(FinalIGSTAmt);
        Clear(TotalInvCGSTAmt);
        Clear(TotalCrMemoCGSTAmt);
        Clear(FinalCGSTAmt);
        Clear(TotalInvSGSTAmt);
        Clear(TotalCrMemoSGSTAmt);
        Clear(FinalSGSTAmt);
        Clear(TotalInvAmt);
        Clear(TotalCrMemoAmt);
        Clear(GrnadTotal);
        ExcelBuffer.DELETEALL;
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPostReport()
    begin
        AddGrandTotalRow();
        CreateExcelBook();
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 1
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 2
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 3
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 4
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CompanyInfo.Name, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 5 (center)

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 1
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 2
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 3
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 4
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        WarehouseNameHeader := '';
        if LocationCode <> '' then
            WarehouseNameHeader := 'Warehouse Name = ' + Format(LocationCode)
        else
            WarehouseNameHeader := 'Warehouse Name = All Warehouse';

        ExcelBuffer.AddColumn(WarehouseNameHeader, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 1
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 2
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 3
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 4
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('[ Previous Month ' + Format(StartDate) + ' to ' + Format(EndDate) + ' ]', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();

        // Column headers
        ExcelBuffer.AddColumn('Warehouse Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Supplier State', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn('Month of Availment of ITC ', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Posting Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Voucher Number', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date of Receipt of Goods / Services', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor GSTIN', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Type of Procurement', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice/ Debit Note/ Credit Note No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice/ Debit Note/ Credit Note Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HSN of Supplies', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Nature of Inward Supplies', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Description of Procurements', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Currency Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Exchange Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Insurance Charge', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Freight Charge', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate of Tax', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IGST', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CGST', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SGST', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date of Payment', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Unit of Measurement', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Port Code (Imports)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Bill of Entry No. (Imports)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Bill of Entry Date (Imports)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Reference Date (Import)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Invoice Reference (Credit / Debit Notes)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Invoice Date (Credit / Debit Notes)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Ledger Head Debited', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody()
    var
    begin
        ExcelBuffer.NewRow();

        // Location Code
        if "Purch. Inv. Header"."Location Code" <> '' then
            ExcelBuffer.AddColumn("Purch. Inv. Header"."Location Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            if "Purch. Inv. Line"."Location Code" <> '' then
                ExcelBuffer.AddColumn("Purch. Inv. Line"."Location Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);


        // Location State Description
        if "Purch. Inv. Header"."Location Code" <> '' then begin
            if RecState.Get("Purch. Inv. Header"."Location State Code") then
                ExcelBuffer.AddColumn(RecState.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        end else
            if "Purch. Inv. Line"."Location Code" <> '' then begin
                if Loc.Get("Purch. Inv. Line"."Location Code") then
                    if RecState.Get(Loc."State Code") then
                        ExcelBuffer.AddColumn(RecState.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
            end else
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        Clear(MonthYearTxt);
        MonthYearTxt := Format("Purch. Inv. Header"."Posting Date", 0, '<Month Text,3>-<Year4>');
        if MonthYearTxt <> '' then
            ExcelBuffer.AddColumn(MonthYearTxt, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Purch. Inv. Header"."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Purch. Inv. Header"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Purch. Inv. Header"."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Purch. Inv. Header"."Vendor GST Reg. No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Purch. Inv. Header"."Buy-from Vendor Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        if "Purch. Inv. Header"."Vendor Invoice No." <> '' then
            ExcelBuffer.AddColumn("Purch. Inv. Header"."Vendor Invoice No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Purch. Inv. Header"."Document Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

        ExcelBuffer.AddColumn("Purch. Inv. Line"."HSN/SAC Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        Clear(HSNCode);
        Clear(NatureOfInwards);
        if "Purch. Inv. Line"."HSN/SAC Code" <> '' then
            HSNCode := CopyStr("Purch. Inv. Line"."HSN/SAC Code", 1, 2);

        if HSNCode = '99' then
            NatureOfInwards := 'Input Service'
        else if HSNCode <> '' then
            NatureOfInwards := 'Inputs';

        if NatureOfInwards <> '' then
            ExcelBuffer.AddColumn(NatureOfInwards, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);


        Clear(Narration);

        if ("Purch. Inv. Line".Type = "Purch. Inv. Line".Type::"G/L Account") or
           ("Purch. Inv. Line".Type = "Purch. Inv. Line".Type::"Fixed Asset") then begin

            PurchaeCommentLine.Reset();
            PurchaeCommentLine.SetRange("No.", "Purch. Inv. Header"."No.");
            PurchaeCommentLine.SetRange("Document Line No.", 0);
            PurchaeCommentLine.SetRange("Document Type", PurchaeCommentLine."Document Type"::"Posted Invoice");

            if PurchaeCommentLine.FindSet() then
                repeat
                    if Narration = '' then
                        Narration := PurchaeCommentLine.Comment
                    else
                        Narration := Narration + ' ' + PurchaeCommentLine.Comment;
                until PurchaeCommentLine.Next() = 0;
        end;

        if Narration <> '' then
            ExcelBuffer.AddColumn(CopyStr(Narration, 1, 250), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn("Purch. Inv. Line".Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Purch. Inv. Header"."Currency Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        if "Purch. Inv. Header"."Currency Factor" <> 0 then
            ExcelBuffer.AddColumn(1 / "Purch. Inv. Header"."Currency Factor", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(Round("Purch. Inv. Line"."Insurance Amount", 0.01), false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(Round("Purch. Inv. Line"."Freight Amount", 0.01), false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);


        Clear(IGSTAmt);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        Clear(IGSTPer);
        Clear(CGSTPer);
        Clear(SGSTPer);
        DetGSTLedgerEntry.Reset();
        DetGSTLedgerEntry.SetRange("Document No.", "Purch. Inv. Header"."No.");
        DetGSTLedgerEntry.SetRange("Document Line No.", "Purch. Inv. Line"."Line No.");
        DetGSTLedgerEntry.SetRange("Document Type", DetGSTLedgerEntry."Document Type"::Invoice);
        if DetGSTLedgerEntry.FindSet() then
            repeat
                case DetGSTLedgerEntry."GST Component Code" of
                    'IGST':
                        begin
                            IGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            IGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                    'CGST':
                        begin
                            CGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            CGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                    'SGST':
                        begin
                            SGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            SGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                end;
            until DetGSTLedgerEntry.Next() = 0;

        if IGSTPer <> 0 then
            ExcelBuffer.AddColumn(IGSTPer, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn(CGSTPer + SGSTPer, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);


        Clear(OtherCharge);
        Clear(ExchRate);
        Clear(ImportTaxAmt);

        if "Purch. Inv. Header"."GST Vendor Type" = "Purch. Inv. Header"."GST Vendor Type"::Import then begin
            // Calculate Other Charges
            OtherCharge := "Purch. Inv. Line"."Freight Amount" +
                           "Purch. Inv. Line"."Insurance Amount" +
                           "Purch. Inv. Line"."Line Amount";

            Clear(KFloodPer);
            Clear(CustomDuty);

            GSTRate.Reset();
            GSTRate.SetRange("From State", '');
            GSTRate.SetRange("Location State Code", "Purch. Inv. Header"."Location State Code");
            GSTRate.SetRange("GST Group Code", "Purch. Inv. Line"."GST Group Code");
            if GSTRate.FindFirst() then
                KFloodPer := GSTRate."KFloodCess Percentage";

            CustomDuty := OtherCharge * KFloodPer / 100;
            ImportTaxAmt := OtherCharge + CustomDuty;
        end;

        if ImportTaxAmt <> 0 then begin
            ExcelBuffer.AddColumn(ImportTaxAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(ImportTaxAmt * IGSTPer / 100, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        end else begin
            ExcelBuffer.AddColumn("Purch. Inv. Line".Amount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(IGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        end;

        ExcelBuffer.AddColumn(CGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        Clear(PaymentDate);
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        VendorLedgerEntry.SetRange("Document No.", "Purch. Inv. Header"."No.");
        if VendorLedgerEntry.FindFirst() then begin
            PaymentVendLedgEntry.Reset();
            PaymentVendLedgEntry.SetRange("Entry No.", VendorLedgerEntry."Closed by Entry No.");
            PaymentVendLedgEntry.SetCurrentKey("Posting Date");
            PaymentVendLedgEntry.Ascending(true);
            if PaymentVendLedgEntry.FindLast() then begin
                PaymentDate := PaymentVendLedgEntry."Posting Date";
            end;
        end;

        if PaymentDate <> 0D then
            ExcelBuffer.AddColumn(PaymentDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Purch. Inv. Line".Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Purch. Inv. Line"."Unit of Measure Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);


        Clear(PortCode);
        if "Purch. Inv. Header"."Port Code (Imports)" <> '' then
            PortCode := "Purch. Inv. Header"."Port Code (Imports)"
        else begin
            PurchRcptHeader.Reset();    // 2. Get from Purch. Receipt Header
            PurchRcptHeader.SetRange("No.", "Purch. Inv. Line"."Receipt No.");
            if PurchRcptHeader.FindFirst() then begin
                PostedWhseReceiptLine.Reset();    // 3. Get from Posted Whse Receipt Line
                PostedWhseReceiptLine.SetRange("Posted Source Document", PostedWhseReceiptLine."Posted Source Document"::"Posted Receipt");
                PostedWhseReceiptLine.SetRange("Posted Source No.", PurchRcptHeader."No.");
                if PostedWhseReceiptLine.FindFirst() then begin
                    PostedWhseReceiptHeader.Reset();      // 4. Get from Posted Whse Receipt Header
                    PostedWhseReceiptHeader.SetRange("No.", PostedWhseReceiptLine."No.");
                    if PostedWhseReceiptHeader.FindFirst() then
                        PortCode := PostedWhseReceiptHeader."Port Code";
                end;
            end;
        end;

        if PortCode <> '' then
            ExcelBuffer.AddColumn(PortCode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        if "Purch. Inv. Header"."Bill of Entry No." <> '' then
            ExcelBuffer.AddColumn("Purch. Inv. Header"."Bill of Entry No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        if "Purch. Inv. Header"."Bill of Entry Date" <> 0D then
            ExcelBuffer.AddColumn("Purch. Inv. Header"."Bill of Entry Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn("Purch. Inv. Header"."Bill of Entry Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

        if "Purch. Inv. Header"."Reference Date (Import)" <> 0D then
            ExcelBuffer.AddColumn("Purch. Inv. Header"."Reference Date (Import)", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        Clear(GLName);
        if "Purch. Inv. Line".Type = "Purch. Inv. Line".Type::"G/L Account" then begin
            if GLAccount.Get("Purch. Inv. Line"."No.") then
                GLName := GLAccount.Name;
        end
        else
            if "Purch. Inv. Line".Type = "Purch. Inv. Line".Type::Item then begin
                if GenPostingSetup.Get(
                    "Purch. Inv. Line"."Gen. Bus. Posting Group",
                    "Purch. Inv. Line"."Gen. Prod. Posting Group") then begin

                    GLEntry.Reset();
                    GLEntry.SetRange("Document Type", GLEntry."Document Type"::Invoice);
                    GLEntry.SetRange("Document No.", "Purch. Inv. Header"."No.");
                    GLEntry.SetRange("G/L Account No.", GenPostingSetup."Purch. Account");
                    if GLEntry.FindFirst() then
                        if GLAccount.Get(GLEntry."G/L Account No.") then
                            GLName := GLAccount.Name;
                end;
            end
            else
                if "Purch. Inv. Line".Type = "Purch. Inv. Line".Type::"Fixed Asset" then begin
                    GLEntry.Reset();
                    GLEntry.SetRange("Document Type", GLEntry."Document Type"::Invoice);
                    GLEntry.SetRange("Document No.", "Purch. Inv. Header"."No.");
                    if GLEntry.FindFirst() then
                        if GLAccount.Get(GLEntry."G/L Account No.") then
                            GLName := GLAccount.Name;
                end;

        if GLName <> '' then
            ExcelBuffer.AddColumn(GLName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn("Purch. Inv. Line".Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        if ImportTaxAmt <> 0 then begin
            TotalTaxableInv += ImportTaxAmt;
            TotalInvIGSTAmt += ImportTaxAmt * IGSTPer / 100;
        end else begin
            TotalTaxableInv += "Purch. Inv. Line".Amount;
            TotalInvIGSTAmt += IGSTAmt;
        end;
        TotalInvCGSTAmt += CGSTAmt;
        TotalInvSGSTAmt += SGSTAmt;
    end;

    local procedure MakeExcelDataBody_CrMemo()
    begin
        ExcelBuffer.NewRow();

        // Location Code
        if "Purch. Cr. Memo Hdr."."Location Code" <> '' then
            ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Location Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            if "Purch. Cr. Memo Line"."Location Code" <> '' then
                ExcelBuffer.AddColumn("Purch. Cr. Memo Line"."Location Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);


        // Location State Description
        if "Purch. Cr. Memo Hdr."."Location Code" <> '' then begin
            if RecState.Get("Purch. Cr. Memo Hdr."."Location State Code") then
                ExcelBuffer.AddColumn(RecState.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        end else
            if "Purch. Cr. Memo Line"."Location Code" <> '' then begin
                if Loc.Get("Purch. Cr. Memo Line"."Location Code") then
                    if RecState.Get(Loc."State Code") then
                        ExcelBuffer.AddColumn(RecState.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
            end else
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        Clear(MonthYearTxt);
        MonthYearTxt := Format("Purch. Cr. Memo Hdr."."Posting Date", 0, '<Month Text,3>-<Year4>');
        if MonthYearTxt <> '' then
            ExcelBuffer.AddColumn(MonthYearTxt, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Vendor GST Reg. No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Buy-from Vendor Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Credit Memo', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Document Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

        ExcelBuffer.AddColumn("Purch. Cr. Memo Line"."HSN/SAC Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        Clear(HSNCode);
        Clear(NatureOfInwards);
        if "Purch. Cr. Memo Line"."HSN/SAC Code" <> '' then
            HSNCode := CopyStr("Purch. Cr. Memo Line"."HSN/SAC Code", 1, 2)
        else
            HSNCode := '';

        if HSNCode = '99' then
            NatureOfInwards := 'Input Service'
        else if HSNCode <> '' then
            NatureOfInwards := 'Inputs';

        if NatureOfInwards <> '' then
            ExcelBuffer.AddColumn(NatureOfInwards, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        Clear(GLName);

        if ("Purch. Cr. Memo Line".Type in
           ["Purch. Cr. Memo Line".Type::"G/L Account",
            "Purch. Cr. Memo Line".Type::"Fixed Asset"]) then begin
            if GenPostingSetup.Get(
                "Purch. Cr. Memo Line"."Gen. Bus. Posting Group",
                "Purch. Cr. Memo Line"."Gen. Prod. Posting Group") then begin

                GLEntry.Reset();
                GLEntry.SetRange("Document Type", GLEntry."Document Type"::"Credit Memo");
                GLEntry.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
                GLEntry.SetRange("G/L Account No.", GenPostingSetup."Purch. Credit Memo Account");

                if GLEntry.FindFirst() then
                    if GLAccount.Get(GLEntry."G/L Account No.") then
                        GLName := GLAccount.Name;
            end;
        end;

        if GLName <> '' then
            ExcelBuffer.AddColumn(GLName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn("Purch. Cr. Memo Line".Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Currency Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        if "Purch. Cr. Memo Hdr."."Currency Factor" <> 0 then
            ExcelBuffer.AddColumn(1 / "Purch. Cr. Memo Hdr."."Currency Factor", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        Clear(IGSTAmt);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        Clear(IGSTPer);
        Clear(CGSTPer);
        Clear(SGSTPer);
        DetGSTLedgerEntry.Reset();
        DetGSTLedgerEntry.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
        DetGSTLedgerEntry.SetRange("Document Line No.", "Purch. Cr. Memo Line"."Line No.");
        DetGSTLedgerEntry.SetRange("Document Type", DetGSTLedgerEntry."Document Type"::"Credit Memo");
        if DetGSTLedgerEntry.FindSet() then
            repeat
                case DetGSTLedgerEntry."GST Component Code" of
                    'IGST':
                        begin
                            IGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            IGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                    'CGST':
                        begin
                            CGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            CGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                    'SGST':
                        begin
                            SGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            SGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                end;
            until DetGSTLedgerEntry.Next() = 0;

        if IGSTPer <> 0 then
            ExcelBuffer.AddColumn(IGSTPer, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn(CGSTPer + SGSTPer, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn("Purch. Inv. Line".Amount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(IGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(CGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        Clear(PaymentDate);
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::"Credit Memo");
        VendorLedgerEntry.SetRange("Document No.", "Purch. Inv. Header"."No.");
        if VendorLedgerEntry.FindFirst() then begin
            PaymentVendLedgEntry.Reset();
            PaymentVendLedgEntry.SetRange("Entry No.", VendorLedgerEntry."Closed by Entry No.");
            PaymentVendLedgEntry.SetCurrentKey("Posting Date");
            PaymentVendLedgEntry.Ascending(true);
            if PaymentVendLedgEntry.FindLast() then begin
                PaymentDate := PaymentVendLedgEntry."Posting Date";
            end;
        end;

        if PaymentDate <> 0D then
            ExcelBuffer.AddColumn(PaymentDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Purch. Cr. Memo Line".Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Purch. Cr. Memo Line"."Unit of Measure Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        if "Purch. Cr. Memo Hdr."."Bill of Entry No." <> '' then
            ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Bill of Entry No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        if "Purch. Cr. Memo Hdr."."Bill of Entry Date" <> 0D then
            ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Bill of Entry Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Applies-to Doc. No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        PurchaseInvHeader.Reset();
        PurchaseInvHeader.SetRange("No.", "Purch. Cr. Memo Hdr."."Applies-to Doc. No.");
        if PurchaseInvHeader.FindFirst() then
            ExcelBuffer.AddColumn(PurchaseInvHeader."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        Clear(GLName);
        if ("Purch. Cr. Memo Line".Type in
           ["Purch. Cr. Memo Line".Type::"G/L Account", "Purch. Cr. Memo Line".Type::Item, "Purch. Cr. Memo Line".Type::"Fixed Asset"]) then begin
            if GenPostingSetup.Get(
                "Purch. Cr. Memo Line"."Gen. Bus. Posting Group",
                "Purch. Cr. Memo Line"."Gen. Prod. Posting Group") then begin

                GLEntry.Reset();
                GLEntry.SetRange("Document Type", GLEntry."Document Type"::Invoice);
                GLEntry.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
                GLEntry.SetRange("G/L Account No.", GenPostingSetup."Purch. Account");

                if GLEntry.FindFirst() then
                    if GLAccount.Get(GLEntry."G/L Account No.") then
                        GLName := GLAccount.Name;
            end;
        end;

        if GLName <> '' then
            ExcelBuffer.AddColumn(GLName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn("Purch. Cr. Memo Line".Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        TotalTaxableCrMemo += "Purch. Cr. Memo Line".Amount;
        TotalCrMemoIGSTAmt += IGSTAmt;
        TotalCrMemoCGSTAmt += CGSTAmt;
        TotalCrMemoSGSTAmt += SGSTAmt;
    end;

    local procedure AddGrandTotalRow()
    begin
        FinalTaxableTotal := TotalTaxableInv - TotalTaxableCrMemo;
        FinalIGSTAmt := TotalInvIGSTAmt + TotalCrMemoIGSTAmt;
        FinalCGSTAmt := TotalInvCGSTAmt + TotalCrMemoCGSTAmt;
        FinalSGSTAmt := TotalInvSGSTAmt + TotalCrMemoSGSTAmt;


        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Grand Total', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Date
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Dept
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);                                                                          // … keep empty columns SAME as body until Line Amount
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
        ExcelBuffer.AddColumn(FinalTaxableTotal, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(FinalIGSTAmt, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(FinalCGSTAmt, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(FinalSGSTAmt, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('Inward & RCM');
        ExcelBuffer.WriteSheet('Inward & RCM', '_', UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Inward & RCM' + '_' + UserId);
        ExcelBuffer.OpenExcel();
    end;

    var
        StartDate: Date;
        EndDate: Date;
        LocationCode: Code[10];
        ExcelBuffer: Record "Excel Buffer" temporary;

        CompanyInfo: Record "Company Information";
        RecState: Record State;
        Loc: Record Location;
        DetGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        MonthYearTxt: Text;
        IGSTAmt: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        SGSTPer: Decimal;

        TotalTaxableInv: Decimal;
        TotalTaxableCrMemo: Decimal;
        FinalTaxableTotal: Decimal;
        TotalInvIGSTAmt: Decimal;
        TotalCrMemoIGSTAmt: Decimal;
        FinalIGSTAmt: Decimal;
        TotalInvCGSTAmt: Decimal;
        TotalCrMemoCGSTAmt: Decimal;
        FinalCGSTAmt: Decimal;
        TotalInvSGSTAmt: Decimal;
        TotalCrMemoSGSTAmt: Decimal;
        FinalSGSTAmt: Decimal;
        TotalInvAmt: Decimal;
        TotalCrMemoAmt: Decimal;
        GrnadTotal: Decimal;
        GenPostingSetup: Record "General Posting Setup";
        WarehouseNameHeader: Text;
        PurchaseInvHeader: Record "Purch. Inv. Header";
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        GLName: Text[100];
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendorLedgerEntryPayment: Record "Vendor Ledger Entry";
        PaymentDate: Date;
        VendLedgEntry: Record "Vendor Ledger Entry";
        PaymentVendLedgEntry: Record "Vendor Ledger Entry";
        TaxTransactionValue: Record "Tax Transaction Value";
        OtherCharges: Decimal;
        NatureOfInwards: Text;
        HSNCode: Text;
        Vend: Record Vendor;
        Curr: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        OtherCharge: Decimal;
        ExchRate: Decimal;
        PurchInvLine: Record "Purch. Inv. Line";

        GSTRate: Record "Gst Rate Percentage";
        KFloodPer: Decimal;
        CUstomDuty: Decimal;
        ImportTaxAmt: Decimal;
        PurchaeCommentLine: Record "Purch. Comment Line";
        Narration: Text;
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
        PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
        PortCode: Code[20];
}
