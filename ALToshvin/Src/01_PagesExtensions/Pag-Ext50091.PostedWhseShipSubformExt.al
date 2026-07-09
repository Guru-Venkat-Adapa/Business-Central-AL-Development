pageextension 50091 "Posted Whse. Ship Subform Ext" extends "Posted Whse. Shipment Subform"
{
    //TBC - 835 -->
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
    //TBC - 835 <--
}
