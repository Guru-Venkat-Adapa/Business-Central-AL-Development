pageextension 50200 "Sales Odrer Subfrom Ext" extends "Sales Order Subform"
{
    layout
    {
        // modify(Quantity)
        // {
        //     trigger OnAfterValidate()
        //     var
        //         SalesLineRec: Record "Sales Line" temporary;
        //         SalesHeader: Record "Sales Header";
        //         SalesLineUpdates: Record "Sales Line";
        //     begin
        //         SalesLineRec.DeleteAll();
        //         IF Item.Get(Rec."No.") THEN;
        //         Item.CalcFields("Assembly BOM");
        //         IF (Rec.Quantity <> 0) and (Item."Assembly BOM") then
        //             IF GuiAllowed then begin
        //                 if Rec."Prepmt. Amt. Inv." <> 0 then
        //                     Error(Text001);
        //                 SalesLineRec.Copy(Rec);
        //                 CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
        //                 DocumentTotals.SalesDocTotalsNotUpToDate();
        //                 //CurrPage.SaveRecord();
        //                 // Rec := SalesLineRec;
        //                 // Rec.Init();
        //                 // Rec.Description := SalesLineRec.Description;
        //                 // Rec."Description 2" := SalesLineRec."Description 2";
        //                 // Rec."BOM Item No." := SalesLineRec."No.";
        //                 // CurrPage.Update(true);
        //                 SalesHeader.SetRange("Document Type", Rec."Document type");
        //                 SalesHeader.SetRange("No.", Rec."Document No.");
        //                 if SalesHeader.FindSet() then begin
        //                     SalesLineUpdates.SetFilter("Document No.", SalesHeader."No.");
        //                     SalesLineUpdates.SetFilter("Document Type", Format(SalesHeader."Document Type"));
        //                     If SalesLineUpdates.FindSet() then
        //                         repeat
        //                             IF (SalesLineUpdates.Type = SalesLineUpdates.Type::" ") and (SalesLineUpdates."BOM Item No." <> '') then begin
        //                                 SalesLineUpdates."Line Discount %" := SalesHeader."Order Margin";
        //                                 SalesLineUpdates.Modify();
        //                             end;
        //                         until SalesLineUpdates.Next() = 0;
        //                 end;
        //             end;

        //     end;
        // }
        addafter("Unit Price")
        {
            field("Item Margin"; Rec."Item Margins")
            {
                Caption = 'Item Margin';
                ApplicationArea = All;
            }
        }
    }
    var
        Item: Record Item;
        Text001: Label ' You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
}
