report 50043 "Net Margin - Invoice"
{
    ApplicationArea = All;
    Caption = 'Net Margin - Invoice';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Invoice Header";
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = const(Item), Quantity = filter(> 0));

                trigger OnAfterGetRecord()
                begin
                    MakeExcelDataBody();
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
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = const(Item), Quantity = filter(> 0));

                trigger OnAfterGetRecord()
                begin
                    MakeExcelDataBody_CrMemo();
                end;
            }

            trigger OnPreDataItem()
            begin

                if (StartDate = 0D) or (EndDate = 0D) then
                    Error('Start Date and End Date must not be blank.');

                if StartDate > EndDate then
                    Error('Start Date cannot be greater than End Date.');

                SetRange("Posting Date", StartDate, EndDate);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
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
                        TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        UserSetup: Record "User Setup";
    begin
        //TBC-1063 ---->
        if UserSetup.Get(UserId) then
            if not UserSetup."Net Margin Permission" then
                Error('You do not have permission to execute this report.');
        //TBC-1063 <----

        ExcelBuffer.DeleteAll();
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(Picture);
        if GeneralLedgerSetup.Get() then;
    end;

    trigger OnPostReport()
    begin
        CreateExcelBook();
    end;

    local procedure MakeExcelDataBody()
    var
        ShipmentNos: Text;
        PurchaseRate: Decimal;
        PurchaseValue: Decimal;
        TaxableValue: Decimal;
        GrossValue: Decimal;
        MarginValue: Decimal;
        LotNo: Code[50];
        FolioNo: Code[100];
        LandedCost: Decimal;
        ShipmentNo: Code[20];
    begin
        // Clear all local variables
        Clear(ShipmentNos);
        Clear(PurchaseRate);
        Clear(PurchaseValue);
        Clear(TaxableValue);
        Clear(GrossValue);
        Clear(MarginValue);
        Clear(LotNo);
        Clear(FolioNo);
        Clear(LandedCost);
        Clear(ShipmentNo);

        // Clear global variables used by GetCostFromInvoiceLine
        Clear(ExchageRate);
        Clear(CurrCode);
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
        Clear(COGSAmount);
        Clear(InvoiceCOGSAmount);
        Clear(PurchaseOrderNo);


        // Get Cost, LotNo, FolioNo from Invoice Line via ILE chain
        GetCostFromInvoiceLine("Sales Invoice Line", "Sales Invoice Line"."No.", PurchaseRate, LotNo, FolioNo);

        // Get the originating Shipment No. (for reference column) via Sales Invoice Line's Shipment No.
        ShipmentNo := "Sales Invoice Line"."Shipment No.";

        ExcelBuffer.NewRow();

        // 1. Sales Order Type & Invoice #
        ExcelBuffer.AddColumn('Invoice', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Invoice Header"."Sales Order Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 2. Doc No. (Invoice No.)
        ExcelBuffer.AddColumn("Sales Invoice Header"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 3. Date
        ExcelBuffer.AddColumn("Sales Invoice Header"."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

        //TBC-1068 ---->
        if "Sales Invoice Header"."External Document No." <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else begin
            SalesHeader.Reset();
            SalesHeader.SetRange("No.", "Sales Invoice Header"."Order No.");
            if SalesHeader.FindFirst() and (SalesHeader."External Document No." <> '') then
                ExcelBuffer.AddColumn(SalesHeader."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
            else begin
                SalesHeaderArchive.Reset();
                SalesHeaderArchive.SetRange("No.", "Sales Invoice Header"."Order No.");
                if SalesHeaderArchive.FindLast() and (SalesHeaderArchive."External Document No." <> '') then
                    ExcelBuffer.AddColumn(SalesHeaderArchive."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
                else
                    ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            end;
        end;
        //TBC-1068 <------



        // 4. Department Name (Shortcut Dimension 1)
        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 1 Code");
        DimensionValue.SetRange(Code, "Sales Invoice Header"."Shortcut Dimension 1 Code");
        if DimensionValue.FindFirst() then
            ExcelBuffer.AddColumn(DimensionValue.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 5. Regional Office Name (Shortcut Dimension 2)
        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 2 Code");
        DimensionValue.SetRange(Code, "Sales Invoice Header"."Shortcut Dimension 2 Code");
        if DimensionValue.FindFirst() then
            ExcelBuffer.AddColumn(DimensionValue.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        DimensionValue.Reset();
        DimensionValue.SetRange(Code, "Sales Invoice Header"."Shortcut Dimension 3 Code");
        if DimensionValue.FindFirst() then
            ExcelBuffer.AddColumn(DimensionValue.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 6. Customer AC Code
        ExcelBuffer.AddColumn("Sales Invoice Header"."Sell-to Customer No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 7. Customer AC Name
        ExcelBuffer.AddColumn("Sales Invoice Header"."Sell-to Customer Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 8. Item Code
        ExcelBuffer.AddColumn("Sales Invoice Line"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 9. Item Name
        ExcelBuffer.AddColumn("Sales Invoice Line".Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 10. Quantity
        ExcelBuffer.AddColumn("Sales Invoice Line".Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // 11. Rate (Unit Price)
        ExcelBuffer.AddColumn("Sales Invoice Line"."Unit Price", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // 12. Gross (Qty x Unit Price before discount)
        GrossValue := "Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price";
        ExcelBuffer.AddColumn(GrossValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 13. Taxable Value (Line Amount after discount)
        TaxableValue := "Sales Invoice Line"."Unit Price" * "Sales Invoice Line".Quantity;
        ExcelBuffer.AddColumn(TaxableValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 14. Purchase Rate (from GetCostFromInvoiceLine)
        ExcelBuffer.AddColumn(PurchaseRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 15. Purchase Value (Purchase Rate x Qty)
        PurchaseValue := PurchaseRate * "Sales Invoice Line".Quantity;
        ExcelBuffer.AddColumn(PurchaseValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 16. Batch Rate (Cost per Unit for this Lot from Purchase Value Entry)
        ExcelBuffer.AddColumn(PurchaseRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 17. Batch / Lot No. (from ILE via GetCostFromInvoiceLine)
        ExcelBuffer.AddColumn(LotNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 18. COGS Amount + Margin Value (Taxable Value - COGS)
        InvoiceCOGSAmount := InvoiceGetCOGSAmount("Sales Invoice Header"."No.", "Sales Invoice Line"."No.", "Sales Invoice Line"."Line No.");

        ExcelBuffer.AddColumn(InvoiceCOGSAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        MarginValue := TaxableValue - InvoiceCOGSAmount;
        ExcelBuffer.AddColumn(MarginValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 19. Currency Code
        ExcelBuffer.AddColumn(CurrCode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 20. Currency Rate
        ExcelBuffer.AddColumn(ExchageRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 21. Import Rate/Value (Direct Unit Cost in foreign currency)
        ExcelBuffer.AddColumn(ImportRateUSD, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 22. Accessible Value in INR
        ExcelBuffer.AddColumn(INRAccessibleValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 23. Insurance Amount
        ExcelBuffer.AddColumn(InsuranceAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 24. Custom Duty
        ExcelBuffer.AddColumn(CustomDuty, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 25. Clearing & Forwarding
        ExcelBuffer.AddColumn(ClearingForwarding, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 26. Freight Amount
        ExcelBuffer.AddColumn(FreightAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 27. IGST (from Detailed GST Ledger Entry via Purchase Invoice)
        ExcelBuffer.AddColumn(IGST, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 28. Landed Cost (Purchase Value + CustomDuty + ClearingForwarding + FreightAmount + InsuranceAmount)
        LandedCost := PurchaseValue + CustomDuty + ClearingForwarding + FreightAmount + InsuranceAmount;
        ExcelBuffer.AddColumn(LandedCost, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 29. Shipment Mode (from Posted Whse. Receipt via GetCostFromInvoiceLine)
        ExcelBuffer.AddColumn(Shipmentmode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 30. Folio No Master Name (from Purch. Rcpt. Header via GetCostFromInvoiceLine)
        ExcelBuffer.AddColumn(PurchaseOrderNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(FolioNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 31. Narration
        ExcelBuffer.AddColumn("Sales Invoice Header"."Posting Description", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 32. Programmable Field
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 33. Batch Rate Testing
        ExcelBuffer.AddColumn(0, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // 34. BTrt
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 35. Regional Group Name
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 36. Order No.
        ExcelBuffer.AddColumn("Sales Invoice Header"."Order No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 37. Order Master Name
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 38. Base Link doc. Number (Originating Shipment No.)
        ExcelBuffer.AddColumn(ShipmentNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 39. Line Comment
        ExcelBuffer.AddColumn("Sales Invoice Line"."Description 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;


    local procedure MakeExcelDataBody_CrMemo()
    var
        ShipmentNos: Text;
        PurchaseRate: Decimal;
        PurchaseValue: Decimal;
        TaxableValue: Decimal;
        GrossValue: Decimal;
        MarginValue: Decimal;
        LotNo: Code[50];
        FolioNo: Code[100];
        LandedCost: Decimal;
        ShipmentNo: Code[20];
        SalesOrderType: Text;
        TeamsName: Code[20];
    begin
        // Clear all local variables
        Clear(ShipmentNos);
        Clear(PurchaseRate);
        Clear(PurchaseValue);
        Clear(TaxableValue);
        Clear(GrossValue);
        Clear(MarginValue);
        Clear(LotNo);
        Clear(FolioNo);
        Clear(LandedCost);
        Clear(ShipmentNo);

        // Clear global variables used by GetCostFromInvoiceLine
        Clear(ExchageRate);
        Clear(CurrCode);
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
        Clear(COGSAmount);
        Clear(InvoiceCOGSAmount);
        Clear(RefInvoiceNo);

        // Get Cost, LotNo, FolioNo from Invoice Line via ILE chain
        //GetCostFromInvoiceLine("Sales Cr.Memo Line", "Sales Cr.Memo Line"."No.", PurchaseRate, LotNo, FolioNo);

        // Get the originating Shipment No. (for reference column) via Sales Invoice Line's Shipment No.
        //ShipmentNo := "Sales Invoice Line"."Shipment No.";

        ExcelBuffer.NewRow();

        // 1. Sales Order Type & Invoice #
        ExcelBuffer.AddColumn('Credit Memo', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        SalesCreditMemoLine.Reset();
        SalesCreditMemoLine.SetRange("Document No.", "Sales Cr.Memo Header"."No.");
        SalesCreditMemoLine.SetRange(Type, SalesCreditMemoLine.Type::" ");
        if SalesCreditMemoLine.FindFirst() then begin
            if SalesCreditMemoLine.Description <> '' then begin
                RefInvoiceNo := DelStr(SalesCreditMemoLine.Description, 1, StrLen('Inv. No. '));

                if StrPos(RefInvoiceNo, ' - ') > 0 then
                    RefInvoiceNo := CopyStr(RefInvoiceNo, 1, StrPos(RefInvoiceNo, ' - ') - 1);

                SalesInvoiceHeader.Reset();
                SalesInvoiceHeader.SetRange("No.", RefInvoiceNo);
                if SalesInvoiceHeader.FindFirst() then begin
                    SalesOrderType := SalesInvoiceHeader."Sales Order Type";
                    TeamsName := SalesInvoiceHeader."Shortcut Dimension 3 Code";
                end;
            end;
        end else
            if "Sales Cr.Memo Header"."Applies-to Doc. No." <> '' then begin
                if SalesInvoiceHeader.Get("Sales Cr.Memo Header"."Applies-to Doc. No.") then begin
                    RefInvoiceNo := SalesInvoiceHeader."No.";
                    SalesOrderType := SalesInvoiceHeader."Sales Order Type";
                    TeamsName := SalesInvoiceHeader."Shortcut Dimension 3 Code";
                end;
            end else
                if "Sales Cr.Memo Header"."Reference Invoice No." <> '' then begin
                    if SalesInvoiceHeader.Get("Sales Cr.Memo Header"."Reference Invoice No.") then begin
                        RefInvoiceNo := SalesInvoiceHeader."No.";
                        SalesOrderType := SalesInvoiceHeader."Sales Order Type";
                        TeamsName := SalesInvoiceHeader."Shortcut Dimension 3 Code";
                    end;
                end;

        // if "Sales Cr.Memo Header"."Applies-to Doc. No." <> '' then begin
        //     if SalesInvoiceHeader.Get("Sales Cr.Memo Header"."Applies-to Doc. No.") then begin
        //         SalesOrderType := SalesInvoiceHeader."Sales Order Type";
        //         TeamsName := SalesInvoiceHeader."Shortcut Dimension 3 Code";
        //     end;
        // end else
        //     if "Sales Cr.Memo Header"."Reference Invoice No." <> '' then begin
        //         if SalesInvoiceHeader.Get("Sales Cr.Memo Header"."Reference Invoice No.") then begin
        //             SalesOrderType := SalesInvoiceHeader."Sales Order Type";
        //             TeamsName := SalesInvoiceHeader."Shortcut Dimension 3 Code";
        //         end;
        //     end else begin
        //         SalesCreditMemoLine.Reset();
        //         SalesCreditMemoLine.SetRange("Document No.", "Sales Cr.Memo Header"."No.");
        //         SalesCreditMemoLine.SetRange(Type, SalesCreditMemoLine.Type::" ");
        //         if SalesCreditMemoLine.FindFirst() then begin
        //             if SalesCreditMemoLine.Description <> '' then begin
        //                 RefInvoiceNo := DelStr(SalesCreditMemoLine.Description, 1, StrLen('Inv. No. '));

        //                 if StrPos(RefInvoiceNo, ' - ') > 0 then
        //                     RefInvoiceNo := CopyStr(RefInvoiceNo, 1, StrPos(RefInvoiceNo, ' - ') - 1);

        //                 SalesInvoiceHeader.Reset();
        //                 SalesInvoiceHeader.SetRange("No.", RefInvoiceNo);
        //                 if SalesInvoiceHeader.FindFirst() then begin
        //                     SalesOrderType := SalesInvoiceHeader."Sales Order Type";
        //                     TeamsName := SalesInvoiceHeader."Shortcut Dimension 3 Code";
        //                 end;
        //             end;
        //         end
        //         else
        //             if "Sales Cr.Memo Header"."Your Reference" <> '' then begin
        //                 SalesHeader.Reset();
        //                 SalesHeader.SetRange("No.", "Sales Cr.Memo Header"."Your Reference");
        //                 if SalesHeader.FindFirst() then begin
        //                     SalesOrderType := SalesHeader."Sales Order Type";
        //                     TeamsName := SalesHeader."Shortcut Dimension 3 Code";
        //                 end else begin
        //                     SalesHeaderArchive.Reset();
        //                     SalesHeaderArchive.SetRange("No.", "Sales Cr.Memo Header"."Your Reference");
        //                     if SalesHeaderArchive.FindFirst() then begin
        //                         SalesOrderType := SalesHeaderArchive."Sales Order Type";
        //                         TeamsName := SalesHeaderArchive."Shortcut Dimension 3 Code";
        //                     end;
        //                 end;
        //             end else begin
        //                 SalesOrderType := '';
        //                 TeamsName := '';
        //             end;
        //     end;

        ExcelBuffer.AddColumn(SalesOrderType, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 2. Doc No. (Invoice No.)
        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 3. Date
        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

        //TBC-1068 ----->
        if "Sales Cr.Memo Header"."External Document No." <> ''
        then
            ExcelBuffer.AddColumn("Sales Cr.Memo Header"."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //TBC-1068 <------


        // 4. Department Name (Shortcut Dimension 1)
        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 1 Code");
        DimensionValue.SetRange(Code, "Sales Cr.Memo Header"."Shortcut Dimension 1 Code");
        if DimensionValue.FindFirst() then
            ExcelBuffer.AddColumn(DimensionValue.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 5. Regional Office Name (Shortcut Dimension 2)
        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 2 Code");
        DimensionValue.SetRange(Code, "Sales Cr.Memo Header"."Shortcut Dimension 2 Code");
        if DimensionValue.FindFirst() then
            ExcelBuffer.AddColumn(DimensionValue.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        DimensionValue.Reset();
        DimensionValue.SetRange(Code, TeamsName);
        if DimensionValue.FindFirst() then
            ExcelBuffer.AddColumn(DimensionValue.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 6. Customer AC Code
        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Sell-to Customer No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 7. Customer AC Name
        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Sell-to Customer Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 8. Item Code
        ExcelBuffer.AddColumn("Sales Cr.Memo Line"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 9. Item Name
        ExcelBuffer.AddColumn("Sales Cr.Memo Line".Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 10. Quantity
        ExcelBuffer.AddColumn(-1 * "Sales Cr.Memo Line".Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // 11. Rate (Unit Price)
        ExcelBuffer.AddColumn(-1 * "Sales Cr.Memo Line"."Unit Price", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // 12. Gross (Qty x Unit Price before discount)
        GrossValue := -1 * ("Sales Cr.Memo Line".Quantity * "Sales Cr.Memo Line"."Unit Price");
        ExcelBuffer.AddColumn(GrossValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 13. Taxable Value (Line Amount after discount)
        TaxableValue := -1 * ("Sales Cr.Memo Line"."Unit Price" * "Sales Cr.Memo Line".Quantity);
        ExcelBuffer.AddColumn(TaxableValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 14. Purchase Rate (from GetCostFromInvoiceLine)
        ExcelBuffer.AddColumn(PurchaseRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 15. Purchase Value (Purchase Rate x Qty)
        PurchaseValue := PurchaseRate * "Sales Cr.Memo Line".Quantity;
        ExcelBuffer.AddColumn(PurchaseValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 16. Batch Rate (Cost per Unit for this Lot from Purchase Value Entry)
        ExcelBuffer.AddColumn(PurchaseRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 17. Batch / Lot No. (from ILE via GetCostFromInvoiceLine)
        ExcelBuffer.AddColumn(LotNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 18. COGS Amount + Margin Value (Taxable Value - COGS)
        InvoiceCOGSAmount := -1 * CreditGetCOGSAmount("Sales Cr.Memo Header"."No.", "Sales Cr.Memo Line"."No.", "Sales Cr.Memo Line"."Line No.");

        ExcelBuffer.AddColumn(InvoiceCOGSAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        MarginValue := (TaxableValue - InvoiceCOGSAmount);
        ExcelBuffer.AddColumn(MarginValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 19. Currency Code
        ExcelBuffer.AddColumn(CurrCode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 20. Currency Rate
        ExcelBuffer.AddColumn(ExchageRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 21. Import Rate/Value (Direct Unit Cost in foreign currency)
        ExcelBuffer.AddColumn(ImportRateUSD, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 22. Accessible Value in INR
        ExcelBuffer.AddColumn(INRAccessibleValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 23. Insurance Amount
        ExcelBuffer.AddColumn(InsuranceAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 24. Custom Duty
        ExcelBuffer.AddColumn(CustomDuty, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 25. Clearing & Forwarding
        ExcelBuffer.AddColumn(ClearingForwarding, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 26. Freight Amount
        ExcelBuffer.AddColumn(FreightAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 27. IGST (from Detailed GST Ledger Entry via Purchase Invoice)
        ExcelBuffer.AddColumn(IGST, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 28. Landed Cost (Purchase Value + CustomDuty + ClearingForwarding + FreightAmount + InsuranceAmount)
        LandedCost := PurchaseValue + CustomDuty + ClearingForwarding + FreightAmount + InsuranceAmount;
        ExcelBuffer.AddColumn(LandedCost, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 29. Shipment Mode (from Posted Whse. Receipt via GetCostFromInvoiceLine)
        ExcelBuffer.AddColumn(Shipmentmode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 30. Folio No Master Name (from Purch. Rcpt. Header via GetCostFromInvoiceLine)
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(FolioNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 31. Narration
        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Posting Description", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 32. Programmable Field
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 33. Batch Rate Testing
        ExcelBuffer.AddColumn(0, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // 34. BTrt
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 35. Regional Group Name
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 36. Order No.
        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Pre-Assigned No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 37. Order Master Name
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 38. Base Link doc. Number (Originating Shipment No.)
        Clear(InvoiceNo);
        if "Sales Cr.Memo Header"."Applies-to Doc. No." <> '' then
            InvoiceNo := "Sales Cr.Memo Header"."Applies-to Doc. No."
        else if "Sales Cr.Memo Header"."Reference Invoice No." <> '' then
            InvoiceNo := "Sales Cr.Memo Header"."Reference Invoice No."
        else
            InvoiceNo := '';

        ExcelBuffer.AddColumn(RefInvoiceNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 39. Line Comment
        ExcelBuffer.AddColumn("Sales Cr.Memo Line"."Description 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;


    local procedure GetCostFromInvoiceLine(
        SalesInvoiceLine: Record "Sales Invoice Line";
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
        GSTRate: Record "Gst Rate Percentage";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        PurchaseHeader: Record "Purchase Header";
        Found: Boolean;
    begin
        Clear(PurchaseRate);
        Clear(LotNo);
        Clear(FolioNo);
        Clear(ExchageRate);
        Clear(CurrCode);
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
        Clear(BCD);

        // Step 1: Find Sale ILE from Invoice Line
        // NOTE: Posted Sales Invoice Lines carry "Document No." = Invoice No. & "Line No." = Invoice line no.
        // The Item Ledger Entry created at invoice-posting time links back via these same keys
        // for Order-type invoicing (Invoice posted together with/without shipment in the same doc chain).
        // Attempt 1: Direct match via Invoice's own Document No./Line No.
        SaleILE.Reset();
        SaleILE.SetRange("Document No.", SalesInvoiceLine."Document No.");
        SaleILE.SetRange("Document Line No.", SalesInvoiceLine."Line No.");
        SaleILE.SetRange("Item No.", ItemNo);
        SaleILE.SetRange("Entry Type", SaleILE."Entry Type"::Sale);
        Found := SaleILE.FindFirst();

        // Attempt 2: Shipment No./Line No. directly on the Invoice Line
        if not Found and (SalesInvoiceLine."Shipment No." <> '') then begin
            SaleILE.Reset();
            SaleILE.SetRange("Document No.", SalesInvoiceLine."Shipment No.");
            SaleILE.SetRange("Document Line No.", SalesInvoiceLine."Shipment Line No.");
            SaleILE.SetRange("Item No.", ItemNo);
            SaleILE.SetRange("Entry Type", SaleILE."Entry Type"::Sale);
            Found := SaleILE.FindFirst();
        end;
        if not Found and (SalesInvoiceLine."Shipment No." = '') and ("Sales Invoice Header"."Order No." <> '') then begin
            SalesShipmentHeader.Reset();
            SalesShipmentHeader.SetRange("Order No.", "Sales Invoice Header"."Order No.");
            if SalesShipmentHeader.FindSet() then
                repeat
                    SalesShipmentLine.Reset();
                    SalesShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");
                    SalesShipmentLine.SetRange(Type, SalesShipmentLine.Type::Item);
                    SalesShipmentLine.SetRange("No.", ItemNo);
                    if SalesShipmentLine.FindFirst() then begin
                        SaleILE.Reset();
                        SaleILE.SetRange("Document No.", SalesShipmentHeader."No.");
                        SaleILE.SetRange("Document Line No.", SalesShipmentLine."Line No.");
                        SaleILE.SetRange("Item No.", ItemNo);
                        SaleILE.SetRange("Entry Type", SaleILE."Entry Type"::Sale);
                        Found := SaleILE.FindFirst();
                    end;
                until Found or (SalesShipmentHeader.Next() = 0);
        end;

        if Found then
            LotNo := SaleILE."Lot No."
        else
            LotNo := '';

        // Step 3: Find Applied Inbound ILE
        ItemApplicationEntry.Reset();
        ItemApplicationEntry.SetRange("Outbound Item Entry No.", SaleILE."Entry No.");
        if not ItemApplicationEntry.FindFirst() then
            exit;

        if not AppliedILE.Get(ItemApplicationEntry."Inbound Item Entry No.") then
            exit;

        // Step 4: FolioNo + Shipment Mode from Purchase Receipt
        if AppliedILE."Entry Type" = AppliedILE."Entry Type"::Purchase then
            if AppliedILE."Document Type" = AppliedILE."Document Type"::"Purchase Receipt" then
                if PurchRcptHeader.Get(AppliedILE."Document No.") then begin
                    FolioNo := PurchRcptHeader."Folio No.";

                    PurchaseOrderNo := PurchRcptHeader."Order No.";
                    if FolioNo = '' then
                        if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, PurchRcptHeader."Order No.") then
                            FolioNo := PurchaseHeader."Folio No.";

                    PurchRcptLine.Reset();
                    PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
                    PurchRcptLine.SetRange("No.", AppliedILE."Item No.");
                    PurchRcptLine.SetRange("Line No.", AppliedILE."Document Line No.");
                    if PurchRcptLine.FindFirst() then
                        if PurchRcptLine."Posted Warehouse Rec No" <> '' then
                            if PostedWhseReceiptHeader.Get(PurchRcptLine."Posted Warehouse Rec No") then
                                Shipmentmode := PostedWhseReceiptHeader."Mode Of Shipment";
                end;

        // Step 5: Value Entry → PurchaseRate + Import Fields
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
                        PurchaseRate += ValueEntry."Cost per Unit"
                    else
                        if ValueEntry."Document Type" = ValueEntry."Document Type"::"Sales Invoice" then
                            PurchaseRate += ValueEntry."Cost per Unit";


                if ValueEntry."Document Type" = ValueEntry."Document Type"::"Purchase Invoice" then
                    if ValueEntry."Item Charge No." = '' then
                        if PurchInvLine.Get(ValueEntry."Document No.", ValueEntry."Document Line No.") then
                            if PurchInvHeader.Get(PurchInvLine."Document No.") then begin
                                ImportRateUSD := PurchInvLine."Direct Unit Cost";
                                GSTRate.Reset();
                                GSTRate.SetRange("From State", '');
                                GSTRate.SetRange("Location State Code", PurchInvHeader."Location State Code");
                                GSTRate.SetRange("GST Group Code", PurchInvLine."GST Group Code");
                                if GSTRate.FindFirst() then
                                    BCD := GSTRate."KFloodCess Percentage";
                                if (PurchInvHeader."Currency Code" <> '') and
                                   (PurchInvHeader."Currency Factor" <> 0)
                                then begin
                                    ExchageRate := 1 / PurchInvHeader."Currency Factor";
                                    CurrCode := PurchInvHeader."Currency Code";
                                    INRAccessibleValue := (PurchInvLine.Quantity * PurchInvLine."Direct Unit Cost") * ExchageRate;
                                    InsuranceAmount := PurchInvLine."Insurance Amount" * ExchageRate;
                                    OtherCharges := (PurchInvLine."Line Amount" + PurchInvLine."Freight Amount" + PurchInvLine."Insurance Amount") * ExchageRate;
                                    CustomDuty := Round(OtherCharges * BCD / 100, 0.01, '=');
                                    IGST := IGSTAmount(PurchInvLine);
                                end else begin
                                    ExchageRate := 0;
                                    CurrCode := PurchInvHeader."Currency Code";
                                    INRAccessibleValue := PurchInvLine.Quantity * PurchInvLine."Direct Unit Cost";
                                    InsuranceAmount := PurchInvLine."Insurance Amount";
                                    OtherCharges := PurchInvLine."Line Amount" + PurchInvLine."Freight Amount" + PurchInvLine."Insurance Amount";
                                    CustomDuty := Round(OtherCharges * BCD / 100, 0.01, '=');
                                    IGST := IGSTAmount(PurchInvLine);
                                end;
                            end;
            until ValueEntry.Next() = 0;

        // Step 6: Safety Check
        if ImportRateUSD = 0 then begin
            INRAccessibleValue := 0;
            InsuranceAmount := 0;
            OtherCharges := 0;
            CustomDuty := 0;
            IGST := 0;
        end;

        // Step 7: Clearing & Forwarding + Freight from Item Charge Value Entries
        Clear(ClearingForwarding);
        Clear(FreightAmount);
        Clear(ClearingAmount);

        ValueEntry.Reset();
        ValueEntry.SetRange("Item Ledger Entry No.", AppliedILE."Entry No.");
        ValueEntry.SetRange("Item No.", ItemNo);
        ValueEntry.SetFilter("Cost per Unit", '>%1', 0);
        if ValueEntry.FindSet() then
            repeat
                PurchInvLine.Reset();
                PurchInvLine.SetRange("Document No.", ValueEntry."Document No.");
                PurchInvLine.SetRange(Type, PurchInvLine.Type::"Charge (Item)");
                PurchInvLine.SetRange("No.", ValueEntry."Item Charge No.");
                PurchInvLine.SetRange("Line No.", ValueEntry."Document Line No.");
                if PurchInvLine.FindFirst() then
                    if ValueEntry."Valued Quantity" <> 0 then
                        if PurchInvHeader.Get(PurchInvLine."Document No.") then begin
                            if PurchInvLine."No." = 'CLEARING CHARGES' then
                                if (PurchInvHeader."Currency Code" <> '') and (PurchInvHeader."Currency Factor" <> 0) then
                                    ClearingForwarding +=
                                        ((ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity") * SalesInvoiceLine.Quantity)
                                        * (1 / PurchInvHeader."Currency Factor")
                                else
                                    ClearingForwarding +=
                                        (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity") * SalesInvoiceLine.Quantity;

                            if PurchInvLine."No." = 'FOREIGN FREIGHT' then
                                if (PurchInvHeader."Currency Code" <> '') and (PurchInvHeader."Currency Factor" <> 0) then
                                    FreightAmount +=
                                        ((ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity") * SalesInvoiceLine.Quantity)
                                        * (1 / PurchInvHeader."Currency Factor")
                                else
                                    FreightAmount +=
                                        (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity") * SalesInvoiceLine.Quantity;
                        end;
            until ValueEntry.Next() = 0;
    end;

    local procedure GetGSTAmount(DocumentNo: Code[20]; LineNo: Integer): Decimal
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        TotalGST: Decimal;
    begin
        TotalGST := 0;
        DetailedGSTLedgerEntry.Reset();
        DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
        DetailedGSTLedgerEntry.SetRange("Document Line No.", LineNo);
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                TotalGST += DetailedGSTLedgerEntry."GST Amount";
            until DetailedGSTLedgerEntry.Next() = 0;
        exit(TotalGST);
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

    // COGS Amount is read directly off the Sales Invoice (no Document Type switch needed,
    // since the dataitem itself is now the Sales Invoice).
    local procedure InvoiceGetCOGSAmount(DocumentNo: Code[20]; ItemNo: Code[20]; LineNo: Integer): Decimal
    var
        ValueEntry: Record "Value Entry";
        GLItemLedgRelation: Record "G/L - Item Ledger Relation";
        GLEntry: Record "G/L Entry";
        COGSAmt: Decimal;
    begin
        COGSAmt := 0;
        // Step 1: Find Value Entries for this Item + Invoice Document
        ValueEntry.Reset();
        ValueEntry.SetRange("Document No.", DocumentNo);
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SetRange("Item No.", ItemNo);
        ValueEntry.SetRange("Document Line No.", LineNo);
        ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        if ValueEntry.FindSet() then
            repeat
                // Step 2: Find G/L Entry via G/L - Item Ledger Relation table (5823)
                GLItemLedgRelation.Reset();
                GLItemLedgRelation.SetRange("Value Entry No.", ValueEntry."Entry No.");
                if GLItemLedgRelation.FindSet() then
                    repeat
                        // Step 3: Get G/L Entry and filter COGS accounts only
                        if GLEntry.Get(GLItemLedgRelation."G/L Entry No.") then
                            if GLEntry."G/L Account No." in ['32720', '32730', '32740'] then
                                COGSAmt += GLEntry.Amount;
                    until GLItemLedgRelation.Next() = 0;
            until ValueEntry.Next() = 0;

        exit(Abs(COGSAmt));
    end;

    local procedure CreditGetCOGSAmount(DocumentNo: Code[20]; ItemNo: Code[20]; LineNo: Integer): Decimal
    var
        ValueEntry: Record "Value Entry";
        GLItemLedgRelation: Record "G/L - Item Ledger Relation";
        GLEntry: Record "G/L Entry";
        COGSAmt: Decimal;
        GSTBuffer: Record "GST Posting Buffer";
    begin
        COGSAmt := 0;
        // Step 1: Find Value Entries for this Item + Invoice Document
        ValueEntry.Reset();
        ValueEntry.SetRange("Document No.", DocumentNo);
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Credit Memo");
        ValueEntry.SetRange("Item No.", ItemNo);
        ValueEntry.SetRange("Document Line No.", LineNo);
        ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        if ValueEntry.FindSet() then
            repeat
                // Step 2: Find G/L Entry via G/L - Item Ledger Relation table (5823)
                GLItemLedgRelation.Reset();
                GLItemLedgRelation.SetRange("Value Entry No.", ValueEntry."Entry No.");
                if GLItemLedgRelation.FindSet() then
                    repeat
                        // Step 3: Get G/L Entry and filter COGS accounts only
                        if GLEntry.Get(GLItemLedgRelation."G/L Entry No.") then
                            if GLEntry."G/L Account No." in ['32720', '32730', '32740'] then
                                COGSAmt += GLEntry.Amount;
                    until GLItemLedgRelation.Next() = 0;
            until ValueEntry.Next() = 0;

        exit(Abs(COGSAmt));
    end;

    procedure MakeExcelDataHeader()
    begin

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
        ExcelBuffer.AddColumn('Margin Statement Detail DC ' + Format(SalesOrdeType), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

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

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Transaction Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sales Order Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        //ExcelBuffer.AddColumn('Invoice #', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Doc No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer PO#', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); //TBC-1068
        ExcelBuffer.AddColumn('Department Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regional Office Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Teams Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
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
        ExcelBuffer.AddColumn('COGS Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
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
        ExcelBuffer.AddColumn('Import PO#', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
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
        ExcelBuffer.CreateNewBook('Net Margin Report - Invoice');
        ExcelBuffer.WriteSheet('Net Margin Report - Invoice', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Net Margin Report - Invoice');
        ExcelBuffer.OpenExcel();
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: Date;
        EndDate: Date;
        CompanyInfo: Record "Company Information";
        SalesOrdeType: Option " ",AMC,CLAIMS,CMC,CONSUMBALE,INSTRUMENT,SPARES,SERVICES;
        SalesOrderNo: Code[20];
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
        // Global variables populated by GetCostFromInvoiceLine
        ExchageRate: Decimal;
        PurchaseOrderNo: Code[20];
        InvoiceNo: Code[20];
        RefInvoiceNo: Text;
        CurrCode: Code[10];
        CustomDuty: Decimal;
        INRAccessibleValue: Decimal;
        OtherCharges: Decimal;
        InsuranceAmount: Decimal;
        IGST: Decimal;
        ImportRateUSD: Decimal;
        ClearingForwarding: Decimal;
        FreightAmount: Decimal;
        ClearingAmount: Decimal;
        Shipmentmode: Text[50];
        BCD: Decimal;
        InvoiceCOGSAmount: Decimal;
        COGSAmount: Decimal;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCreditMemoLine: Record "Sales Cr.Memo Line";
        SalesHeader: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
}
