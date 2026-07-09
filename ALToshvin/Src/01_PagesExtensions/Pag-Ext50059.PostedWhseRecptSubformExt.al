pageextension 50059 "Posted Whse. Recpt Subform Ext" extends "Posted Whse. Receipt Subform"
{
    layout
    {
        //TBC - 835 -->
        addbefore("Item No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Line No.';
            }
        }
        //TBC - 835 <--
        modify("Bin Code")
        {
            Visible = true;
            Editable = false;
        }
        addafter("Unit of Measure Code")
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
