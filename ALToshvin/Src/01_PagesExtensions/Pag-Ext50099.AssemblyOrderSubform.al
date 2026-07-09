pageextension 50099 "Assembly Order Subform" extends "Assembly Order Subform"
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
