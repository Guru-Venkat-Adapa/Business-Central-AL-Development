pageextension 50041 "Transfer Order Subform Ext" extends "Transfer Order Subform"
{
    layout
    {
        //TBC - 937  --->
        addbefore("Item No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Line No.';
            }
        }
        //TBC - 937  <---
        modify("Description 2")
        {
            Visible = true;
        }
        //TBC-1074 --->
        modify("GST Group Code")
        {
            Editable = false;
        }
        //TBC-1074 <---
    }
}
