report 50034 "Demand Planning"
{
    ApplicationArea = All;
    Caption = 'Demand Planning';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.") where(Type = const(Inventory)); //TBC-864

            trigger OnPreDataItem()
            begin
                ExcelBuffer.DeleteAll();
                CreateExcelHeader();
            end;

            trigger OnAfterGetRecord()
            begin
                CreateExcelBody();
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
                    Caption = 'Filters';
                    field(LocationCodeFilter; LocationCodeFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Location Code';
                        TableRelation = Location;
                        ToolTip = 'Specifies the location code to filter the report. This field is mandatory.';

                        trigger OnValidate()
                        begin
                            if LocationCodeFilter = '' then
                                Error('Location Code cannot be empty. Please enter a valid Location Code.');
                        end;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if LocationCodeFilter = '' then
            Error('Location Code cannot be empty. Please enter a valid Location Code.');

        if not CurrentLocation.Get(LocationCodeFilter) then
            Error('Location Code %1 does not exist.', LocationCodeFilter);
    end;

    trigger OnPostReport()
    begin
        CreateExcelBook();
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        CurrentLocation: Record Location;
        LocationCodeFilter: Code[10];

    local procedure CreateExcelBody()
    var
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesLineQty: Decimal;
        SalesLineShippedQty: Decimal;
        RemainingSalesLineQty: Decimal;
        PurchaseLineQty: Decimal;
        PurchaseLineReceivedQty: Decimal;
        RemainingPurchaseLineQty: Decimal;
        WarehouseReceiptQty: Decimal;
        WarehouseReceiptReceivedQty: Decimal;
        RemainingWarehouseReceiptQty: Decimal;
        ILERemaingQty: Decimal;
        MaterialToProcure: Decimal;
        MaterialToProcure2: Decimal;
    begin
        ExcelBuffer.NewRow();
        //Warehouse Name
        ExcelBuffer.AddColumn(LocationCodeFilter, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Item No.
        ExcelBuffer.AddColumn(Item."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Item Description
        ExcelBuffer.AddColumn(Item.Description + Item."Description 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Principal
        ExcelBuffer.AddColumn(Item.Principal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //MOQ
        ExcelBuffer.AddColumn(Item."Reorder Quantity", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // Quantity to ship on sales order lines
        SalesLineQty := 0;
        SalesLineShippedQty := 0;
        RemainingSalesLineQty := 0;
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", Item."No.");
        SalesLine.SetRange("Location Code", LocationCodeFilter);
        //SalesLine.SetFilter("Outstanding Quantity", '>%1', 0);
        if SalesLine.FindSet() then
            repeat
                RemainingSalesLineQty += SalesLine."Outstanding Quantity";
            until SalesLine.Next() = 0;

        //Spares SO Balance
        ExcelBuffer.AddColumn(RemainingSalesLineQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);


        // Quantity to receive on Purchase Order lines
        PurchaseLineQty := 0;
        PurchaseLineReceivedQty := 0;
        RemainingPurchaseLineQty := 0;

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", Item."No.");
        PurchaseLine.SetRange("Location Code", LocationCodeFilter);
        if PurchaseLine.FindSet() then
            repeat
                // Check if a warehouse receipt line already exists for this purchase line
                WarehouseReceiptLine.Reset();
                WarehouseReceiptLine.SetCurrentKey("Location Code", "Source Type", "Source Subtype", "Source No.", "Source Line No.");
                WarehouseReceiptLine.SetRange("Location Code", LocationCodeFilter);
                WarehouseReceiptLine.SetRange("Source Type", Database::"Purchase Line");
                WarehouseReceiptLine.SetRange("Source Subtype", PurchaseLine."Document Type".AsInteger());
                WarehouseReceiptLine.SetRange("Source No.", PurchaseLine."Document No.");
                WarehouseReceiptLine.SetRange("Source Line No.", PurchaseLine."Line No.");

                if not WarehouseReceiptLine.FindFirst() then
                    // No warehouse receipt prepared yet → still pending with vendor
                    RemainingPurchaseLineQty += PurchaseLine."Outstanding Quantity"
                else begin
                    // Warehouse receipt exists → only count qty NOT yet on any receipt
                    // i.e. Outstanding Quantity minus Qty. Outstanding on the receipt
                    WarehouseReceiptLine.CalcSums("Qty. Outstanding");
                    // If receipt doesn't cover the full outstanding qty, count the difference
                    if PurchaseLine."Outstanding Quantity" > WarehouseReceiptLine."Qty. Outstanding" then
                        RemainingPurchaseLineQty += PurchaseLine."Outstanding Quantity" - WarehouseReceiptLine."Qty. Outstanding";
                end;
            until PurchaseLine.Next() = 0;

        //Pending PO with vendor
        ExcelBuffer.AddColumn(RemainingPurchaseLineQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // Quantity to receive on Warehouse receipt lines
        WarehouseReceiptQty := 0;
        WarehouseReceiptReceivedQty := 0;
        RemainingWarehouseReceiptQty := 0;

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", Item."No.");
        PurchaseLine.SetRange("Location Code", LocationCodeFilter);
        PurchaseLine.SetFilter(Quantity, '<>%1', 0);
        if PurchaseLine.FindSet() then
            repeat
                WarehouseReceiptLine.Reset();
                WarehouseReceiptLine.SetCurrentKey("Location Code", "Source Type", "Source Subtype", "Source No.", "Source Line No.");
                WarehouseReceiptLine.SetRange("Location Code", LocationCodeFilter);
                WarehouseReceiptLine.SetRange("Source Type", Database::"Purchase Line");
                WarehouseReceiptLine.SetRange("Source Subtype", PurchaseLine."Document Type".AsInteger());
                WarehouseReceiptLine.SetRange("Source No.", PurchaseLine."Document No.");
                WarehouseReceiptLine.SetRange("Source Line No.", PurchaseLine."Line No.");
                if WarehouseReceiptLine.FindSet() then
                    repeat
                        WarehouseReceiptQty += WarehouseReceiptLine.Quantity;
                        WarehouseReceiptReceivedQty += WarehouseReceiptLine."Qty. Received";
                    until WarehouseReceiptLine.Next() = 0;
            until PurchaseLine.Next() = 0;

        RemainingWarehouseReceiptQty := WarehouseReceiptQty - WarehouseReceiptReceivedQty;

        //IN Transit inward
        ExcelBuffer.AddColumn(RemainingWarehouseReceiptQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);



        //OLD Code --->
        // // Quantity to receive on Purchase Order lines
        // PurchaseLineQty := 0;
        // PurchaseLineReceivedQty := 0;
        // RemainingPurchaseLineQty := 0;
        // PurchaseLine.Reset();
        // PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        // PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        // PurchaseLine.SetRange("No.", Item."No.");
        // PurchaseLine.SetRange("Location Code", LocationCodeFilter);
        // //PurchaseLine.SetFilter("Outstanding Quantity", '>%1', 0);
        // if PurchaseLine.FindSet() then
        //     repeat
        //         RemainingPurchaseLineQty += PurchaseLine."Outstanding Quantity";
        //     until PurchaseLine.Next() = 0;


        // ExcelBuffer.AddColumn(RemainingPurchaseLineQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        // // Quantity to receive on Warehouse receipt lines
        // WarehouseReceiptQty := 0;
        // WarehouseReceiptReceivedQty := 0;
        // RemainingWarehouseReceiptQty := 0;
        // PurchaseLine.Reset();
        // PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        // PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        // PurchaseLine.SetRange("No.", Item."No.");
        // PurchaseLine.SetRange("Location Code", LocationCodeFilter);
        // PurchaseLine.SetFilter(Quantity, '<>%1', 0);
        // if PurchaseLine.FindSet() then
        //     repeat
        //         WarehouseReceiptLine.Reset();
        //         WarehouseReceiptLine.SetCurrentKey("Location Code", "Source Type", "Source Subtype", "Source No.", "Source Line No.");
        //         WarehouseReceiptLine.SetRange("Location Code", LocationCodeFilter);
        //         WarehouseReceiptLine.SetRange("Source Type", Database::"Purchase Line");
        //         WarehouseReceiptLine.SetRange("Source Subtype", PurchaseLine."Document Type".AsInteger());
        //         WarehouseReceiptLine.SetRange("Source No.", PurchaseLine."Document No.");
        //         WarehouseReceiptLine.SetRange("Source Line No.", PurchaseLine."Line No.");
        //         if WarehouseReceiptLine.FindSet() then
        //             repeat
        //                 WarehouseReceiptQty += WarehouseReceiptLine.Quantity;
        //                 WarehouseReceiptReceivedQty += WarehouseReceiptLine."Qty. Received";
        //             until WarehouseReceiptLine.Next() = 0;
        //     until PurchaseLine.Next() = 0;
        // RemainingWarehouseReceiptQty := WarehouseReceiptQty - WarehouseReceiptReceivedQty;
        // ExcelBuffer.AddColumn(RemainingWarehouseReceiptQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        //OD Code <----


        // Stock In Hand from Item Ledger Entry
        ILERemaingQty := 0;
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", Item."No.");
        ItemLedgerEntry.SetRange("Location Code", LocationCodeFilter);
        ItemLedgerEntry.SetFilter("Remaining Quantity", '>%1', 0);
        if ItemLedgerEntry.FindSet() then
            repeat
                ILERemaingQty += ItemLedgerEntry."Remaining Quantity";
            until ItemLedgerEntry.Next() = 0;

        //Stock In Hand
        ExcelBuffer.AddColumn(ILERemaingQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        // Material to Procure
        Clear(MaterialToProcure);
        MaterialToProcure := Item."Reorder Quantity" + RemainingSalesLineQty - RemainingPurchaseLineQty - RemainingWarehouseReceiptQty - ILERemaingQty;
        ExcelBuffer.AddColumn(MaterialToProcure, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    end;

    local procedure CreateExcelHeader()
    begin
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Demand planning', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Warehouse Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Product Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Product Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Principle', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MOQ Level', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Spares SO Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Pending PO with vendor', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IN Transit inward', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Stock In Hand', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Material To Procure', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('Demand Planning');
        ExcelBuffer.WriteSheet('Demand Planning', '', '');
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Demand_Planning' + Format(DT2Date(CurrentDateTime), 0, '<Day,2>-<Month,2>-<Year4>') + '_' + Format(DT2Time(CurrentDateTime), 0, '<Hours24>:<Minutes,2>'));
        ExcelBuffer.OpenExcel();
    end;

    //Old Code -->
    // ApplicationArea = All;
    // Caption = 'Demand Planning';
    // UsageCategory = ReportsAndAnalysis;
    // ProcessingOnly = true;

    // dataset
    // {
    //     dataitem(Item; Item)
    //     {
    //         trigger OnPreDataItem()
    //         begin
    //             ExcelBuffer.DeleteAll();
    //             CreateExcelHeader();
    //         end;

    //         trigger OnAfterGetRecord()
    //         begin
    //             CreateExcelBody();
    //         end;
    //     }
    // }

    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(Filters)
    //             {
    //                 Caption = 'Filters';
    //                 field(LocationCodeFilter; LocationCodeFilter)
    //                 {
    //                     ApplicationArea = All;
    //                     Caption = 'Location Code';
    //                     TableRelation = Location;
    //                     ToolTip = 'Specifies the location code to filter the report. This field is mandatory.';

    //                     trigger OnValidate()
    //                     begin
    //                         if LocationCodeFilter = '' then
    //                             Error('Location Code cannot be empty. Please enter a valid Location Code.');
    //                     end;
    //                 }
    //             }
    //         }
    //     }
    // }

    // trigger OnPreReport()
    // begin
    //     if LocationCodeFilter = '' then
    //         Error('Location Code cannot be empty. Please enter a valid Location Code.');

    //     if not CurrentLocation.Get(LocationCodeFilter) then
    //         Error('Location Code %1 does not exist.', LocationCodeFilter);
    // end;

    // trigger OnPostReport()
    // begin
    //     CreateExcelBook();
    // end;

    // var
    //     ExcelBuffer: Record "Excel Buffer" temporary;
    //     CurrentLocation: Record Location;
    //     LocationCodeFilter: Code[10];

    // local procedure CreateExcelBody()
    // var
    //     SalesLine: Record "Sales Line";
    //     PurchaseLine: Record "Purchase Line";
    //     WarehouseReceiptLine: Record "Warehouse Receipt Line";
    //     ItemLedgerEntry: Record "Item Ledger Entry";
    //     SalesLineQty: Decimal;
    //     SalesLineShippedQty: Decimal;
    //     RemainingSalesLineQty: Decimal;
    //     PurchaseLineQty: Decimal;
    //     PurchaseLineReceivedQty: Decimal;
    //     RemainingPurchaseLineQty: Decimal;
    //     WarehouseReceiptQty: Decimal;
    //     WarehouseReceiptReceivedQty: Decimal;
    //     RemainingWarehouseReceiptQty: Decimal;
    //     ILERemaingQty: Decimal;
    //     MaterialToProcure: Decimal;
    //     MaterialToProcure2: Decimal;
    // begin
    //     ExcelBuffer.NewRow();
    //     ExcelBuffer.AddColumn(LocationCodeFilter, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn(Item."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn(Item.Description + Item."Description 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn(Item.Principal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     //ExcelBuffer.AddColumn(Item."Minimum Order Quantity", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    //     ExcelBuffer.AddColumn(Item."Reorder Quantity", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

    //     // Quantity to ship on sales order lines
    //     SalesLineQty := 0;
    //     SalesLineShippedQty := 0;
    //     RemainingSalesLineQty := 0;
    //     SalesLine.Reset();
    //     SalesLine.SetCurrentKey("Document Type", Type, "No.", "Location Code", Quantity);
    //     SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
    //     SalesLine.SetRange(Type, SalesLine.Type::Item);
    //     SalesLine.SetRange("No.", Item."No.");
    //     SalesLine.SetRange("Location Code", LocationCodeFilter);
    //     SalesLine.SetFilter(Quantity, '<>%1', 0);
    //     if SalesLine.FindSet() then
    //         repeat
    //             SalesLineQty += SalesLine.Quantity;
    //             SalesLineShippedQty += SalesLine."Qty. Shipped (Base)";
    //         until SalesLine.Next() = 0;
    //     RemainingSalesLineQty := SalesLineQty - SalesLineShippedQty;
    //     ExcelBuffer.AddColumn(RemainingSalesLineQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    //     // Quantity to receive on Purchase Order lines
    //     PurchaseLineQty := 0;
    //     PurchaseLineReceivedQty := 0;
    //     RemainingPurchaseLineQty := 0;
    //     PurchaseLine.Reset();
    //     PurchaseLine.SetCurrentKey("Document Type", Type, "No.", "Location Code", Quantity);
    //     PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
    //     PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
    //     PurchaseLine.SetRange("No.", Item."No.");
    //     PurchaseLine.SetRange("Location Code", LocationCodeFilter);
    //     PurchaseLine.SetFilter(Quantity, '<>%1', 0);
    //     if PurchaseLine.FindSet() then
    //         repeat
    //             PurchaseLineQty += PurchaseLine.Quantity;
    //             PurchaseLineReceivedQty += PurchaseLine."Qty. Received (Base)";
    //         until PurchaseLine.Next() = 0;
    //     RemainingPurchaseLineQty := PurchaseLineQty - PurchaseLineReceivedQty;
    //     ExcelBuffer.AddColumn(RemainingPurchaseLineQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    //     // Quantity to receive on Warehouse receipt lines
    //     WarehouseReceiptQty := 0;
    //     WarehouseReceiptReceivedQty := 0;
    //     RemainingWarehouseReceiptQty := 0;
    //     PurchaseLine.Reset();
    //     PurchaseLine.SetCurrentKey("Document Type", Type, "No.", "Location Code", Quantity);
    //     PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
    //     PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
    //     PurchaseLine.SetRange("No.", Item."No.");
    //     PurchaseLine.SetRange("Location Code", LocationCodeFilter);
    //     PurchaseLine.SetFilter(Quantity, '<>%1', 0);
    //     if PurchaseLine.FindSet() then
    //         repeat
    //             WarehouseReceiptLine.Reset();
    //             WarehouseReceiptLine.SetCurrentKey("Location Code", "Source Type", "Source Subtype", "Source No.", "Source Line No.");
    //             WarehouseReceiptLine.SetRange("Location Code", LocationCodeFilter);
    //             WarehouseReceiptLine.SetRange("Source Type", Database::"Purchase Line");
    //             WarehouseReceiptLine.SetRange("Source Subtype", PurchaseLine."Document Type".AsInteger());
    //             WarehouseReceiptLine.SetRange("Source No.", PurchaseLine."Document No.");
    //             WarehouseReceiptLine.SetRange("Source Line No.", PurchaseLine."Line No.");
    //             if WarehouseReceiptLine.FindSet() then
    //                 repeat
    //                     WarehouseReceiptQty += WarehouseReceiptLine.Quantity;
    //                     WarehouseReceiptReceivedQty += WarehouseReceiptLine."Qty. Received";
    //                 until WarehouseReceiptLine.Next() = 0;
    //         until PurchaseLine.Next() = 0;
    //     RemainingWarehouseReceiptQty := WarehouseReceiptQty - WarehouseReceiptReceivedQty;
    //     ExcelBuffer.AddColumn(RemainingWarehouseReceiptQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    //     // Stock In Hand from Item Ledger Entry
    //     ILERemaingQty := 0;
    //     ItemLedgerEntry.Reset();
    //     ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code");
    //     ItemLedgerEntry.SetRange("Item No.", Item."No.");
    //     ItemLedgerEntry.SetRange("Location Code", LocationCodeFilter);
    //     if ItemLedgerEntry.FindSet() then
    //         repeat
    //             ILERemaingQty += ItemLedgerEntry."Remaining Quantity";
    //         until ItemLedgerEntry.Next() = 0;
    //     ExcelBuffer.AddColumn(ILERemaingQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    //     // Material to Procure
    //     MaterialToProcure := (Item."Minimum Order Quantity" + RemainingSalesLineQty) - (RemainingPurchaseLineQty + ILERemaingQty);
    //     ExcelBuffer.AddColumn(MaterialToProcure, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    //     // Material To Procure 2
    //     MaterialToProcure2 := (Item."Minimum Order Quantity" - RemainingPurchaseLineQty - ILERemaingQty) + (RemainingSalesLineQty - RemainingWarehouseReceiptQty);
    //     ExcelBuffer.AddColumn(MaterialToProcure2, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    // end;

    // local procedure CreateExcelHeader()
    // begin
    //     ExcelBuffer.NewRow();
    //     ExcelBuffer.AddColumn('Demand planning', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.NewRow();
    //     ExcelBuffer.AddColumn('Warehouse Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Product Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Product Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Principle', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('MOQ Level', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Spares SO Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Pending PO with vendor', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('IN Transit inward', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Stock In Hand', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Material To Procure', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Material To Procure 2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    // end;

    // local procedure CreateExcelBook()
    // begin
    //     ExcelBuffer.CreateNewBook('Demand Planning');
    //     ExcelBuffer.WriteSheet('Demand Planning', '', '');
    //     ExcelBuffer.CloseBook();
    //     ExcelBuffer.SetFriendlyFilename('Demand_Planning' + Format(DT2Date(CurrentDateTime), 0, '<Day,2>-<Month,2>-<Year4>') + '_' + Format(DT2Time(CurrentDateTime), 0, '<Hours24>:<Minutes,2>'));
    //     ExcelBuffer.OpenExcel();
    // end;
    //Old COde <--
}
