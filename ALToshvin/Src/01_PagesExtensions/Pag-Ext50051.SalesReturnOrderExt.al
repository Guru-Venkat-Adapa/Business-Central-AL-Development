pageextension 50051 "Nav Sales Return Order Ext" extends "Sales Return Order"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        addbefore("Sell-to Customer No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = All;
                Caption = 'Sales Return Order Type';
                Editable = false;
            }
        }
    }
}
