pageextension 50098 "Posted Transfer Shpt. Subform" extends "Posted Transfer Shpt. Subform"
{
    //TBC - 937  --->
    layout
    {
        addbefore("Item No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Line No.';
            }
        }
    }
    //TBC - 937  <---
}
