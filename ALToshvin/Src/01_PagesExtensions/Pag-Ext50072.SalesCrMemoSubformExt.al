pageextension 50072 "Sales Cr. Memo Subform Ext" extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        //TBC-1072 --->
        addafter("Location Code")
        {
            field("Item Instrument No."; Rec."Item Instrument No.")
            {
                ApplicationArea = All;
                Caption = 'Instrument Serial No.';
            }
        }
        //TBC-1072 <---
    }
}
