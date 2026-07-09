pageextension 50077 "Posted Sl Cr. Memo Subform Ext" extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        // modify("Location Code")
        // {
        //     Caption = 'Warehouse Code';
        // }
        //TBC-1072 --->
        addafter("Line Discount %")
        {
            field("Item Instrument No."; Rec."Item Instrument No.")
            {
                ApplicationArea = All;
                Caption = 'Instrument Serial No.';
                Editable = false;
            }
        }
        //TBC-1072 <---
    }
}
