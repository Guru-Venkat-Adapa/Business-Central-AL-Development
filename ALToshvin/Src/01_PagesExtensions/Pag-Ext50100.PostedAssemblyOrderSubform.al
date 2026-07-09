pageextension 50100 "Posted Assembly Order Subform" extends "Posted Assembly Order Subform"
{
    //TBC - 937  --->
    layout
    {
        addbefore("No.")
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
