pageextension 50206 "Item Card Ext" extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Qty. on Purch. Order")
        {
            field("Qty. to Recive Bl Puch Order"; Rec."Qty. to Recive Bl Puch Order")
            {
                ApplicationArea = All;
                Caption = 'Qty. to Receive on Blanket Purchase Order';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}