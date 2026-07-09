pageextension 50052 "Nav Purchase Return Order Ext" extends "Purchase Return Order"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        addbefore("Buy-from Vendor No.")
        {
            field("Purchase Order Type"; Rec."Purchase Order Type")
            {
                ApplicationArea = All;
                Caption = 'Purchase Return Order Type';
                Editable = false;
            }
        }
    }
}
