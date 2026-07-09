pageextension 50031 "Posted Purch Rcpt. Subform Ext" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        //TBC - 835 -->
        addbefore("No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Caption = 'Line No.';
                Editable = false;
            }
        }
        //TBC - 835 <--
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        addbefore("Shortcut Dimension 1 Code")
        {
            field(MExpiryDate; Rec.MExpiryDate)
            {
                ApplicationArea = All;
                Caption = 'M Expiry Date';
                Editable = false;
            }
        }
    }
}
