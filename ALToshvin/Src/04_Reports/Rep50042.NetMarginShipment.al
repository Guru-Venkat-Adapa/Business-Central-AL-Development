report 50042 "Net Margin - Shipment"
{
    ApplicationArea = All;
    Caption = 'Net Margin - Shipment';
    UsageCategory = ReportsAndAnalysis;
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
                var
                    SaleILE: Record "Item Ledger Entry";
                    IsInvoiced: Boolean;
                begin
                    IsInvoiced := false;

                    // DEFINITIVE CHECK: ILE Invoiced Quantity
                    // When a shipment line is fully invoiced, the Sale ILE field
                    // "Invoiced Quantity" equals "Quantity" (both negative for sales).
                    // This works regardless of how Sales Invoice Lines store shipment references,
                    // and correctly handles multi-shipment invoices.
                    SaleILE.Reset();
                    SaleILE.SetRange("Document No.", "Sales Shipment Line"."Document No.");
                    SaleILE.SetRange("Document Line No.", "Sales Shipment Line"."Line No.");
                    SaleILE.SetRange("Item No.", "Sales Shipment Line"."No.");
                    SaleILE.SetRange("Entry Type", SaleILE."Entry Type"::Sale);
                    if SaleILE.FindFirst() then
                        if SaleILE."Invoiced Quantity" = SaleILE.Quantity then
                            IsInvoiced := true;

                    // Only process un-invoiced (pending) shipment lines
                    if IsInvoiced then
                        CurrReport.Skip();


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
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        ShipmentNos: Text;
        PurchaseRate: Decimal;
        PurchaseValue: Decimal;
        TaxableValue: Decimal;
        GrossValue: Decimal;
        MarginValue: Decimal;
        LotNo: Code[50];
        FolioNo: Code[100];

        LandedCost: Decimal;
        InvoiceNo: Code[20];
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
        Clear(InvoiceNo);


        // Clear global variables used by GetCostFromShipmentLine
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
        Clear(PurchaseOrderNo);

        // Get Cost, LotNo, FolioNo from Shipment Line via ILE chain
        GetCostFromShipmentLine("Sales Shipment Line", "Sales Shipment Line"."No.", PurchaseRate, LotNo, FolioNo);


        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetCurrentKey("Shipment No.");
        SalesInvoiceLine.SetRange("Shipment No.", "Sales Shipment Header"."No.");
        SalesInvoiceLine.SetRange("Shipment Line No.", "Sales Shipment Line"."Line No.");
        if SalesInvoiceLine.FindFirst() then
            InvoiceNo := SalesInvoiceLine."Document No.";

        ExcelBuffer.NewRow();

        // 1. Sales Order Type & Invoice #
        ExcelBuffer.AddColumn("Sales Shipment Header"."Sales Order Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 2. Doc No. (Shipment No.)
        ExcelBuffer.AddColumn("Sales Shipment Header"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 3. Date
        ExcelBuffer.AddColumn("Sales Shipment Header"."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

        //TBC-1068 ---->
        if "Sales Shipment Header"."External Document No." <> '' then
            ExcelBuffer.AddColumn("Sales Shipment Header"."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else begin
            SalesHeader.Reset();
            SalesHeader.SetRange("No.", "Sales Shipment Header"."Order No.");
            if SalesHeader.FindFirst() and (SalesHeader."External Document No." <> '') then
                ExcelBuffer.AddColumn(SalesHeader."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
            else begin
                SalesHeaderArchive.Reset();
                SalesHeaderArchive.SetRange("No.", "Sales Shipment Header"."Order No.");
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
        DimensionValue.SetRange(Code, "Sales Shipment Header"."Shortcut Dimension 1 Code");
        if DimensionValue.FindFirst() then
            ExcelBuffer.AddColumn(DimensionValue.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 5. Regional Office Name (Shortcut Dimension 2)
        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 2 Code");
        DimensionValue.SetRange(Code, "Sales Shipment Header"."Shortcut Dimension 2 Code");
        if DimensionValue.FindFirst() then
            ExcelBuffer.AddColumn(DimensionValue.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Temas 
        DimensionValue.Reset();
        DimensionValue.SetRange(Code, "Sales Shipment Header"."Shortcut Dimension 3 Code");
        if DimensionValue.FindFirst() then
            ExcelBuffer.AddColumn(DimensionValue.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 6. Customer AC Code
        ExcelBuffer.AddColumn("Sales Shipment Header"."Sell-to Customer No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 7. Customer AC Name
        ExcelBuffer.AddColumn("Sales Shipment Header"."Sell-to Customer Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 8. Item Code
        ExcelBuffer.AddColumn("Sales Shipment Line"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 9. Item Name
        ExcelBuffer.AddColumn("Sales Shipment Line".Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 10. Quantity
        ExcelBuffer.AddColumn("Sales Shipment Line".Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // 11. Rate (Unit Price)
        ExcelBuffer.AddColumn("Sales Shipment Line"."Unit Price", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // 12. Gross (Qty x Unit Price before discount)
        GrossValue := "Sales Shipment Line".Quantity * "Sales Shipment Line"."Unit Price";
        ExcelBuffer.AddColumn(GrossValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 13. Taxable Value (Line Amount after discount)
        TaxableValue := "Sales Shipment Line"."Unit Price" * "Sales Shipment Line".Quantity;
        ExcelBuffer.AddColumn(TaxableValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 14. Purchase Rate (from GetCostFromShipmentLine)
        ExcelBuffer.AddColumn(PurchaseRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 15. Purchase Value (Purchase Rate x Qty)
        PurchaseValue := PurchaseRate * "Sales Shipment Line".Quantity;
        ExcelBuffer.AddColumn(PurchaseValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 16. Batch Rate (Cost per Unit for this Lot from Purchase Value Entry)
        ExcelBuffer.AddColumn(PurchaseRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 17. Batch / Lot No. (from ILE via GetCostFromShipmentLine)
        ExcelBuffer.AddColumn(LotNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 18. Margin Value (Taxable Value - Purchase Value)
        // if InvoiceNo <> '' then
        //     InvoiceCOGSAmount := InvoiceGetCOGSAmount(InvoiceNo, "Sales Shipment Line"."No.")
        // else
        //     InvoiceCOGSAmount := GetShipmentCOGSAmount("Sales Shipment Header"."No.", "Sales Shipment Line"."No.");

        InvoiceCOGSAmount := GetShipmentCOGSAmount("Sales Shipment Header"."No.", "Sales Shipment Line"."No.", "Sales Shipment Line"."Line No.");

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

        // 27. IGST (from Detailed GST Ledger Entry via Sales Invoice)
        ExcelBuffer.AddColumn(IGST, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 28. Landed Cost (Purchase Value + CustomDuty + ClearingForwarding + FreightAmount + InsuranceAmount)
        LandedCost := PurchaseValue + CustomDuty + ClearingForwarding + FreightAmount + InsuranceAmount;
        ExcelBuffer.AddColumn(LandedCost, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // 29. Shipment Mode (from Posted Whse. Receipt via GetCostFromShipmentLine)
        ExcelBuffer.AddColumn(Shipmentmode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 30. Folio No Master Name (from Purch. Rcpt. Header via GetCostFromShipmentLine)
        ExcelBuffer.AddColumn(PurchaseOrderNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(FolioNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 31. Narration
        ExcelBuffer.AddColumn("Sales Shipment Header"."Posting Description", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 32. Programmable Field
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 33. Batch Rate Testing
        ExcelBuffer.AddColumn(0, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // 34. BTrt
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 35. Regional Group Name
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 36. Order No.
        ExcelBuffer.AddColumn("Sales Shipment Header"."Order No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 37. Order Master Name
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 38. Base Link doc. Number (Invoice No.)
        ExcelBuffer.AddColumn(InvoiceNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // 39. Line Comment
        ExcelBuffer.AddColumn("Sales Shipment Line"."Description 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
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
        PurchaseHeader: Record "Purchase Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
        GSTRate: Record "Gst Rate Percentage";
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

        // Step 1: Find Sale ILE from Shipment Line
        SaleILE.Reset();
        SaleILE.SetRange("Document No.", SalesShipmentLine."Document No.");
        SaleILE.SetRange("Document Line No.", SalesShipmentLine."Line No.");
        SaleILE.SetRange("Item No.", ItemNo);
        SaleILE.SetRange("Entry Type", SaleILE."Entry Type"::Sale);
        if not SaleILE.FindFirst() then
            exit;

        // Step 2: Lot No. from Sale ILE
        LotNo := SaleILE."Lot No.";

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
                                    OtherCharges := Round((PurchInvLine."Line Amount" + PurchInvLine."Freight Amount" + PurchInvLine."Insurance Amount") * BCD / 100, 0.01, '=');
                                    CustomDuty := Round(OtherCharges * ExchageRate, 0.01, '=');
                                    IGST := IGSTAmount(PurchInvLine);
                                end else begin
                                    ExchageRate := 0;
                                    CurrCode := PurchInvHeader."Currency Code";
                                    INRAccessibleValue := PurchInvLine.Quantity * PurchInvLine."Direct Unit Cost";
                                    InsuranceAmount := PurchInvLine."Insurance Amount";
                                    CustomDuty := Round((PurchInvLine."Line Amount" + PurchInvLine."Freight Amount" + PurchInvLine."Insurance Amount") * BCD / 100, 0.01, '=');
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
                                        ((ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity") * SalesShipmentLine.Quantity)
                                        * (1 / PurchInvHeader."Currency Factor")
                                else
                                    ClearingForwarding +=
                                        (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity") * SalesShipmentLine.Quantity;

                            if PurchInvLine."No." = 'FOREIGN FREIGHT' then
                                if (PurchInvHeader."Currency Code" <> '') and (PurchInvHeader."Currency Factor" <> 0) then
                                    FreightAmount +=
                                        ((ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity") * SalesShipmentLine.Quantity)
                                        * (1 / PurchInvHeader."Currency Factor")
                                else
                                    FreightAmount +=
                                        (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity") * SalesShipmentLine.Quantity;
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



    // local procedure GetCOGSAmount(InvoiceNo: Code[20]): Decimal
    // var
    //     GLEntry: Record "G/L Entry";
    //     DebitCOGSAmount: Decimal;
    //     CreditCOGSAmount: Decimal;
    //     DifferanceAmount: Decimal;
    // begin
    //     CreditCOGSAmount := 0;
    //     DebitCOGSAmount := 0;
    //     DifferanceAmount := 0;
    //     GLEntry.Reset();
    //     GLEntry.SetRange("Document No.", InvoiceNo);
    //     GLEntry.SetFilter("G/L Account No.", '%1|%2|%3', '32720', '32730', '32740');
    //     if GLEntry.FindSet() then
    //         repeat
    //             DebitCOGSAmount += GLEntry."Debit Amount";
    //             CreditCOGSAmount += GLEntry."Credit Amount";
    //         until GLEntry.Next() = 0;

    //     DifferanceAmount := DebitCOGSAmount - CreditCOGSAmount;
    //     exit(DifferanceAmount);
    // end;

    local procedure InvoiceGetCOGSAmount(DocumentNo: Code[20]; ItemNo: Code[20]): Decimal
    var
        ValueEntry: Record "Value Entry";
        GLItemLedgRelation: Record "G/L - Item Ledger Relation";  // Table 5823 ← correct table
        GLEntry: Record "G/L Entry";
        COGSAmount: Decimal;
    begin
        COGSAmount := 0;
        // Step 1: Find Value Entries for this Item + Document
        ValueEntry.Reset();
        ValueEntry.SetRange("Document No.", DocumentNo);
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SetRange("Item No.", ItemNo);
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
                                COGSAmount += GLEntry.Amount;
                    until GLItemLedgRelation.Next() = 0;
            until ValueEntry.Next() = 0;

        exit(Abs(COGSAmount));
    end;

    local procedure GetShipmentCOGSAmount(DocumentNo: Code[20]; ItemNo: Code[20]; LineNo: Integer): Decimal
    var
        ValueEntry: Record "Value Entry";
        GLItemLedgRelation: Record "G/L - Item Ledger Relation";
        GLEntry: Record "G/L Entry";
        COGSAmount: Decimal;
    begin
        COGSAmount := 0;

        ValueEntry.Reset();
        ValueEntry.SetRange("Document No.", DocumentNo);
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Shipment"); // ✅ Added
        ValueEntry.SetRange("Item No.", ItemNo);
        ValueEntry.SetRange("Document Line No.", LineNo);
        ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        if ValueEntry.FindSet() then
            repeat
                GLItemLedgRelation.Reset();
                GLItemLedgRelation.SetRange("Value Entry No.", ValueEntry."Entry No.");
                if GLItemLedgRelation.FindSet() then
                    repeat
                        if GLEntry.Get(GLItemLedgRelation."G/L Entry No.") then
                            if GLEntry."G/L Account No." = '30190' then
                                COGSAmount += GLEntry.Amount;
                    until GLItemLedgRelation.Next() = 0;
            until ValueEntry.Next() = 0;

        exit(Abs(COGSAmount));
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
        ExcelBuffer.CreateNewBook('Net Margin Report - Shipment');
        ExcelBuffer.WriteSheet('Net Margin Report - Shipment', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Net Margin Report - Shipment');
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
        // Global variables populated by GetCostFromShipmentLine
        ExchageRate: Decimal;
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
        PurchaseOrderNo: Code[20];
        BCD: Decimal;
        InvoiceCOGSAmount: Decimal;
        COGSAmount: Decimal;
        SalesHeader: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
}
