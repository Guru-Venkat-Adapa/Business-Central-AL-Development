pageextension 50203 "Sales Quote Subform Ext" extends "Sales Quote Subform"
{
    layout
    {
        addafter("Unit Price")
        {
            field("Item Margins"; Rec."Item Margins")
            {
                Caption = 'Item Margin';
                ApplicationArea = All;
            }
        }
        // modify("Invoice Disc. Pct.")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         TotalLineAmount: Decimal;
        //         SalesHeader: Record "Sales Header";
        //     begin
        //         repeat
        //             TotalLineAmount := TotalLineAmount + Rec."Line Amount";
        //         until Rec.Next() = 0;
        //         SalesHeader.get(Rec."Document Type", Rec."Document No.");
        //         SalesHeader.TotalDiscountAmount := Round(TotalLineAmount * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
        //         SalesHeader.Modify(false);
        //     end;
        // }
        // modify("Inv. Discount Amount")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         TotalLineAmount: Decimal;
        //         SalesHeader: Record "Sales Header";
        //     begin
        //         repeat
        //             TotalLineAmount := TotalLineAmount + Rec."Line Amount";
        //         until Rec.Next() = 0;
        //         SalesHeader.get(Rec."Document Type", Rec."Document No.");
        //         SalesHeader.TotalDiscountAmount := Round(TotalLineAmount * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
        //         SalesHeader.Modify(false);
        //     end;
        // }
    }
    // trigger OnAfterGetRecord()
    // var
    //     SalesOrderSub: Page "Sales Order Subform";
    // begin
    //     SalesOrderSub.GetRecord(Rec);
    //     Message(Format(InvoiceDiscountPct));
    // end;
    // var
    // ShopiFyrecord:Record "Shpfy Order Header";
}
