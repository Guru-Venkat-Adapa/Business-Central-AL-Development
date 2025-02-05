// codeunit 50201 ExplodeBOMandMargin
// {

//     //////////////////////////////////////////           Order/Quote Margin and Item Margin               /////////////////////////////////////////////////////
//     [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
//     local procedure OnAfterValidateQuantity(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
//     var
//         SalesHeader: Record "Sales Header";
//     begin
//         SalesHeader.SetRange("Document Type", Rec."Document Type");
//         SalesHeader.SetRange("No.", Rec."Document No.");
//         If SalesHeader.FindSet() then
//             BundleMargintintoSalesLine(SalesHeader);
//     end;

//     [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
//     local procedure DeleteOrderMargin(var Rec: Record "Sales Line")
//     begin
//         OrderMargin(Rec);
//     end;

//     [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
//     local procedure OnAfterValidateDiscPercentage(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
//     begin
//         IF Rec."Document Type" <> Rec."Document Type"::Invoice then begin
//             ItemMargin(Rec, xRec);
//             OrderMargin(Rec);
//             // BundleMargin(Rec);
//         end;
//     end;

//     [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount Amount', false, false)]
//     local procedure OnAfterValidateDiscAmount(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
//     begin
//         IF Rec."Document Type" <> Rec."Document Type"::Invoice then begin
//             ItemMargin(Rec, xRec);
//             OrderMargin(Rec);
//             // BundleMargin(Rec);
//         end;
//     end;

//     procedure ItemMargin(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
//     var
//         Item: Record Item;
//         TotalUnitCost: Decimal;
//         SellingPrice: Decimal;
//         Margin: Decimal;
//     begin
//         IF Rec."No." = xRec."No." then begin
//             if Item.Get(Rec."No.") and (Rec.Quantity <> 0) then begin
//                 TotalUnitCost := Rec."Unit Cost" * Rec.Quantity;
//                 SellingPrice := Rec.Amount - TotalUnitCost;
//                 Margin := (SellingPrice / Rec.Amount) * 100;
//                 Rec."Item Margins" := Round(Margin, 0.01);
//             end
//             else
//                 Rec."Item Margins" := 0;
//         end
//         else begin
//             Clear(Rec.Quantity);
//             Rec."Item Margins" := 0;
//         end;
//     end;

//     procedure OrderMargin(var Rec: Record "Sales Line")
//     var
//         SalesHeader: Record "Sales Header";
//         Margin: Decimal;
//         SellingPrice: Decimal;
//     begin

//         GetTotalInSalesHeader(rec);
//         IF SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
//             IF (SalesHeader.TotalUnitcost <> 0) and (SalesHeader.TotalAmount <> 0) then begin
//                 SellingPrice := SalesHeader.TotalAmount - SalesHeader.TotalUnitCost;
//                 Margin := (SellingPrice / SalesHeader.TotalAmount) * 100;
//                 SalesHeader."Order Margin" := Round(Margin, 0.01);
//             end else
//                 SalesHeader."Order Margin" := 0;
//             SalesHeader.Modify();
//         end;
//     end;

//     procedure GetTotalInSalesHeader(var salesline: Record "Sales Line")
//     var
//         SalesLineAmonts: Record "Sales Line";
//         SalesHeader: Record "Sales Header";
//         TotalAmount: Decimal;
//         TotalUnitCost: Decimal;
//         UnitCostQty: Decimal;
//         SalesLineUpdateAmount: Decimal;
//         SalesLineUpdateUnitPrice: Decimal;
//         XTotalAmount: Decimal;
//         XtotalUnitCost: Decimal;
//     begin
//         SalesLineAmonts.SetRange("Document No.", SalesLine."Document No.");
//         SalesLineAmonts.SetRange("Document Type", SalesLine."Document Type");
//         if SalesLineAmonts.FindSet() then
//             repeat
//                 IF SalesLineAmonts.Quantity <> 0 then begin
//                     SalesLineUpdateAmount := salesline.Amount;
//                     SalesLineUpdateUnitPrice := salesline."Unit Cost" * salesline.Quantity;
//                     IF SalesLineAmonts."Line No." <> salesline."Line No." then begin
//                         UnitCostQty := SalesLineAmonts."Unit Cost" * SalesLineAmonts.Quantity;
//                         XtotalUnitCost := XtotalUnitCost + UnitCostQty;
//                         XTotalAmount := XTotalAmount + SalesLineAmonts.Amount;
//                     end;
//                 end;
//             until SalesLineAmonts.Next() = 0;
//         TotalUnitCost := XtotalUnitCost + SalesLineUpdateUnitPrice;
//         TotalAmount := XTotalAmount + SalesLineUpdateAmount;

//         IF SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
//             SalesHeader.TotalUnitCost := TotalUnitCost;
//             SalesHeader.TotalAmount := TotalAmount;
//             SalesHeader.Modify();
//         end;
//     end;

//     ///////////////////////////////////////            Explode BOM for Sales Quote           /////////////////////////////////
//     [EventSubscriber(ObjectType::Page, Page::"Sales Quote Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
//     local procedure OnAfterValidateEventBOM(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
//     var
//         Item: Record Item;
//         SalesHeader: Record "Sales Header";
//     begin
//         IF Item.Get(Rec."No.") THEN;
//         Item.CalcFields("Assembly BOM");
//         IF (Rec.Quantity <> 0) and (Item."Assembly BOM") then
//             IF GuiAllowed then begin
//                 if Rec."Prepmt. Amt. Inv." <> 0 then
//                     Error(Text001);
//                 CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
//                 DocumentTotals.SalesDocTotalsNotUpToDate();
//             end;
//         SalesHeader.SetRange("Document Type", Rec."Document Type");
//         SalesHeader.SetRange("No.", Rec."Document No.");
//         If SalesHeader.FindSet() then
//             BundleMargintintoSalesLine(SalesHeader);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Explode BOM", 'OnInsertOfExplodedBOMLineToSalesLine', '', false, false)]
//     local procedure OnInsertOfExplodedBOMLineToSalesLine(BOMComponent: Record "BOM Component"; SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line")
//     begin
//         ToSalesLine.Validate("Line Discount %", BOMComponent."Discount %");
//     end;

//     procedure BundleMargin(var Rec: Record "Sales Line")
//     var
//         SalesHeader: Record "Sales Header";
//         SellingPrice: Decimal;
//         Margin: Decimal;
//     begin
//         GetBOMTotals(Rec);
//         IF (Rec.Type = ' ') and (Rec."BOM Item No." <> '') then begin
//             SalesHeader.get(Rec."Document Type", Rec."Document No.");
//             SellingPrice := SalesHeader.TotalBOMAmount - SalesHeader.TotalUnitCostBOMItem;
//             Margin := (SellingPrice / SalesHeader.TotalAmount) * 100;
//             Rec."Item Margins" := Margin;
//         end;
//     end;

//     procedure GetBOMTotals(var Rec: Record "Sales Line")
//     var
//         SalesLine: Record "Sales Line";
//         SalesHeader: Record "Sales Header";
//         TotalBOMAmount: Decimal;
//         TotalBOMUnitCost: Decimal;
//     begin
//         SalesLine.SetRange("Document Type", Rec."Document Type");
//         SalesLine.SetRange("Document No.", Rec."Document No.");
//         If SalesLine.FindSet() then
//             repeat
//                 IF SalesLine."BOM Item No." <> '' then begin
//                     TotalBOMAmount += SalesLine.Amount;
//                     TotalBOMUnitCost += (SalesLine.Quantity * SalesLine."Unit Cost");
//                 end;
//             until SalesLine.Next() = 0;
//         IF SalesHeader.get(Rec."Document Type", Rec."Document No.") then begin
//             SalesHeader.TotalBOMAmount := TotalBOMAmount;
//             SalesHeader.TotalUnitCostBOMItem := TotalBOMUnitCost;
//             SalesHeader.Modify(true);
//         end;
//     end;

//     procedure BundleMargintintoSalesLine(var Rec: Record "Sales Header")
//     var
//         SalesLine: Record "Sales Line";
//     begin
//         SalesLine.SetRange("Document Type", Rec."Document Type");
//         SalesLine.SetRange("Document No.", Rec."No.");
//         SalesLine.LockTable();
//         IF SalesLine.FindSet() then
//             repeat
//                 IF (SalesLine.Type = SalesLine.Type::" ") and (SalesLine."BOM Item No." <> '') then begin
//                     SalesLine."Line Discount %" := Rec."Order Margin";
//                     SalesLine.Modify();
//                     // Message('%1 ,%2,%3', SalesLine."BOM Item No.", SalesLine.Description, SalesLine."Line Discount %");
//                 end;
//             until SalesLine.Next() = 0;
//         Commit();
//     end;
//     /**************************************         Sales Order BOM Auto Explode*******************************/
//     // [EventSubscriber(ObjectType::Page, Page::"Sales order Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
//     // local procedure OnAfterValidateEventBOMOrder(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
//     // var
//     //     Item: Record Item;
//     //     SalesHeader: Record "Sales Header";
//     // begin
//     //     IF Item.Get(Rec."No.") THEN;
//     //     Item.CalcFields("Assembly BOM");
//     //     IF (Rec.Quantity <> 0) and (Item."Assembly BOM") then
//     //         IF GuiAllowed then begin
//     //             if Rec."Prepmt. Amt. Inv." <> 0 then
//     //                 Error(Text001);
//     //             CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
//     //             DocumentTotals.SalesDocTotalsNotUpToDate();
//     //         end;
//     //     SalesHeader.SetRange("Document Type", Rec."Document Type");
//     //     SalesHeader.SetRange("No.", Rec."Document No.");
//     //     If SalesHeader.FindSet() then
//     //         BundleMargintintoSalesLine(SalesHeader);
//     // end;

//     var
//         DocumentTotals: Codeunit "Document Totals";
//         Text001: Label ' You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
// }
codeunit 50208 ICGeneralJoural
{
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Gen. Jnl.-Post Batch", 'OnAfterPostGenJournalLine', '', false, false)]
    local procedure OnAfterActionEventPost(var GenJournalLine: Record "Gen. Journal Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        Project: Record Job;
        // Partner: Record "IC Partner";
        CompanyInfo: Record "Company Information";
    begin
        if CompanyInfo.get() then begin
            // Partner.Get(GenJournalLine."IC Partner Code");
            Message(CompanyInfo.Name);
            IF CompanyInfo.Name <> 'DemoUNC' then begin
                if GenJournalLine."Project reference" = '' then
                    Message('Create new Project')
                else
                    Message('Insert into existing project');
            end else
                Message('no need to create project');
        end;
    end;

    //  [EventSubscriber(ObjectType::Codeunit, Codeunit::"IC Outbox Export", '', '', false, false)]
    // local procedure OnBeforeCreateJournalLines(GenJnlTemplate: Record "Gen. Journal Template"; InboxJnlLine: Record "IC Inbox Jnl. Line"; var TempGenJnlLine: Record "Gen. Journal Line" temporary; InboxTransaction: Record "IC Inbox Transaction")
    // begin
    //     InboxJnlLine.Validate("Project reference", TempGenJnlLine."Project reference");
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnBeforeCreateJournalLines', '', false, false)]
    // local procedure OnBeforePostICGenJnlLine(GenJnlTemplate: Record "Gen. Journal Template"; InboxJnlLine: Record "IC Inbox Jnl. Line"; var TempGenJnlLine: Record "Gen. Journal Line" temporary; InboxTransaction: Record "IC Inbox Transaction")
    // begin
    //     TempGenJnlLine.Validate("Project reference", InboxJnlLine."Project reference");
    // end;

    var

        code: Codeunit 427;
        // OnBeforeTransferICGenJnlLine
        test: Page "IC Outbox Transactions";
        testing: Record "Sales Order Entity Buffer";
}