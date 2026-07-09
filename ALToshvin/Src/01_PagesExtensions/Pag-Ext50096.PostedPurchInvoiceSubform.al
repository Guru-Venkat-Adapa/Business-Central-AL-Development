pageextension 50096 "Posted Purch. Invoice Subform" extends "Posted Purch. Invoice Subform"
{
    //TBC - 835 -->
    layout
    {
        addbefore("No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Caption = 'Line No.';
                Editable = false;
            }
        }

    }
    //TBC - 835 <--
}
