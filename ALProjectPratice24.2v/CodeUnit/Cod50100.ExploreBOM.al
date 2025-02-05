// codeunit 50100 ExploreBOM
// {
//     // [EventSubscriber(ObjectType::Page, page::"Sales Order Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
//     // procedure ExploreBOM(var Rec: Record "Sales Line")
//     // begin
//     //     if Rec."Prepmt. Amt. Inv." <> 0 then
//     //         Error(Text001);
//     //     CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
//     //     DocumentTotals.SalesDocTotalsNotUpToDate();
//     // end;
//     //     [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
//     //     procedure ExploreBOM(var SalesLine: Record "Sales Line")
//     //     begin
//     //         if SalesLine."Prepmt. Amt. Inv." <> 0 then
//     //             Error(Text001);
//     //         CODEUNIT.Run(CODEUNIT::"SalesExploreBOM", SalesLine);
//     //         DocumentTotals.SalesDocTotalsNotUpToDate();
//     //     end;
//     //     // [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterAddItem', '', false, false)]
//     //     // procedure ExploreBOM(LastSalesLine: Record "Sales Line")
//     //     // var
//     //     //     Item: Record Item;
//     //     // begin
//     //     //     // // if Rec."Prepmt. Amt. Inv." <> 0 then
//     //     //     // //     Error(Text001);
//     //     //     // item.SetRange("No.", Rec."No.");
//     //     //     // if Item.FindSet() then begin
//     //     //     //     item.CalcFields("Assembly BOM");
//     //     //     //     if Item."Assembly BOM" then
//     //     //     //         CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
//     //     //     //     // DocumentTotals.SalesDocTotalsNotUpToDate();
//     //     //     // end;
//     //     //     CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", LastSalesLine);
//     //     //     DocumentTotals.SalesDocTotalsNotUpToDate();
//     //     // end;
//     //     // [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
//     //     // procedure ExploreBOM(var SalesLine: Record "Sales Line")
//     //     // begin
//     //     //     // Ensure the Sales Line is inserted or modified to get a valid Line No.
//     //     //     if SalesLine."Line No." = 0 then begin
//     //     //         SalesLine."Line No." := GetNextLineNo(SalesLine);
//     //     //         SalesLine.Insert(TRUE); // Save the changes
//     //     //     end;

//     //     //     if SalesLine."Prepmt. Amt. Inv." <> 0 then
//     //     //         Error(Text001);

//     //     //     CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", SalesLine);
//     //     //     DocumentTotals.SalesDocTotalsNotUpToDate();
//     //     // end;

//     //     // procedure GetNextLineNo(SalesLine: Record "Sales Line"): Integer
//     //     // var
//     //     //     MaxLineNo: Integer;
//     //     //     TempSalesLine: Record "Sales Line";
//     //     // begin
//     //     //     MaxLineNo := 0;
//     //     //     TempSalesLine.SetRange("Document Type", SalesLine."Document Type");
//     //     //     TempSalesLine.SetRange("Document No.", SalesLine."Document No.");
//     //     //     if TempSalesLine.FindLast then
//     //     //         MaxLineNo := TempSalesLine."Line No.";

//     //     //     exit(MaxLineNo + 10000); // Adjust increment value as needed
//     //     // end;

//     //     // var
//     //     //     SalesHeader: Record "Sales Header";
//     //     //     // SalesLine: Record "Sales Line";
//     //     //     FromBOMComp: Record "BOM Component";
//     //     //     DocumentTotals: Codeunit "Document Totals";
//     //     //     Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';

//     //     // [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
//     //     // procedure ExplodeBOM(Var SalesLine: Record "Sales Line")
//     //     // begin
//     //     //     FromBOMComp.Reset();
//     //     //     FromBOMComp.SetRange("Parent Item No.", SalesLine."No.");
//     //     //     IF FromBOMComp.Count > 0 then
//     //     //         IF CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", SalesLine) then
//     //     //             DocumentTotals.SalesDocTotalsNotUpToDate();
//     //     // end;
//     //     // [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
//     //     // procedure ExploreBOM(var SalesLine: Record "Sales Line")
//     //     // var
//     //     //     TempSalesLine: Record "Sales Line";
//     //     //     MaxLineNo: Integer;
//     //     // begin
//     //     //     // Ensure the Sales Line has a valid Line No.
//     //     //     if SalesLine."Line No." = 0 then begin
//     //     //         // Find the next available line number
//     //     //         TempSalesLine.SetRange("Document Type", SalesLine."Document Type");
//     //     //         TempSalesLine.SetRange("Document No.", SalesLine."Document No.");
//     //     //         if TempSalesLine.FindLast then
//     //     //             MaxLineNo := TempSalesLine."Line No."
//     //     //         else
//     //     //             MaxLineNo := 0;

//     //     //         SalesLine."Line No." := MaxLineNo + 10000; // Adjust increment value as needed
//     //     //         SalesLine.Insert(); // Insert the new Sales Line record
//     //     //     end;

//     //     //     if SalesLine."Prepmt. Amt. Inv." <> 0 then
//     //     //         Error(Text001);

//     //     //     CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", SalesLine);
//     //     //     DocumentTotals.SalesDocTotalsNotUpToDate();
//     //     // end;




//     // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignItemValues', '', true, true)]
//     // local procedure ExplodeBOM(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
//     // var
//     //     BOMComponent: Record "BOM Component";
//     //     NewSalesLine: Record "Sales Line";
//     //     MaxLineNo: Integer;
//     //     Item: Record Item;
//     //     SalesOrderPage:Page "Sales Order Subform";
//     // begin
//     //     if SalesLine."Document Type" <> SalesLine."Document Type"::Order then
//     //         exit;

//     //     if SalesLine."No." <> '' then begin
//     //         if SalesLine.Type = SalesLine.Type::Item then begin
//     //             if IsItemBOM(SalesLine."No.") then begin
//     //                 if NewSalesLine.FindLast() then
//     //                     MaxLineNo := NewSalesLine."Line No."
//     //                 else
//     //                     MaxLineNo := SalesLine."Line No.";
//     //                 SalesLine.Type := SalesLine.Type::" ";
//     //                 SalesLine.Description := 'Exploding BOM: ' + SalesLine.Description;
//     //                 SalesLine.Quantity := 1;
//     //                 SalesLine.Insert(true);
//     //                 BOMComponent.SetRange("Parent Item No.", SalesLine."No.");
//     //                 if BOMComponent.FindSet() then begin
//     //                     repeat
//     //                         MaxLineNo := MaxLineNo + 10000;
//     //                         NewSalesLine.Init();
//     //                         NewSalesLine.TransferFields(SalesLine);
//     //                         NewSalesLine."Line No." := MaxLineNo;
//     //                         NewSalesLine.Type := NewSalesLine.Type::Item;
//     //                         NewSalesLine."No." := BOMComponent."No.";
//     //                         NewSalesLine.Description := BOMComponent.Description;
//     //                         NewSalesLine.Quantity := BOMComponent."Quantity per" * SalesLine.Quantity;
//     //                         NewSalesLine."Document Type" := SalesLine."Document Type";
//     //                         NewSalesLine."Document No." := SalesLine."Document No.";
//     //                         NewSalesLine."Unit Price" := GetItemUnitPrice(BOMComponent."No.");
//     //                         NewSalesLine."Line Amount" := NewSalesLine.Quantity * NewSalesLine."Unit Price";
//     //                         NewSalesLine.Insert();
//     //                     until BOMComponent.Next() = 0;
//     //                 end;
//     //                 SalesLine."Location Code" := '';
//     //                 SalesLine."Unit of Measure Code" := '';
//     //                 SalesLine.Modify(true);
//     //             end;
//     //         end;
//     //     end;
//     // end;

//     // local procedure IsItemBOM(ItemNo: Code[20]): Boolean
//     // begin
//     //     Item.Get(ItemNo);
//     //     Item.CalcFields("Assembly BOM");
//     //     exit(Item."Assembly BOM" = true);
//     // end;

//     // local procedure GetItemUnitPrice(ItemNo: Code[20]): Decimal
//     // begin
//     //     if Item.Get(ItemNo) then
//     //         exit(Item."Unit Price")
//     //     else
//     //         exit(0);
//     // end;
//     // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount Amount', false, false)]
//     // local procedure OnAfterValidateEventDisc(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
//     // var
//     //     Item: Record Item;
//     //     TotalUnitCost: Decimal;
//     //     SellingPrice: Decimal;
//     //     TotalPrice: Decimal;
//     //     Margin: Decimal;
//     //     SalesHeader: Record "Sales Header";
//     //     LineUpdate: Decimal;
//     // begin
//     //     CalculateTotalLineAmountForOrder(Rec);
//     //     CalculateTotalUnitCost(Rec);
//     //     if Item.Get(Rec."No.") and (Rec.Quantity <> 0) then begin
//     //         IF Rec."No." = xRec."No." then begin
//     //             TotalPrice := Rec."Unit Price" * Rec.Quantity;
//     //             TotalUnitCost := Rec."Unit Cost" * Rec.Quantity;
//     //             if Rec."Unit Cost" <> 0 then begin
//     //                 SellingPrice := Rec."Line Amount" - TotalUnitCost;
//     //                 Margin := (SellingPrice / TotalPrice) * 100;
//     //             end else
//     //                 Margin := 0;
//     //             Rec."Item Margins" := Round(Margin, 0.01);
//     //         end;
//     //     end
//     //     else
//     //         Rec."Item Margins" := 0;
//     //     IF Rec."Line Discount Amount" <> xRec."Line Discount Amount" then
//     //         IF SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
//     //             LineUpdate := xRec."Amount Including VAT" - Rec."Amount Including VAT";
//     //             SalesHeader.TotalUnitcost := SalesHeader.TotalUnitcost - LineUpdate;
//     //             SalesHeader."Order Margin" := 0;
//     //             IF (SalesHeader.TotalUnitcost <> 0) and (SalesHeader.TotalAmount <> 0) then begin
//     //                 SellingPrice := SalesHeader.TotalUnitcost - SalesHeader.TotalAmount;
//     //                 Margin := (SellingPrice / SalesHeader.TotalUnitPricetoSell) * 100;
//     //                 SalesHeader."Order Margin" := Round(Margin, 0.01);
//     //             end else
//     //                 SalesHeader."Order Margin" := 0;
//     //             SalesHeader.Modify();
//     //         end;
//     // end;

//     // procedure CalculateTotalLineAmountForOrder(var salesline: Record "Sales Line")
//     // var
//     //     SalesLineAmonts: Record "Sales Line";
//     //     SalesHeader: Record "Sales Header";
//     //     TotalAmount: Decimal;
//     // begin
//     //     TotalAmount := 0;
//     //     SalesLineAmonts.SetRange("Document No.", SalesLine."Document No.");
//     //     SalesLineAmonts.SetRange("Document Type", SalesLine."Document Type");
//     //     if SalesLineAmonts.FindSet() then
//     //         repeat
//     //             TotalAmount := TotalAmount + SalesLineAmonts."Amount Including VAT";
//     //         until SalesLineAmonts.Next() = 0;

//     //     IF SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
//     //         SalesHeader.TotalUnitcost := TotalAmount;
//     //         SalesHeader.Modify();
//     //     end;
//     // end;

//     // procedure CalculateTotalUnitCost(var salesline: Record "Sales Line")
//     // var
//     //     SalesLineAmonts: Record "Sales Line";
//     //     SalesHeader: Record "Sales Header";
//     //     TotalAmount: Decimal;
//     //     UnitCost: Decimal;
//     //     UnitPrice: Decimal;
//     //     TotalUnitPrice: Decimal;
//     // begin
//     //     TotalAmount := 0;
//     //     SalesLineAmonts.SetRange("Document No.", SalesLine."Document No.");
//     //     SalesLineAmonts.SetRange("Document Type", SalesLine."Document Type");
//     //     if SalesLineAmonts.FindSet() then
//     //         repeat
//     //             UnitCost := SalesLineAmonts."Unit Cost" * SalesLineAmonts.Quantity;
//     //             UnitPrice := SalesLineAmonts."Unit Price" * SalesLineAmonts.Quantity;
//     //             TotalAmount := TotalAmount + UnitCost;
//     //             TotalUnitPrice := TotalUnitPrice + UnitPrice;
//     //         until SalesLineAmonts.Next() = 0;

//     //     IF SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
//     //         SalesHeader.TotalAmount := TotalAmount;
//     //         SalesHeader.TotalUnitPricetoSell := TotalUnitPrice;
//     //         SalesHeader.Modify();
//     //     end;
//     // end;

//     // var
//     //     Item: Record Item;
//     //     DocumentTotals: Codeunit "Document Totals";
//     //     Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
//     //     SalesHeader: Record "Sales Header";
//     //     SalesOrder: Page "Sales Order Subform";
//     //     SalesLine: Record "Sales Line";
//     //     FromBOMComp: Record "BOM Component";



//     // [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
//     // local procedure OnAfterValidateEventDisc(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
//     // var
//     //     Item: Record Item;
//     //     TotalUnitCost: Decimal;
//     //     SellingPrice: Decimal;
//     //     TotalPrice: Decimal;
//     //     Margin: Decimal;
//     //     SalesHeader: Record "Sales Header";
//     //     LineUpdate: Decimal;
//     // begin
//     //     MyProcedure(Rec, xRec);
//     // end;

//     // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', false, false)]
//     // local procedure OnAfterModifyEventsalesline(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
//     // var
//     //     SalesHeader: Record "Sales Header";
//     //     Margin: Decimal;
//     //     SellingPrice: Decimal;
//     // begin
//     //     CalculateTotalLineAmountForOrder(Rec);
//     //     CalculateTotalUnitCost(Rec);
//     //     IF SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
//     //         IF (SalesHeader.TotalUnitcost <> 0) and (SalesHeader.TotalAmount <> 0) then begin
//     //             SellingPrice := SalesHeader.TotalUnitcost - SalesHeader.TotalAmount;
//     //             Margin := (SellingPrice / SalesHeader.TotalUnitPricetoSell) * 100;
//     //             SalesHeader."Order Margin" := Round(Margin, 0.01);
//     //         end else
//     //             SalesHeader."Order Margin" := 0;
//     //     SalesHeader.Modify();
//     //     MyProcedure(Rec, xRec);
//     // end;

//     // procedure MyProcedure(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
//     // var
//     //     Item: Record Item;
//     //     TotalUnitCost: Decimal;
//     //     SellingPrice: Decimal;
//     //     TotalPrice: Decimal;
//     //     Margin: Decimal;
//     //     SalesHeader: Record "Sales Header";
//     //     LineUpdate: Decimal;
//     // begin
//     //     CalculateTotalLineAmountForOrder(Rec);
//     //     CalculateTotalUnitCost(Rec);
//     //     if Item.Get(Rec."No.") and (Rec.Quantity <> 0) then begin
//     //         IF Rec."No." = xRec."No." then begin
//     //             TotalPrice := Rec."Unit Price" * Rec.Quantity;
//     //             TotalUnitCost := Rec."Unit Cost" * Rec.Quantity;
//     //             if Rec."Unit Cost" <> 0 then begin
//     //                 SellingPrice := Rec."Line Amount" - TotalUnitCost;
//     //                 Margin := (SellingPrice / TotalPrice) * 100;
//     //             end else
//     //                 Margin := 0;
//     //             Rec."Item Margins" := Round(Margin, 0.01);
//     //         end;
//     //     end
//     //     else
//     //         Rec."Item Margins" := 0;
//     //     IF Rec."Line Discount Amount" <> xRec."Line Discount Amount" then
//     //         IF SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
//     //             LineUpdate := xRec."Amount Including VAT" - Rec."Amount Including VAT";
//     //             SalesHeader.TotalUnitcost := SalesHeader.TotalUnitcost - LineUpdate;
//     //             SalesHeader."Order Margin" := 0;
//     //             IF (SalesHeader.TotalUnitcost <> 0) and (SalesHeader.TotalAmount <> 0) then begin
//     //                 SellingPrice := SalesHeader.TotalUnitcost - SalesHeader.TotalAmount;
//     //                 Margin := (SellingPrice / SalesHeader.TotalUnitPricetoSell) * 100;
//     //                 SalesHeader."Order Margin" := Round(Margin, 0.01);
//     //             end else
//     //                 SalesHeader."Order Margin" := 0;
//     //             SalesHeader.Modify();
//     //         end;
//     // end;
// }

