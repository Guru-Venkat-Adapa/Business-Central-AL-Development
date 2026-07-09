
report 50032 "Inventory By Location"
{
    ApplicationArea = All;
    Caption = 'Custom Inventory By Location';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Item No.", "Location Code")
                                where("Remaining Quantity" = filter(> 0));


            trigger OnPreDataItem()
            begin
                if LocationCode <> '' then
                    SetRange("Location Code", LocationCode);

                MakeExcelDataHeader();
            end;

            trigger OnAfterGetRecord()
            begin
                MakeExcelDataBody();
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
        ExcelBuffer.DeleteAll();

        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPostReport()
    begin
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

        ReportRunDate := 'Report Run Date ' + Format(Today);
        ExcelBuffer.AddColumn(ReportRunDate, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();

        ExcelBuffer.AddColumn('Item No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Description', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Lot No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Remaining Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Currency Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Currency Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('Import Rate/Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Accessible Value in INR', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Insurance Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Custom Duty', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Clearing & Forwarding', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Freight Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IGST', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Landed Cost ', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Shipment mode', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Folio No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Location Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Reserved Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO#', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Special Order Qty', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sales Order No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Special SO# Tracking Qty', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);//TBC-1051
        ExcelBuffer.AddColumn('Available Qty.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        //TBC-1047  --->
        ExcelBuffer.AddColumn('Item Tracking Qty', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO#', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        //TBC-1047 <----
        ExcelBuffer.AddColumn('GRN Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('GRN No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('GRN Line No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor Order No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor Invoice No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor Invoice Posting Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Order No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Order Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Assigned User ID', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody()
    begin
        ClearAllVariables();

        //----------------------------------------
        // FIND ORIGINAL PURCHASE RECEIPT ENTRY
        //----------------------------------------

        // SourceEntryNo := FindPurchaseReceiptEntry();

        // if SourceEntryNo = 0 then
        //     CurrReport.Skip();

        // PurchaseILE.Get(SourceEntryNo);

        SourceEntryNo := FindPurchaseReceiptEntry();

        if SourceEntryNo <> 0 then
            PurchaseILE.Get(SourceEntryNo)
        else
            PurchaseILE := "Item Ledger Entry";

        //----------------------------------------
        // ITEM DETAILS
        //----------------------------------------

        ExcelBuffer.NewRow();

        ExcelBuffer.AddColumn("Item Ledger Entry"."Item No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        if RecItem.Get("Item Ledger Entry"."Item No.") then
            ExcelBuffer.AddColumn(RecItem.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Item Ledger Entry"."Lot No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Item Ledger Entry".Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn("Item Ledger Entry"."Remaining Quantity", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        //----------------------------------------
        // PURCHASE RATE
        //----------------------------------------

        ValueEntry.Reset();
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Purchase Invoice");
        ValueEntry.SetRange("Item Ledger Entry No.", PurchaseILE."Entry No.");
        ValueEntry.SetRange("Item No.", PurchaseILE."Item No.");
        ValueEntry.SetFilter("Item Charge No.", '=%1', ''); //28/05/2026
        ValueEntry.SetFilter("Cost per Unit", '<>%1', 0); //28/05/2026
        if LocationCode <> '' then
            ValueEntry.SetRange("Location Code", LocationCode);
        if ValueEntry.FindSet() then begin
            repeat
                PurchaseRate += ValueEntry."Cost per Unit";
            until ValueEntry.Next() = 0;
        end;

        //----------------------------------------
        // PURCHASE RECEIPT HEADER
        //----------------------------------------

        if PurchRcptHeader.Get(PurchaseILE."Document No.") then
            FolioNo := PurchRcptHeader."Folio No.";

        //----------------------------------------
        // PURCHASE INVOICE DETAILS
        //----------------------------------------

        ValueEntry.Reset();
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Purchase Invoice");
        ValueEntry.SetRange("Item Ledger Entry No.", PurchaseILE."Entry No.");
        ValueEntry.SetRange("Item No.", PurchaseILE."Item No.");
        ValueEntry.SetFilter("Item Charge No.", '=%1', ''); //28/05/2026
        if ValueEntry.FindFirst() then begin
            PurchInvLine.Reset();
            PurchInvLine.SetRange("Document No.", ValueEntry."Document No.");
            PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
            PurchInvLine.SetRange("No.", ValueEntry."Item No.");
            PurchInvLine.SetRange("Line No.", ValueEntry."Document Line No.");
            if PurchInvLine.FindFirst() then begin
                ImportRateUSD := PurchInvLine."Direct Unit Cost";

                if PurchInvHeader.Get(PurchInvLine."Document No.") then begin
                    //Custom Duty --->
                    GstRatePercentage.Reset();
                    GstRatePercentage.SetRange("GST Group Code", PurchInvLine."GST Group Code");
                    GstRatePercentage.SetRange("Location State Code", PurchInvHeader."Location State Code");
                    GstRatePercentage.SetRange("From State", '');
                    if GstRatePercentage.FindFirst() then
                        BCD := GstRatePercentage."KFloodCess Percentage";
                    //Custom Duty <---
                    if (PurchInvHeader."Currency Code" <> '') and (PurchInvHeader."Currency Factor" <> 0)
                    then begin
                        CurrencyCode := PurchInvHeader."Currency Code";
                        CurrenacyRate := 1 / PurchInvHeader."Currency Factor";
                        INRAccessibleValue := (PurchInvLine.Quantity * PurchInvLine."Direct Unit Cost") *
                            (1 / PurchInvHeader."Currency Factor");
                        InsuranceAmount := PurchInvLine."Insurance Amount" * (1 / PurchInvHeader."Currency Factor");
                        OtherCharges := ROUND((PurchInvLine."Line Amount" + PurchInvLine."Freight Amount" + PurchInvLine."Insurance Amount") * BCD / 100, 0.01, '=');
                        CustomDuty := ROUND(OtherCharges * (1 / PurchInvHeader."Currency Factor"), 0.01, '=');
                        IGST := IGSTAmount(PurchInvLine) * (1 / PurchInvHeader."Currency Factor");
                    end else begin
                        CurrencyCode := PurchInvHeader."Currency Code";
                        CurrenacyRate := 0;
                        INRAccessibleValue := PurchInvLine.Quantity * PurchInvLine."Direct Unit Cost";
                        InsuranceAmount := PurchInvLine."Insurance Amount";
                        CustomDuty := Round((PurchInvLine."Line Amount" + PurchInvLine."Freight Amount" + PurchInvLine."Insurance Amount") * BCD / 100, 0.01, '=');
                        IGST := IGSTAmount(PurchInvLine);
                    end;
                end;
            end;
        end;

        ////Clearing & Forwarding  and freight Amount Calculation --->
        Clear(ClearingForwarding);
        Clear(FreightAmount);
        Clear(ClearingAmount);
        Clear(ClearingAmount);
        Clear(FreightAmount);
        Clear(ClearingAmount);
        Clear(FreightAmount);

        ValueEntry.Reset();
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Purchase Invoice");
        ValueEntry.SetRange("Item Ledger Entry No.", PurchaseILE."Entry No.");
        ValueEntry.SetRange("Item No.", PurchaseILE."Item No.");
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
                                        * "Item Ledger Entry"."Remaining Quantity")
                                        * (1 / PurchInvHeader."Currency Factor")
                                else
                                    ClearingForwarding +=
                                        (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
                                        * "Item Ledger Entry"."Remaining Quantity";
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
                                        * "Item Ledger Entry"."Remaining Quantity")
                                        * (1 / PurchInvHeader."Currency Factor")
                                else
                                    FreightAmount +=
                                        (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
                                        * "Item Ledger Entry"."Remaining Quantity";
                            end;
                        end;
                    end;
                end;
            until ValueEntry.Next() = 0;
        end;

        ////Clearing & Forwarding  and freight Amount  Calculation <----

        //----------------------------------------
        // ADD PURCHASE DATA
        //----------------------------------------

        ExcelBuffer.AddColumn(CurrencyCode, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CurrenacyRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn(ImportRateUSD, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn(INRAccessibleValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn(InsuranceAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Cutom Duty
        ExcelBuffer.AddColumn(CustomDuty, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Clearing & Forwarding
        ExcelBuffer.AddColumn(ClearingForwarding, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Freight Amount
        ExcelBuffer.AddColumn(FreightAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // IGST
        ExcelBuffer.AddColumn(IGST, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Purchase Value
        if (PurchInvHeader."Currency Code" <> '') and (PurchInvHeader."Currency Factor" <> 0) then
            PurchaseValue := ("Item Ledger Entry"."Remaining Quantity" * PurchaseRate) * (1 / PurchInvHeader."Currency Factor")
        else
            PurchaseValue := "Item Ledger Entry"."Remaining Quantity" * PurchaseRate;

        //Landed Cost
        LandedCost := PurchaseValue + InsuranceAmount + ClearingForwarding + FreightAmount + CustomDuty;
        ExcelBuffer.AddColumn(LandedCost, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);



        //----------------------------------------
        // SHIPMENT MODE
        //----------------------------------------

        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Document No.", PurchaseILE."Document No.");
        PurchRcptLine.SetRange("No.", PurchaseILE."Item No.");
        if PurchRcptLine.FindFirst() then begin
            PostedWhsReceiptHeader.Reset();
            PostedWhsReceiptHeader.SetRange("No.", PurchRcptLine."Posted Warehouse Rec No");
            if PostedWhsReceiptHeader.FindFirst() then
                Shipmentmode := PostedWhsReceiptHeader."Mode Of Shipment";
        end;

        ExcelBuffer.AddColumn(Shipmentmode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(FolioNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //----------------------------------------
        // PURCHASE VALUE
        //----------------------------------------

        //PurchaseValue := "Item Ledger Entry"."Remaining Quantity" * PurchaseRate;


        ExcelBuffer.AddColumn(PurchaseValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn(PurchaseRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //----------------------------------------
        // LOCATION
        //----------------------------------------

        ExcelBuffer.AddColumn("Item Ledger Entry"."Location Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //----------------------------------------
        // RESERVED QTY
        //----------------------------------------

        "Item Ledger Entry".CalcFields("Reserved Quantity");
        ExcelBuffer.AddColumn("Item Ledger Entry"."Reserved Quantity", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        //----------------------------------------
        // SALES ORDER DETAILS
        //----------------------------------------

        if "Item Ledger Entry"."Reserved Quantity" <> 0 then begin
            ReservationEntry.Reset();
            ReservationEntry.SetCurrentKey("Item No.", "Location Code");
            ReservationEntry.SetRange("Item No.", "Item Ledger Entry"."Item No.");
            ReservationEntry.SetRange("Location Code", "Item Ledger Entry"."Location Code");
            ReservationEntry.SetRange("Source Type", Database::"Sales Line");
            if "Item Ledger Entry"."Lot No." <> '' then
                ReservationEntry.SetRange("Lot No.", "Item Ledger Entry"."Lot No.");

            if ReservationEntry.FindFirst() then begin
                SalesOrderNo := ReservationEntry."Source ID";

                if SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo) then
                    CustomerName := SalesHeader."Sell-to Customer Name";
            end;
        end;

        ExcelBuffer.AddColumn(SalesOrderNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(CustomerName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //----------------------------------------
        // SPECIAL ORDER
        //----------------------------------------

        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Document No.", PurchaseILE."Document No.");
        PurchRcptLine.SetRange("No.", PurchaseILE."Item No.");
        if PurchRcptLine.FindFirst() then begin
            if PurchLine.Get(
                PurchLine."Document Type"::Order,
                PurchRcptLine."Order No.",
                PurchRcptLine."Order Line No.")
            then begin
                if PurchLine."Special Order" then begin
                    SpecialOrderQty := PurchLine.Quantity;
                    SpecialSalesOrderNo := PurchLine."Special Order Sales No.";

                    if SalesHeader.Get(
                        SalesHeader."Document Type"::Order,
                        SpecialSalesOrderNo)
                    then
                        SpecialCustomerName := SalesHeader."Sell-to Customer Name";
                end;
            end;
        end;

        //TBC-1051 ------>
        Clear(SpecialTrackingQty);
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Item No.", "Item Ledger Entry"."Item No.");
        ReservationEntry.SetRange("Lot No.", "Item Ledger Entry"."Lot No.");
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Location Code", "Item Ledger Entry"."Location Code");
        if ReservationEntry.FindSet() then
            repeat
                SpecialTrackingQty += Abs(ReservationEntry."Quantity (Base)");
            until ReservationEntry.Next() = 0;

        //TBC-1051 <------

        ExcelBuffer.AddColumn(SpecialOrderQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn(SpecialSalesOrderNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(SpecialCustomerName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(SpecialTrackingQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number); //TBC-1051
        //----------------------------------------
        // AVAILABLE QTY
        //----------------------------------------

        AvailableQty :=
            "Item Ledger Entry"."Remaining Quantity"
            - "Item Ledger Entry"."Reserved Quantity"
            - SpecialOrderQty;


        ExcelBuffer.AddColumn(AvailableQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        //TBC-1047  --->
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Item No.", "Item Ledger Entry"."Item No.");
        ReservationEntry.SetRange("Location Code", "Item Ledger Entry"."Location Code");
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Surplus);
        if "Item Ledger Entry"."Lot No." <> '' then
            ReservationEntry.SetRange("Lot No.", "Item Ledger Entry"."Lot No.");
        if ReservationEntry.FindFirst() then begin
            TrackingQtyBase := Abs(ReservationEntry."Quantity (Base)");
            TrackingSalesOrderNo := ReservationEntry."Source ID";
            if SalesHeader.Get(SalesHeader."Document Type"::Order, TrackingSalesOrderNo) then
                TrackingCustomerName := SalesHeader."Sell-to Customer Name";
        end;



        ExcelBuffer.AddColumn(TrackingQtyBase, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn(TrackingSalesOrderNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(TrackingCustomerName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //TBC-1047  <---


        //----------------------------------------
        // GRN DETAILS
        //----------------------------------------

        GRNNo := PurchaseILE."Document No.";
        GRNDate := PurchaseILE."Posting Date";

        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Document No.", GRNNo);
        PurchRcptLine.SetRange("No.", PurchaseILE."Item No.");
        if PurchRcptLine.FindFirst() then
            GRNLineNo := PurchRcptLine."Line No.";

        ExcelBuffer.AddColumn(GRNDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

        ExcelBuffer.AddColumn(GRNNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(GRNLineNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        //----------------------------------------
        // VENDOR DETAILS
        //----------------------------------------

        PurchInvLine.Reset();
        PurchInvLine.SetRange("Receipt No.", PurchaseILE."Document No.");
        if PurchInvLine.FindFirst() then begin
            if PurchInvHeader.Get(PurchInvLine."Document No.") then begin
                VendorInvoiceNo := PurchInvHeader."Vendor Invoice No.";
                PostingDate := PurchInvHeader."Posting Date";
            end;
        end;

        //Old Code 23/06/2026 ------>
        // PurchRcptLine.Reset();
        // PurchRcptLine.SetRange("Document No.", PurchaseILE."Document No.");
        // if PurchRcptLine.FindFirst() then begin
        //     PoNo := PurchRcptLine."Order No.";
        //     if PurchHeader.Get(PurchHeader."Document Type"::Order, PoNo) then begin
        //         POOrderDate := PurchHeader."Order Date";
        //         VendorOrderNo := PurchHeader."Vendor Order No.";
        //         AssignedUserID := PurchHeader."Custom Assigned User ID";
        //     end else begin
        //         PurchHeaderArchive.Reset();
        //         PurchHeaderArchive.SetRange("Document Type", PurchHeaderArchive."Document Type"::Order);
        //         PurchHeaderArchive.SetRange("No.", PoNo);
        //         if PurchHeaderArchive.FindLast() then begin
        //             POOrderDate := PurchHeaderArchive."Order Date";
        //             AssignedUserID := PurchHeaderArchive."Assigned User ID";
        //             VendorOrderNo := PurchHeaderArchive."Vendor Order No."
        //         end;
        //     end;
        // end;
        //Old Code 23/06/2026 <------

        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Document No.", PurchaseILE."Document No.");

        if not PurchRcptLine.FindFirst() then
            exit;

        PoNo := PurchRcptLine."Order No.";

        // Step 1: Get data from Purchase Receipt Header
        if PurchRcptHeader.Get(PurchRcptLine."Document No.") then begin
            AssignedUserID := PurchRcptHeader."Custom Assigned User ID";
            VendorOrderNo := PurchRcptHeader."Vendor Order No.";
        end;

        // Step 2: Check Purchase Header
        if PurchHeader.Get(PurchHeader."Document Type"::Order, PoNo) then begin
            POOrderDate := PurchHeader."Order Date";

            if AssignedUserID = '' then
                AssignedUserID := PurchHeader."Custom Assigned User ID";

            if VendorOrderNo = '' then
                VendorOrderNo := PurchHeader."Vendor Order No.";
        end else begin
            // Step 3: Fallback to Purchase Header Archive
            PurchHeaderArchive.Reset();
            PurchHeaderArchive.SetRange("Document Type", PurchHeaderArchive."Document Type"::Order);
            PurchHeaderArchive.SetRange("No.", PoNo);

            if PurchHeaderArchive.FindLast() then begin
                POOrderDate := PurchHeaderArchive."Order Date";

                if AssignedUserID = '' then
                    AssignedUserID := PurchHeaderArchive."Assigned User ID";

                if VendorOrderNo = '' then
                    VendorOrderNo := PurchHeaderArchive."Vendor Order No.";
            end;
        end;

        ExcelBuffer.AddColumn(VendorOrderNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(VendorInvoiceNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(PostingDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(PoNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(POOrderDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

        ExcelBuffer.AddColumn(AssignedUserID, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure FindPurchaseReceiptEntry(): Integer
    begin

        //----------------------------------------
        // CURRENT ENTRY IS PURCHASE RECEIPT
        //----------------------------------------

        if "Item Ledger Entry"."Document Type" =
           "Item Ledger Entry"."Document Type"::"Purchase Receipt"
        then
            exit("Item Ledger Entry"."Entry No.");

        //----------------------------------------
        // FIND ORIGINAL PURCHASE RECEIPT
        //----------------------------------------

        PurchaseILE.Reset();
        PurchaseILE.SetCurrentKey("Item No.", "Lot No.", "Posting Date");
        PurchaseILE.SetRange("Item No.", "Item Ledger Entry"."Item No.");
        PurchaseILE.SetRange("Lot No.", "Item Ledger Entry"."Lot No.");
        PurchaseILE.SetRange("Location Code", "Item Ledger Entry"."Location Code");
        PurchaseILE.SetRange("Document Type", PurchaseILE."Document Type"::"Purchase Receipt");
        PurchaseILE.SetFilter(Quantity, '>%1', 0);
        if PurchaseILE.FindFirst() then
            exit(PurchaseILE."Entry No.");

        exit(0);
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


    local procedure ClearAllVariables()
    begin
        Clear(SourceEntryNo);
        Clear(PurchaseRate);
        Clear(PurchaseValue);
        Clear(ImportRateUSD);
        Clear(INRAccessibleValue);
        Clear(CurrenacyRate);
        Clear(CurrencyCode);
        Clear(Shipmentmode);
        Clear(FolioNo);
        Clear(InsuranceAmount);
        Clear(IGST);
        Clear(BCD);
        Clear(LandedCost);
        Clear(CustomDuty);
        Clear(OtherCharges);
        Clear(SalesOrderNo);
        Clear(CustomerName);
        Clear(SpecialOrderQty);
        Clear(SpecialSalesOrderNo);
        Clear(SpecialCustomerName);
        Clear(GRNNo);
        Clear(GRNDate);
        Clear(GRNLineNo);
        Clear(VendorInvoiceNo);
        Clear(PostingDate);
        Clear(PoNo);
        Clear(POOrderDate);
        Clear(AssignedUserID);
        Clear(VendorOrderNo);
        Clear(AvailableQty);
        //TBC-1047  --->
        Clear(TrackingQtyBase);
        Clear(TrackingSalesOrderNo);
        Clear(TrackingCustomerName);
        //TBC-1047  <---
    end;

    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('Inventory By Location');
        ExcelBuffer.WriteSheet('Inventory By Location', '', UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Inventory By Location');
        ExcelBuffer.OpenExcel();
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        CompanyInfo: Record "Company Information";
        RecItem: Record Item;
        ReservationEntry: Record "Reservation Entry";
        SalesHeader: Record "Sales Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchHeader: Record "Purchase Header";
        PurchHeaderArchive: Record "Purchase Header Archive";
        PurchLine: Record "Purchase Line";
        PostedWhsReceiptHeader: Record "Posted Whse. Receipt Header";
        ValueEntry: Record "Value Entry";
        PurchaseILE: Record "Item Ledger Entry";

        LocationCode: Code[10];
        WarehouseNameHeader: Text;
        ReportRunDate: Text;

        SourceEntryNo: Integer;

        PurchaseRate: Decimal;
        PurchaseValue: Decimal;
        ImportRateUSD: Decimal;
        INRAccessibleValue: Decimal;
        CurrencyCode: Code[20];
        CurrenacyRate: Decimal;
        InsuranceAmount: Decimal;
        CustomDuty: Decimal;
        GstRatePercentage: Record "Gst Rate Percentage";
        ClearingForwarding: Decimal;
        ClearingAmount: Decimal;
        FreightAmount: Decimal;
        IGST: Decimal;
        LandedCost: Decimal;
        BCD: Decimal;
        OtherCharges: Decimal;
        SalesOrderNo: Code[20];
        CustomerName: Text;

        Shipmentmode: Code[50];
        FolioNo: Code[100];

        SpecialOrderQty: Decimal;
        SpecialSalesOrderNo: Code[20];
        SpecialCustomerName: Text;
        SpecialTrackingQty: Decimal; //TBC-1051
        GRNNo: Code[20];
        GRNDate: Date;
        GRNLineNo: Integer;

        VendorInvoiceNo: Code[35];
        PostingDate: Date;
        PoNo: Code[20];
        POOrderDate: Date;
        VendorOrderNo: Code[35];
        AssignedUserID: Text;

        AvailableQty: Decimal;
        //TBC-1047  --->
        TrackingQtyBase: Decimal;
        TrackingSalesOrderNo: Code[20];
        TrackingCustomerName: Text;
    //TBC-1047  <---
}


//Old COde Commented by HG 20/05/2026 ----->
// report 50032 "Inventory By Location"
// {
//     ApplicationArea = All;
//     Caption = 'Custom Inventory By Location';
//     UsageCategory = ReportsAndAnalysis;
//     ProcessingOnly = true;

//     dataset
//     {
//         dataitem("Item Ledger Entry"; "Item Ledger Entry")
//         {
//             DataItemTableView = sorting("Item No.", "Location Code")
//                                 where("Remaining Quantity" = filter(> 0));

//             trigger OnPreDataItem()
//             begin
//                 if LocationCode <> '' then
//                     SetRange("Location Code", LocationCode);

//                 MakeExcelDataHeader();
//             end;

//             trigger OnAfterGetRecord()
//             begin
//                 MakeExcelDataBody();
//             end;
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group(DateFilter)
//                 {
//                     Caption = 'Filters';

//                     field(LocationCode; LocationCode)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Location Code';
//                         TableRelation = Location.Code;
//                     }
//                 }
//             }
//         }
//     }

//     trigger OnPreReport()
//     begin
//         ExcelBuffer.DeleteAll();

//         if CompanyInfo.Get() then
//             CompanyInfo.CalcFields(Picture);
//     end;

//     trigger OnPostReport()
//     begin
//         CreateExcelBook();
//     end;


//     local procedure MakeExcelDataHeader()
//     begin
//         ExcelBuffer.NewRow();
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 1
//         ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 2
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 3
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 4
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn(CompanyInfo.Name, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 5 (center)

//         ExcelBuffer.NewRow();
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 1
//         ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 2
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 3
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 4
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         WarehouseNameHeader := '';
//         if LocationCode <> '' then
//             WarehouseNameHeader := 'Warehouse Name = ' + Format(LocationCode)
//         else
//             WarehouseNameHeader := 'Warehouse Name = All Warehouse';
//         ExcelBuffer.AddColumn(WarehouseNameHeader, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.NewRow();
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 1
//         ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 2
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 3
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 4
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ReportRunDate := 'Report Run Date ' + Format(Today);
//         ExcelBuffer.AddColumn(ReportRunDate, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.NewRow();
//         ExcelBuffer.NewRow();
//         ExcelBuffer.NewRow();

//         ExcelBuffer.AddColumn('Item No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Item Description', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Lot No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Remaining Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Import Rate/Value (USD)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Accessible Value in INR', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Insurance Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Custom Duty', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Clearing & Forwarding', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Freight Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('IGST', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Landed Cost ', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Shipment mode', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Folio No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Purchase Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Purchase Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Location Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Reserved Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('SO#', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Special Order Qty', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Sales Order No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Available Qty.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('GRN Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('GRN No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('GRN Line No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Vendor Order No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Vendor Invoice No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Vendor Invoice Posting Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Purchase Order No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Purchase Order Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//         ExcelBuffer.AddColumn('Assigned User ID', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
//     end;

//     local procedure MakeExcelDataBody()
//     begin
//         ClearAllVariables();

//         //----------------------------------------
//         // FIND ORIGINAL PURCHASE RECEIPT ENTRY
//         //----------------------------------------

//         SourceEntryNo := FindPurchaseReceiptEntry();

//         if SourceEntryNo = 0 then
//             CurrReport.Skip();

//         PurchaseILE.Get(SourceEntryNo);

//         //----------------------------------------
//         // ITEM DETAILS
//         //----------------------------------------

//         ExcelBuffer.NewRow();

//         ExcelBuffer.AddColumn("Item Ledger Entry"."Item No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         if RecItem.Get("Item Ledger Entry"."Item No.") then
//             ExcelBuffer.AddColumn(RecItem.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
//         else
//             ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn("Item Ledger Entry"."Lot No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn("Item Ledger Entry".Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

//         ExcelBuffer.AddColumn("Item Ledger Entry"."Remaining Quantity", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

//         //----------------------------------------
//         // PURCHASE RATE
//         //----------------------------------------

//         ValueEntry.Reset();
//         ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Purchase Invoice");
//         ValueEntry.SetRange("Item Ledger Entry No.", PurchaseILE."Entry No.");
//         ValueEntry.SetRange("Item No.", PurchaseILE."Item No.");
//         ValueEntry.SetFilter("Cost per Unit", '>%1', 0);
//         if LocationCode <> '' then
//             ValueEntry.SetRange("Location Code", LocationCode);
//         if ValueEntry.FindSet() then begin
//             repeat
//                 PurchaseRate += ValueEntry."Cost per Unit";
//             until ValueEntry.Next() = 0;
//         end;

//         //----------------------------------------
//         // PURCHASE RECEIPT HEADER
//         //----------------------------------------

//         if PurchRcptHeader.Get(PurchaseILE."Document No.") then
//             FolioNo := PurchRcptHeader."Folio No.";

//         //----------------------------------------
//         // PURCHASE INVOICE DETAILS
//         //----------------------------------------

//         ValueEntry.Reset();
//         ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Purchase Invoice");
//         ValueEntry.SetRange("Item Ledger Entry No.", PurchaseILE."Entry No.");
//         ValueEntry.SetRange("Item No.", PurchaseILE."Item No.");
//         if ValueEntry.FindFirst() then begin
//             PurchInvLine.Reset();
//             PurchInvLine.SetRange("Document No.", ValueEntry."Document No.");
//             PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
//             PurchInvLine.SetRange("No.", ValueEntry."Item No.");
//             PurchInvLine.SetRange("Line No.", ValueEntry."Document Line No.");
//             if PurchInvLine.FindFirst() then begin
//                 ImportRateUSD := PurchInvLine."Direct Unit Cost";

//                 if PurchInvHeader.Get(PurchInvLine."Document No.") then begin
//                     //Custom Duty --->
//                     GstRatePercentage.Reset();
//                     GstRatePercentage.SetRange("GST Group Code", PurchInvLine."GST Group Code");
//                     GstRatePercentage.SetRange("Location State Code", PurchInvHeader."Location State Code");
//                     GstRatePercentage.SetRange("From State", '');
//                     if GstRatePercentage.FindFirst() then
//                         BCD := GstRatePercentage."KFloodCess Percentage";
//                     //Custom Duty <---

//                     if (PurchInvHeader."Currency Code" <> '') and
//                        (PurchInvHeader."Currency Factor" <> 0)
//                     then begin
//                         INRAccessibleValue :=
//                             (PurchInvLine.Quantity * PurchInvLine."Direct Unit Cost") *
//                             (1 / PurchInvHeader."Currency Factor");
//                         InsuranceAmount := PurchInvLine."Insurance Amount" * (1 / PurchInvHeader."Currency Factor");
//                         OtherCharges := ROUND((PurchInvLine."Line Amount" + PurchInvLine."Freight Amount" + PurchInvLine."Insurance Amount") * BCD / 100, 0.01, '=');
//                         CustomDuty := ROUND(OtherCharges * (1 / PurchInvHeader."Currency Factor"), 0.01, '=');
//                         IGST := IGSTAmount(PurchInvLine);
//                     end else begin
//                         INRAccessibleValue := PurchInvLine.Quantity * PurchInvLine."Direct Unit Cost";
//                         InsuranceAmount := PurchInvLine."Insurance Amount";
//                         CustomDuty := Round((PurchInvLine."Line Amount" + PurchInvLine."Freight Amount" + PurchInvLine."Insurance Amount") * BCD / 100, 0.01, '=');
//                         IGST := IGSTAmount(PurchInvLine);
//                     end;
//                 end;
//             end;
//         end;

//         ////Clearing & Forwarding  and freight Amount Calculation --->
//         Clear(ClearingForwarding);
//         Clear(FreightAmount);
//         ValueEntry.Reset();
//         ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Purchase Invoice");
//         ValueEntry.SetRange("Item Ledger Entry No.", PurchaseILE."Entry No.");
//         ValueEntry.SetRange("Item No.", PurchaseILE."Item No.");
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
//                                 ((ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
//                                 * "Item Ledger Entry"."Remaining Quantity")
//                                 * (1 / PurchInvHeader."Currency Factor")
//                         else
//                             ClearingForwarding :=
//                                 (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
//                                 * "Item Ledger Entry"."Remaining Quantity";

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
//                                     * "Item Ledger Entry"."Remaining Quantity")
//                                     * (1 / PurchInvHeader."Currency Factor")
//                             else
//                                 FreightAmount :=
//                                     (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity")
//                                     * "Item Ledger Entry"."Remaining Quantity";

//                         end;
//                     end;
//             end;
//         end;

//         ////Clearing & Forwarding  and freight Amount  Calculation <----



//         //----------------------------------------
//         // ADD PURCHASE DATA
//         //----------------------------------------

//         ExcelBuffer.AddColumn(ImportRateUSD, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         ExcelBuffer.AddColumn(INRAccessibleValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         ExcelBuffer.AddColumn(InsuranceAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         //Cutom Duty
//         ExcelBuffer.AddColumn(CustomDuty, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         //Clearing & Forwarding
//         ExcelBuffer.AddColumn(ClearingAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         //Freight Amount
//         ExcelBuffer.AddColumn(FreightAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         // IGST
//         ExcelBuffer.AddColumn(IGST, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         //Landed Cost
//         LandedCost := ("Item Ledger Entry"."Remaining Quantity" * PurchaseRate) + InsuranceAmount + ClearingForwarding + FreightAmount;
//         ExcelBuffer.AddColumn(LandedCost, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);


//         //----------------------------------------
//         // SHIPMENT MODE
//         //----------------------------------------

//         PurchRcptLine.Reset();
//         PurchRcptLine.SetRange("Document No.", PurchaseILE."Document No.");
//         PurchRcptLine.SetRange("No.", PurchaseILE."Item No.");
//         if PurchRcptLine.FindFirst() then begin
//             PostedWhsReceiptHeader.Reset();
//             PostedWhsReceiptHeader.SetRange("No.", PurchRcptLine."Posted Warehouse Rec No");
//             if PostedWhsReceiptHeader.FindFirst() then
//                 Shipmentmode := PostedWhsReceiptHeader."Mode Of Shipment";
//         end;

//         ExcelBuffer.AddColumn(Shipmentmode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn(FolioNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         //----------------------------------------
//         // PURCHASE VALUE
//         //----------------------------------------

//         PurchaseValue := "Item Ledger Entry"."Remaining Quantity" * PurchaseRate;

//         ExcelBuffer.AddColumn(PurchaseValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         ExcelBuffer.AddColumn(PurchaseRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

//         //----------------------------------------
//         // LOCATION
//         //----------------------------------------

//         ExcelBuffer.AddColumn("Item Ledger Entry"."Location Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         //----------------------------------------
//         // RESERVED QTY
//         //----------------------------------------

//         "Item Ledger Entry".CalcFields("Reserved Quantity");

//         ExcelBuffer.AddColumn("Item Ledger Entry"."Reserved Quantity", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

//         //----------------------------------------
//         // SALES ORDER DETAILS
//         //----------------------------------------

//         if "Item Ledger Entry"."Reserved Quantity" <> 0 then begin
//             ReservationEntry.Reset();
//             ReservationEntry.SetCurrentKey("Item No.", "Location Code");
//             ReservationEntry.SetRange("Item No.", "Item Ledger Entry"."Item No.");
//             ReservationEntry.SetRange("Location Code", "Item Ledger Entry"."Location Code");
//             ReservationEntry.SetRange("Source Type", Database::"Sales Line");
//             if "Item Ledger Entry"."Lot No." <> '' then
//                 ReservationEntry.SetRange("Lot No.", "Item Ledger Entry"."Lot No.");
//             if ReservationEntry.FindFirst() then begin
//                 SalesOrderNo := ReservationEntry."Source ID";

//                 if SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo) then
//                     CustomerName := SalesHeader."Sell-to Customer Name";
//             end;
//         end;

//         ExcelBuffer.AddColumn(SalesOrderNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn(CustomerName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         //----------------------------------------
//         // SPECIAL ORDER
//         //----------------------------------------

//         PurchRcptLine.Reset();
//         PurchRcptLine.SetRange("Document No.", PurchaseILE."Document No.");
//         PurchRcptLine.SetRange("No.", PurchaseILE."Item No.");
//         if PurchRcptLine.FindFirst() then begin
//             if PurchLine.Get(
//                 PurchLine."Document Type"::Order,
//                 PurchRcptLine."Order No.",
//                 PurchRcptLine."Order Line No.")
//             then begin
//                 if PurchLine."Special Order" then begin
//                     SpecialOrderQty := PurchLine.Quantity;
//                     SpecialSalesOrderNo := PurchLine."Special Order Sales No.";
//                     if SalesHeader.Get(
//                         SalesHeader."Document Type"::Order,
//                         SpecialSalesOrderNo)
//                     then
//                         SpecialCustomerName := SalesHeader."Sell-to Customer Name";
//                 end;
//             end;
//         end;

//         ExcelBuffer.AddColumn(SpecialOrderQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

//         ExcelBuffer.AddColumn(SpecialSalesOrderNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn(SpecialCustomerName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         //----------------------------------------
//         // AVAILABLE QTY
//         //----------------------------------------

//         AvailableQty :=
//             "Item Ledger Entry"."Remaining Quantity"
//             - "Item Ledger Entry"."Reserved Quantity"
//             - SpecialOrderQty;

//         ExcelBuffer.AddColumn(AvailableQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

//         //----------------------------------------
//         // GRN DETAILS
//         //----------------------------------------

//         GRNNo := PurchaseILE."Document No.";
//         GRNDate := PurchaseILE."Posting Date";

//         PurchRcptLine.Reset();
//         PurchRcptLine.SetRange("Document No.", GRNNo);
//         PurchRcptLine.SetRange("No.", PurchaseILE."Item No.");
//         if PurchRcptLine.FindFirst() then
//             GRNLineNo := PurchRcptLine."Line No.";

//         ExcelBuffer.AddColumn(GRNDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

//         ExcelBuffer.AddColumn(GRNNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn(GRNLineNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

//         //----------------------------------------
//         // VENDOR DETAILS
//         //----------------------------------------

//         PurchInvLine.Reset();
//         PurchInvLine.SetRange("Receipt No.", PurchaseILE."Document No.");
//         if PurchInvLine.FindFirst() then begin
//             if PurchInvHeader.Get(PurchInvLine."Document No.") then begin
//                 VendorInvoiceNo := PurchInvHeader."Vendor Invoice No.";
//                 PostingDate := PurchInvHeader."Posting Date";
//             end;
//         end;

//         PurchRcptLine.Reset();
//         PurchRcptLine.SetRange("Document No.", PurchaseILE."Document No.");
//         if PurchRcptLine.FindFirst() then begin
//             PoNo := PurchRcptLine."Order No.";
//             if PurchHeader.Get(PurchHeader."Document Type"::Order, PoNo) then begin
//                 POOrderDate := PurchHeader."Order Date";
//                 VendorOrderNo := PurchHeader."Vendor Order No.";
//                 AssignedUserID := PurchHeader."Assigned User ID";
//             end else begin
//                 PurchHeaderArchive.Reset();
//                 PurchHeaderArchive.SetRange("Document Type", PurchHeaderArchive."Document Type"::Order);
//                 PurchHeaderArchive.SetRange("No.", PoNo);
//                 if PurchHeaderArchive.FindLast() then begin
//                     POOrderDate := PurchHeaderArchive."Order Date";
//                     AssignedUserID := PurchHeaderArchive."Assigned User ID";
//                 end;
//             end;
//         end;

//         ExcelBuffer.AddColumn(VendorOrderNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn(VendorInvoiceNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn(PostingDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn(PoNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

//         ExcelBuffer.AddColumn(POOrderDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);

//         ExcelBuffer.AddColumn(AssignedUserID, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
//     end;

//     local procedure FindPurchaseReceiptEntry(): Integer
//     begin

//         //----------------------------------------
//         // CURRENT ENTRY IS PURCHASE RECEIPT
//         //----------------------------------------

//         if "Item Ledger Entry"."Document Type" =
//            "Item Ledger Entry"."Document Type"::"Purchase Receipt"
//         then
//             exit("Item Ledger Entry"."Entry No.");

//         //----------------------------------------
//         // FIND ORIGINAL PURCHASE RECEIPT
//         //----------------------------------------

//         PurchaseILE.Reset();

//         PurchaseILE.SetCurrentKey(
//             "Item No.",
//             "Lot No.",
//             "Posting Date");

//         PurchaseILE.SetRange("Item No.",
//             "Item Ledger Entry"."Item No.");

//         PurchaseILE.SetRange("Lot No.",
//             "Item Ledger Entry"."Lot No.");

//         PurchaseILE.SetRange("Location Code",
//             "Item Ledger Entry"."Location Code");

//         PurchaseILE.SetRange("Document Type",
//             PurchaseILE."Document Type"::"Purchase Receipt");

//         PurchaseILE.SetFilter(Quantity, '>%1', 0);

//         if PurchaseILE.FindFirst() then
//             exit(PurchaseILE."Entry No.");

//         exit(0);
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

//     local procedure ClearAllVariables()
//     begin
//         Clear(SourceEntryNo);
//         Clear(PurchaseRate);
//         Clear(PurchaseValue);
//         Clear(ImportRateUSD);
//         Clear(INRAccessibleValue);
//         Clear(Shipmentmode);
//         Clear(FolioNo);
//         Clear(InsuranceAmount);
//         Clear(SalesOrderNo);
//         Clear(CustomerName);
//         Clear(SpecialOrderQty);
//         Clear(SpecialSalesOrderNo);
//         Clear(SpecialCustomerName);
//         Clear(GRNNo);
//         Clear(GRNDate);
//         Clear(GRNLineNo);
//         Clear(VendorInvoiceNo);
//         Clear(PostingDate);
//         Clear(PoNo);
//         Clear(POOrderDate);
//         Clear(AssignedUserID);
//         Clear(VendorOrderNo);
//         Clear(AvailableQty);
//         Clear(CustomDuty);
//         Clear(ClearingForwarding);
//         Clear(ClearingAmount);
//         Clear(FreightAmount);
//         Clear(IGST);
//         Clear(LandedCost);
//         Clear(BCD);
//         Clear(OtherCharges);

//     end;

//     local procedure CreateExcelBook()
//     begin
//         ExcelBuffer.CreateNewBook('Inventory By Location');
//         ExcelBuffer.WriteSheet('Inventory By Location', '', UserId);
//         ExcelBuffer.CloseBook();
//         ExcelBuffer.SetFriendlyFilename('Inventory By Location');
//         ExcelBuffer.OpenExcel();
//     end;

//     var
//         ExcelBuffer: Record "Excel Buffer" temporary;
//         CompanyInfo: Record "Company Information";
//         RecItem: Record Item;
//         ReservationEntry: Record "Reservation Entry";
//         SalesHeader: Record "Sales Header";
//         PurchInvLine: Record "Purch. Inv. Line";
//         PurchInvHeader: Record "Purch. Inv. Header";
//         PurchRcptLine: Record "Purch. Rcpt. Line";
//         PurchRcptHeader: Record "Purch. Rcpt. Header";
//         PurchHeader: Record "Purchase Header";
//         PurchHeaderArchive: Record "Purchase Header Archive";
//         PurchLine: Record "Purchase Line";
//         PostedWhsReceiptHeader: Record "Posted Whse. Receipt Header";
//         ValueEntry: Record "Value Entry";
//         PurchaseILE: Record "Item Ledger Entry";

//         LocationCode: Code[10];
//         WarehouseNameHeader: Text;
//         ReportRunDate: Text;

//         SourceEntryNo: Integer;

//         PurchaseRate: Decimal;
//         PurchaseValue: Decimal;
//         ImportRateUSD: Decimal;
//         INRAccessibleValue: Decimal;
//         InsuranceAmount: Decimal;

//         SalesOrderNo: Code[20];
//         CustomerName: Text;

//         Shipmentmode: Code[50];
//         FolioNo: Code[100];

//         SpecialOrderQty: Decimal;
//         SpecialSalesOrderNo: Code[20];
//         SpecialCustomerName: Text;

//         GRNNo: Code[20];
//         GRNDate: Date;
//         GRNLineNo: Integer;

//         VendorInvoiceNo: Code[35];
//         PostingDate: Date;
//         PoNo: Code[20];
//         POOrderDate: Date;
//         VendorOrderNo: Code[35];
//         AssignedUserID: Text;

//         AvailableQty: Decimal;
//         CustomDuty: Decimal;
//         GstRatePercentage: Record "Gst Rate Percentage";
//         ClearingForwarding: Decimal;
//         ClearingAmount: Decimal;
//         FreightAmount: Decimal;
//         IGST: Decimal;
//         LandedCost: Decimal;
//         BCD: Decimal;
//         OtherCharges: Decimal;

// }
//Old COde Commented by HG 20/05/2026 <-----




