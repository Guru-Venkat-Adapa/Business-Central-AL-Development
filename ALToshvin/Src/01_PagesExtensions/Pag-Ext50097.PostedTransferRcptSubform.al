pageextension 50097 "Posted Transfer Rcpt. Subform" extends "Posted Transfer Rcpt. Subform"
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
