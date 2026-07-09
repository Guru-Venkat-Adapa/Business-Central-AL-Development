report 50029 "Outward Supplies"
{
    ApplicationArea = All;
    Caption = 'Outward Supplies';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter(Item | "G/L Account" | "Fixed Asset")); //TBC-1066 Added Type Filters

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

                if SalesOrdeType <> SalesOrdeType::" " then
                    SetRange("Sales Order Type", Format(SalesOrdeType));

                if LocationCode <> '' then
                    SetRange("Location Code", LocationCode);

                MakeExcelDataHeader();
            end;
        }


        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");

            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLinkReference = "Sales Cr.Memo Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter(Item | "G/L Account"));

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
                    field(SalesOrdeType; SalesOrdeType)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Order Type';
                        OptionCaption = ' ,AMC,CLAIMS,CMC,CONSUMBALE,INSTRUMENT,SPARES,SERVICES';
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
        Clear(SalesType);
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
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        SalesType := '';
        if SalesOrdeType = SalesOrdeType::" " then
            SalesType := 'Listing of Documents of All Sales Order Type'
        else
            SalesType := 'Listing of Documents of ' + Format(SalesOrdeType);

        ExcelBuffer.AddColumn(Format(SalesType), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

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
        ExcelBuffer.AddColumn('Sales Order Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); //TBC-1028
        ExcelBuffer.AddColumn('Warehouse Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Supplier State', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn('Name of Recipient', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('GSTIN of Recipient', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Number', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Transaction Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        //TBC-1053 --->
        ExcelBuffer.AddColumn('Customer PO No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer PO Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        //TBC-1053 <---

        ExcelBuffer.AddColumn('Sales Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('B2B/B2C', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value Before GST', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate of Tax', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Integrated Tax', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Central Tax', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('State Tax', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Value Including GST', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Bill-to State Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Ship-to State Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Part No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HSN/SAC', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Description of Goods/ Services', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Unit of Measurement', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Invoice No. for Credit / Debit note.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Invoice Date for Credit / Debit note', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('Reasons For Issue of Credit / Debit note', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Ledger Head Credited', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IRN No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IRN Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Reason Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); //TBC-1028
        ExcelBuffer.AddColumn('Credit Note Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); //TBC-1069
    end;

    local procedure MakeExcelDataBody()
    var
    begin
        ExcelBuffer.NewRow();

        ExcelBuffer.AddColumn("Sales Invoice Header"."Sales Order Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //TBC-1028

        if "Sales Invoice Header"."Location Code" <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        if RecState.Get("Sales Invoice Header"."Location State Code") then
            ExcelBuffer.AddColumn(RecState.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Invoice Header"."Sell-to Customer Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        if Cust.Get("Sales Invoice Header"."Sell-to Customer No.") then
            ExcelBuffer.AddColumn(Cust."GST Registration No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Invoice Header"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Invoice Header"."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);


        ExcelBuffer.AddColumn('Invoice', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //TBC-1053 --->
        ExcelBuffer.AddColumn("Sales Invoice Header"."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Invoice Header"."Customer PO Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        //TBC-1053 <---

        ExcelBuffer.AddColumn("Sales Invoice Header"."GST Customer Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Invoice Header"."Nature of Supply", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Invoice Line".Amount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        Clear(IGSTAmt);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        Clear(IGSTPer);
        Clear(CGSTPer);
        Clear(SGSTPer);
        DetGSTLedgerEntry.Reset();
        DetGSTLedgerEntry.SetRange("Document No.", "Sales Invoice Header"."No.");
        DetGSTLedgerEntry.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
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

        ExcelBuffer.AddColumn(IGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(CGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn("Sales Invoice Line".Amount + CGSTAmt + SGSTAmt + IGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        Clear(BillToCountyLen);
        BillToCountyLen := StrLen("Sales Invoice Header"."Bill-to County");

        Clear(BillStateDesc);
        if BillToCountyLen = 2 then begin
            RecState.Reset();
            RecState.SetRange(Code, "Sales Invoice Header"."Bill-to County");
            if RecState.FindFirst() then
                BillStateDesc := RecState.Description
            else begin
                if Cust.Get("Sales Invoice Header"."Bill-to Customer No.") then
                    if Cust."State Code" <> '' then begin
                        RecState.Reset();
                        RecState.SetRange(Code, Cust."State Code");
                        if RecState.FindFirst() then
                            BillStateDesc := RecState.Description;
                    end;
            end;
        end
        else begin
            if "Sales Invoice Header"."Bill-to County" <> '' then
                BillStateDesc := "Sales Invoice Header"."Bill-to County"
            else begin
                if Cust.Get("Sales Invoice Header"."Bill-to Customer No.") then
                    if Cust."State Code" <> '' then begin
                        RecState.Reset();
                        RecState.SetRange(Code, Cust."State Code");
                        if RecState.FindFirst() then
                            BillStateDesc := RecState.Description;
                    end;
            end;
        end;

        if BillStateDesc <> '' then
            ExcelBuffer.AddColumn(BillStateDesc, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);


        Clear(ShipToCountyLen);
        ShipToCountyLen := StrLen("Sales Invoice Header"."Ship-to County");

        Clear(ShipStateDesc);

        if ShipToCountyLen = 2 then begin
            RecState.Reset();
            RecState.SetRange(Code, "Sales Invoice Header"."Ship-to County");
            if RecState.FindFirst() then
                ShipStateDesc := RecState.Description
            else begin
                // GST Ship-to State Code
                if "Sales Invoice Header"."GST Ship-to State Code" <> '' then begin
                    RecState.Reset();
                    RecState.SetRange(Code, "Sales Invoice Header"."GST Ship-to State Code");
                    if RecState.FindFirst() then
                        ShipStateDesc := RecState.Description;
                end
                else begin
                    // Customer State Code fallback
                    if Cust.Get("Sales Invoice Header"."Sell-to Customer No.") then
                        if Cust."State Code" <> '' then
                            if RecState.Get(Cust."State Code") then
                                ShipStateDesc := RecState.Description;
                end;
            end;
        end
        else begin
            if "Sales Invoice Header"."Ship-to County" <> '' then
                ShipStateDesc := "Sales Invoice Header"."Ship-to County"
            else begin
                if Cust.Get("Sales Invoice Header"."Sell-to Customer No.") then
                    if Cust."State Code" <> '' then
                        if RecState.Get(Cust."State Code") then
                            ShipStateDesc := RecState.Description;
            end;
        end;

        ExcelBuffer.AddColumn(ShipStateDesc, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Invoice Line"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Invoice Line"."HSN/SAC Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Invoice Line".Description + "Sales Invoice Line"."Description 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Invoice Line".Quantity, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Sales Invoice Line"."Unit of Measure Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Clear(GLName);
        // GLEntry.Reset();
        // GLEntry.SetRange("Document Type", GLEntry."Document Type"::Invoice);
        // GLEntry.SetRange("Document No.", "Sales Invoice Header"."No.");
        // GLEntry.SetRange("Gen. Posting Type", GLEntry."Gen. Posting Type"::Sale);
        // GLEntry.SetRange("Gen. Prod. Posting Group", "Sales Invoice Line"."Gen. Prod. Posting Group");
        // if GLEntry.FindFirst() then
        //     if GLAccount.Get(GLEntry."G/L Account No.") then
        //         GLName := GLAccount.Name;

        Clear(GLName);
        if GenPostingSetup.Get(
            "Sales Invoice Line"."Gen. Bus. Posting Group",
            "Sales Invoice Line"."Gen. Prod. Posting Group")
        then begin
            GLEntry.Reset();
            GLEntry.SetRange("Document Type", GLEntry."Document Type"::Invoice);
            GLEntry.SetRange("Document No.", "Sales Invoice Header"."No.");
            GLEntry.SetRange("G/L Account No.", GenPostingSetup."Sales Account");
            if GLEntry.FindFirst() then
                if GLAccount.Get(GLEntry."G/L Account No.") then
                    GLName := GLAccount.Name;
        end;

        if GLName <> '' then
            ExcelBuffer.AddColumn(GLName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Invoice Header"."IRN Hash", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Invoice Header"."Acknowledgement Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

        //TBC-1028 -->
        Clear(ReasonDescription);
        if "Sales Invoice Header"."Reason Code" <> '' then begin
            ReasonCode.Reset();
            ReasonCode.SetRange(Code, "Sales Invoice Header"."Reason Code");
            if ReasonCode.FindFirst() then
                ReasonDescription := ReasonCode.Description;
        end;
        ExcelBuffer.AddColumn(ReasonDescription, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //TBC-1028 <--

        //TBC-1070
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        TotalTaxableInv += "Sales Invoice Line".Amount;
        TotalInvIGSTAmt += IGSTAmt;
        TotalInvCGSTAmt += CGSTAmt;
        TotalInvSGSTAmt += SGSTAmt;
        TotalInvAmt += "Sales Invoice Line".Amount + IGSTAmt + CGSTAmt + SGSTAmt;
    end;


    local procedure MakeExcelDataBody_CrMemo()
    begin
        ExcelBuffer.NewRow();

        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //TBC-1028

        if "Sales Cr.Memo Header"."Location Code" <> '' then
            ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        if RecState.Get("Sales Cr.Memo Header"."Location State Code") then
            ExcelBuffer.AddColumn(RecState.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Sell-to Customer Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        if Cust.Get("Sales Cr.Memo Header"."Sell-to Customer No.") then
            ExcelBuffer.AddColumn(Cust."GST Registration No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

        Clear(TransactionType);
        TransactionType := CopyStr("Sales Cr.Memo Header"."Posting Description", 1, 11);

        ExcelBuffer.AddColumn('Credit Memo', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //TBC-1053 --->
        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //TBC-1053 <---

        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."GST Customer Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Nature of Supply", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(-"Sales Cr.Memo Line".Amount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        Clear(IGSTAmt);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        Clear(IGSTPer);
        Clear(CGSTPer);
        Clear(SGSTPer);
        DetGSTLedgerEntry.Reset();
        DetGSTLedgerEntry.SetRange("Document No.", "Sales Cr.Memo Header"."No.");
        DetGSTLedgerEntry.SetRange("Document Line No.", "Sales Cr.Memo Line"."Line No.");
        DetGSTLedgerEntry.SetRange("Document Type", DetGSTLedgerEntry."Document Type"::"Credit Memo");
        if DetGSTLedgerEntry.FindSet() then
            repeat
                case DetGSTLedgerEntry."GST Component Code" of
                    'IGST':
                        begin
                            IGSTAmt += DetGSTLedgerEntry."GST Amount";
                            IGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                    'CGST':
                        begin
                            CGSTAmt += DetGSTLedgerEntry."GST Amount";
                            CGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                    'SGST':
                        begin
                            SGSTAmt += DetGSTLedgerEntry."GST Amount";
                            SGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                end;
            until DetGSTLedgerEntry.Next() = 0;

        if IGSTPer <> 0 then
            ExcelBuffer.AddColumn(IGSTPer, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn(CGSTPer + SGSTPer, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn(-IGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(-CGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(-SGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(-"Sales Cr.Memo Line".Amount - CGSTAmt - SGSTAmt - IGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        Clear(BillToCountyLen);
        BillToCountyLen := StrLen("Sales Cr.Memo Header"."Bill-to County");

        Clear(BillStateDesc);
        if BillToCountyLen = 2 then begin
            RecState.Reset();
            RecState.SetRange(Code, "Sales Cr.Memo Header"."Bill-to County");
            if RecState.FindFirst() then
                BillStateDesc := RecState.Description
            else begin
                if Cust.Get("Sales Cr.Memo Header"."Bill-to Customer No.") then
                    if Cust."State Code" <> '' then begin
                        RecState.Reset();
                        RecState.SetRange(Code, Cust."State Code");
                        if RecState.FindFirst() then
                            BillStateDesc := RecState.Description;
                    end;
            end;
        end else begin
            if "Sales Cr.Memo Header"."Bill-to County" <> '' then
                BillStateDesc := "Sales Cr.Memo Header"."Bill-to County"
            else begin
                if Cust.Get("Sales Cr.Memo Header"."Bill-to Customer No.") then
                    if Cust."State Code" <> '' then begin
                        RecState.Reset();
                        RecState.SetRange(Code, Cust."State Code");
                        if RecState.FindFirst() then
                            BillStateDesc := RecState.Description;
                    end;
            end;
        end;

        if BillStateDesc <> '' then
            ExcelBuffer.AddColumn(BillStateDesc, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        Clear(ShipToCountyLen);
        ShipToCountyLen := StrLen("Sales Cr.Memo Header"."Ship-to County");

        Clear(ShipStateDesc);

        if ShipToCountyLen = 2 then begin
            RecState.Reset();
            RecState.SetRange(Code, "Sales Cr.Memo Header"."Ship-to County");
            if RecState.FindFirst() then
                ShipStateDesc := RecState.Description
            else begin
                // GST Ship-to State Code
                if "Sales Cr.Memo Header"."GST Ship-to State Code" <> '' then begin
                    RecState.Reset();
                    RecState.SetRange(Code, "Sales Cr.Memo Header"."GST Ship-to State Code");
                    if RecState.FindFirst() then
                        ShipStateDesc := RecState.Description;
                end
                else begin
                    // Customer State Code fallback
                    if Cust.Get("Sales Cr.Memo Header"."Sell-to Customer No.") then
                        if Cust."State Code" <> '' then begin
                            RecState.Reset();
                            RecState.SetRange(Code, Cust."State Code");
                            if RecState.FindFirst() then
                                ShipStateDesc := RecState.Description;
                        end;
                end;
            end;
        end
        else begin
            if "Sales Cr.Memo Header"."Ship-to County" <> '' then
                ShipStateDesc := "Sales Cr.Memo Header"."Ship-to County"
            else begin
                if Cust.Get("Sales Cr.Memo Header"."Sell-to Customer No.") then
                    if Cust."State Code" <> '' then begin
                        RecState.Reset();
                        RecState.SetRange(Code, Cust."State Code");
                        if RecState.FindFirst() then
                            ShipStateDesc := RecState.Description;
                    end;
            end;
        end;

        if ShipStateDesc <> '' then
            ExcelBuffer.AddColumn(ShipStateDesc, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);



        ExcelBuffer.AddColumn("Sales Cr.Memo Line"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Cr.Memo Line"."HSN/SAC Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Cr.Memo Line".Description + "Sales Cr.Memo Line"."Description 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Cr.Memo Line".Quantity, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Sales Cr.Memo Line"."Unit of Measure Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //TBC-1028 --->
        Clear(InvoiceNo);
        if "Sales Cr.Memo Header"."Applies-to Doc. No." <> '' then
            InvoiceNo := "Sales Cr.Memo Header"."Applies-to Doc. No."
        else if "Sales Cr.Memo Header"."Reference Invoice No." <> '' then
            InvoiceNo := "Sales Cr.Memo Header"."Reference Invoice No."
        else
            InvoiceNo := '';
        ExcelBuffer.AddColumn(InvoiceNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //TBC-1028 <---

        SalesInvHeader.Reset();
        SalesInvHeader.SetRange("No.", InvoiceNo); //TBC_1028 Invoice No. fileter
        if SalesInvHeader.FindFirst() then
            ExcelBuffer.AddColumn(SalesInvHeader."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        Clear(Reason);
        "Sales Cr.Memo Header".CalcFields("Work Description");

        if "Sales Cr.Memo Header"."Work Description".HasValue then begin
            "Sales Cr.Memo Header"."Work Description".CreateInStream(WorkDescStream);
            WorkDescStream.ReadText(Reason);
            ExcelBuffer.AddColumn(Reason, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);


        Clear(GLName);

        if GenPostingSetup.Get(
           "Sales Cr.Memo Line"."Gen. Bus. Posting Group",
           "Sales Cr.Memo Line"."Gen. Prod. Posting Group") then begin
            GLEntry.Reset();
            GLEntry.SetRange("Document Type", GLEntry."Document Type"::"Credit Memo");
            GLEntry.SetRange("Document No.", "Sales Cr.Memo Header"."No.");
            GLEntry.SetRange("G/L Account No.", GenPostingSetup."Sales Credit Memo Account");
            if GLEntry.FindFirst() then
                if GLAccount.Get(GLEntry."G/L Account No.") then
                    GLName := GLAccount.Name;
        end;

        if GLName <> '' then
            ExcelBuffer.AddColumn(GLName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."IRN Hash", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Acknowledgement Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

        //TBC-1028 -->
        Clear(ReasonDescription);
        if "Sales Cr.Memo Header"."Reason Code" <> '' then begin
            ReasonCode.Reset();
            ReasonCode.SetRange(Code, "Sales Cr.Memo Header"."Reason Code");
            if ReasonCode.FindFirst() then
                ReasonDescription := ReasonCode.Description;
        end;
        ExcelBuffer.AddColumn(ReasonDescription, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //TBC-1028 <--

        //TBC-1070
        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Credit Note Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        TotalTaxableCrMemo += "Sales Cr.Memo Line".Amount;
        TotalCrMemoIGSTAmt += -IGSTAmt;
        TotalCrMemoCGSTAmt += -CGSTAmt;
        TotalCrMemoSGSTAmt += -SGSTAmt;
        TotalCrMemoAmt += "Sales Cr.Memo Line".Amount + (-IGSTAmt) + (-CGSTAmt) + (-SGSTAmt);
    end;

    local procedure AddGrandTotalRow()
    begin
        FinalTaxableTotal := TotalTaxableInv - TotalTaxableCrMemo;
        FinalIGSTAmt := TotalInvIGSTAmt + TotalCrMemoIGSTAmt;
        FinalCGSTAmt := TotalInvCGSTAmt + TotalCrMemoCGSTAmt;
        FinalSGSTAmt := TotalInvSGSTAmt + TotalCrMemoSGSTAmt;
        GrnadTotal := FinalTaxableTotal + FinalIGSTAmt + FinalCGSTAmt + FinalSGSTAmt;

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
        ExcelBuffer.AddColumn(FinalTaxableTotal, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(FinalIGSTAmt, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(FinalCGSTAmt, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(FinalSGSTAmt, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrnadTotal, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('Outward Supplies');
        ExcelBuffer.WriteSheet('Outward Supplies', '_', UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Outward Supplies' + '_' + UserId);
        ExcelBuffer.OpenExcel();
    end;



    var
        StartDate: Date;
        EndDate: Date;
        SalesOrdeType: Option " ",AMC,CLAIMS,CMC,CONSUMBALE,INSTRUMENT,SPARES,SERVICES;
        LocationCode: Code[10];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SalesType: Text;
        CompanyInfo: Record "Company Information";
        Loc: Record Location;
        RecState: Record State;
        Cust: Record Customer;
        TransactionType: Text;
        BillToStateName: Text;
        ShipToStateName: Text;
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        GLName: Text[100];
        BaseGLAccount: Code[20];
        DetGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        SGSTPer: Decimal;
        SalesInvHeader: Record "Sales Invoice Header";
        ShipToCountyLen: Integer;
        BillToCountyLen: Integer;
        WarehouseNameHeader: Text;
        WorkDescStream: InStream;
        Reason: Text;
        BillStateDesc: Text;
        ShipStateDesc: Text;
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
        ////TBC-1028 --->
        InvoiceNo: Code[20];
        ReasonCode: Record "Reason Code";
        ReasonDescription: Text;
    //TBC-1028 <---

}
