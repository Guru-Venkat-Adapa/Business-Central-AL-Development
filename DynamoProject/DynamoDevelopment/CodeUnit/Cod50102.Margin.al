codeunit 50102 Margin
{
    /***************************** Exploding BOM item Automatically for sales quote ****************************/
    [EventSubscriber(ObjectType::Page, Page::"Sales Quote Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateEventBOM(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        Item: Record Item;
    begin
        IF Item.Get(Rec."No.") THEN;
        Item.CalcFields("Assembly BOM");
        IF (Rec.Quantity <> 0) and (Item."Assembly BOM") then
            IF GuiAllowed then begin
                if Rec."Prepmt. Amt. Inv." <> 0 then
                    Error(Text001Txt);
                CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
                DocumentTotals.SalesDocTotalsNotUpToDate();
            end;
    end;
    /******************************** Order MArgin And Item Margin *************************************/

    /*******************************  Modifing the margins  on Delete Event       ***********************/
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteOrderMargin(var Rec: Record "Sales Line")
    begin
        Rec.Amount := 0;
        Rec.Quantity := 0;
        OrderMargin(Rec);
        ClearBundleValue(rec);
    end;
    /*******************************  Modifing the margins on Updatating line Discount %       ***********************/
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    local procedure OnAfterValidateDiscPercentage(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
        if Rec."Document Type" <> Rec."Document Type"::Invoice then begin
            ItemMargin(Rec, xRec);
            OrderMargin(Rec);
        end;
    end;
    // [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    // local procedure OnAfterValidateDiscPercentage(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    // begin
    //     if Rec."Document Type" <> Rec."Document Type"::Invoice then begin
    //         ItemMargin(Rec, xRec);
    //         OrderMargin(Rec);
    //     end;

    // end;
    // // /*******************************  Modifing the margins on Updatating line Discount amount       ***********************/

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount Amount', false, false)]
    local procedure OnAfterValidateDiscAmount(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
        if Rec."Document Type" <> Rec."Document Type"::Invoice then begin
            ItemMargin(Rec, xRec);
            OrderMargin(Rec);
        end;
    end;

    // [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", 'OnAfterValidateEvent', 'Line Discount Amount', false, false)]
    // local procedure OnAfterValidateDiscAmount(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    // begin
    //     if Rec."Document Type" <> Rec."Document Type"::Invoice then begin
    //         ItemMargin(Rec, xRec);
    //         OrderMargin(Rec);
    //     end;
    // end;



    /* **************************** Item Margin Calcuation *****************************/
    procedure ItemMargin(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        Item: Record Item;
        TotalUnitCost: Decimal;
        SellingPrice: Decimal;
        Margin: Decimal;
    begin
        IF Rec."Document Type" <> Rec."Document Type"::Invoice then begin
            IF Rec."No." = xRec."No." then begin
                if Item.Get(Rec."No.") and (Rec.Quantity <> 0) then begin
                    TotalUnitCost := Rec."Unit Cost" * Rec.Quantity;
                    IF rec.Amount <> 0 then begin
                        SellingPrice := Rec.Amount - TotalUnitCost;
                        Margin := (SellingPrice / Rec.Amount) * 100;
                        Rec."Item Margins" := Round(Margin, 0.01);
                    end else
                        Rec."Item Margins" := 0;
                end
                else
                    Rec."Item Margins" := 0;
            end
            else begin
                Clear(Rec.Quantity);
                Rec."Item Margins" := 0;
            end;
        end else
            Rec."Item Margins" := 0;
    end;
    /************************************* Order Margin Calculation  *************************************/
    procedure OrderMargin(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        Margin: Decimal;
        SellingPrice: Decimal;
    begin

        GetTotalInSalesHeader(rec);
        IF SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            IF (SalesHeader.TotalUnitcost <> 0) and (SalesHeader.TotalAmount <> 0) then begin
                SellingPrice := SalesHeader.TotalAmount - SalesHeader.TotalUnitCost;
                Margin := (SellingPrice / SalesHeader.TotalAmount) * 100;
                SalesHeader."Order Margin" := Round(Margin, 0.01);
            end else
                SalesHeader."Order Margin" := 0;
            SalesHeader.Modify(false);
        end;
    end;
    /*************************************  Caluating Total Unitcost, Unit Price and Total quantity for Order Margin**********************************/
    procedure GetTotalInSalesHeader(var salesline: Record "Sales Line")
    var
        SalesLineAmonts: Record "Sales Line";
        SalesHeader: Record "Sales Header";

        UnitCostQty: Decimal;
        SalesLineUpdateAmount: Decimal;
        SalesLineUpdateUnitPrice: Decimal;
        XTotalAmount: Decimal;
        XtotalUnitCost: Decimal;
        Quantity: Decimal;
        xQuantity: Decimal;
        TotalAmount: Decimal;
        TotalUnitCost: Decimal;
        TotalQuantity: Decimal;

    begin
        SalesLineAmonts.SetRange("Document No.", SalesLine."Document No.");
        SalesLineAmonts.SetRange("Document Type", SalesLine."Document Type");
        // SalesLineAmonts.SetFilter(Type, '=%1', salesline.Type::Item);
        if SalesLineAmonts.FindSet() then
            repeat
                IF (SalesLineAmonts.Quantity <> 0) or (salesline.Quantity <> 0) then begin
                    SalesLineUpdateAmount := salesline.Amount;
                    SalesLineUpdateUnitPrice := salesline."Unit Cost" * salesline.Quantity;
                    // Quantity := salesline.Quantity;
                    IF SalesLineAmonts."Line No." <> salesline."Line No." then
                        IF SalesLineAmonts.Type <> SalesLineAmonts.Type::"G/L Account" then begin
                            UnitCostQty := SalesLineAmonts."Unit Cost" * SalesLineAmonts.Quantity;
                            XtotalUnitCost := XtotalUnitCost + UnitCostQty;
                            XTotalAmount := XTotalAmount + SalesLineAmonts.Amount;
                            xQuantity := xQuantity + SalesLineAmonts.Quantity;
                        end;
                end;
            until SalesLineAmonts.Next() = 0;
        TotalUnitCost := XtotalUnitCost + SalesLineUpdateUnitPrice;
        TotalAmount := XTotalAmount + SalesLineUpdateAmount;
        TotalQuantity := Quantity + xQuantity;
        IF SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
            SalesHeader.TotalUnitCost := TotalUnitCost;
            SalesHeader.TotalAmount := TotalAmount;
            SalesHeader.TotalQuantity := TotalQuantity;
            SalesHeader."Gross Profit" := SalesHeader.TotalAmount - SalesHeader.TotalUnitCost;
            SalesHeader.Modify(false);
        end;
    end;

    //*********************************************           Bundle Margin             *************************************

    /*****************************  Calcuating the Bundle margin after the BOm items are explored        *********************************/
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Explode BOM", 'OnInsertOfExplodedBOMLineToSalesLine', '', false, false)]
    local procedure InsertBundleMargin(var ToSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line"; BOMComponent: Record "BOM Component"; var SalesHeader: Record "Sales Header"; LineSpacing: Integer)
    begin
        BundleMargin(ToSalesLine);
    end;
    /******************************************** Calculating Bundle Margin **************************************************/
    procedure BundleMargin(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        Margin: Decimal;
        Revenue: Decimal;
        TotalUnitCost: Decimal;
    begin
        IF SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            SalesHeader.BundleTotalAmount += Rec.Amount;
            TotalUnitCost := Rec."Unit Cost" * Rec.Quantity;
            SalesHeader.BundleTotalUnitCost += TotalUnitCost;

            IF (SalesHeader.BundleTotalAmount <> 0) and (SalesHeader.BundleTotalUnitCost <> 0) then begin
                Revenue := SalesHeader.BundleTotalAmount - SalesHeader.BundleTotalUnitCost;
                Margin := (Revenue / SalesHeader.BundleTotalAmount) * 100;
                SalesHeader.BundleMargin := Round(Margin, 0.01);
            end;
            SalesHeader.Modify(false);
            BundleMargintintoSalesLine(SalesHeader);
        end;
    end;
    /****************************************  Inserting the Bundle Margin from Sales header to sales line's comment line****************************************/
    procedure BundleMargintintoSalesLine(var Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        IF SalesLine.FindSet() then
            repeat
                IF (SalesLine.Type = SalesLine.Type::" ") and (SalesLine."BOM Item No." <> '') then begin
                    SalesLine."Item Margins" := Rec.BundleMargin;
                    SalesLine.Modify(false);
                    // Message('%1 ,%2,%3', SalesLine."BOM Item No.", SalesLine.Description, SalesLine."Line Discount %");
                end;
            until SalesLine.Next() = 0;
    end;
    /***************************************  Clearing the bundle margin and related data ****************************************/
    procedure ClearBundleValue(Var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", Rec."Document Type");
        SalesHeader.SetRange("No.", Rec."Document No.");
        If SalesHeader.FindSet() then
            IF Rec."BOM Item No." <> '' then begin
                SalesHeader.BundleTotalAmount := 0;
                SalesHeader.BundleTotalUnitCost := 0;
                SalesHeader.BundleMargin := 0;
                SalesHeader.Modify(false);
                BundleMargintintoSalesLine(SalesHeader);
            end;
    end;
    /*************************************  Events  *************************************/
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]

    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")

    begin
        CustLedgerEntry."Sales Order No." := GenJournalLine."Sales Order No.";
    end;

    var
        DocumentTotals: Codeunit "Document Totals";

        Text001Txt: Label ' You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';

}