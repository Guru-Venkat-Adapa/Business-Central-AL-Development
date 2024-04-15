pageextension 50109 "Sales Shipment SubForm Ext" extends "Posted Sales Shpt. Subform"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Description)
        {
           field("Text Line"; Rec."Text Line")
            {
                Caption = 'Text For Line';
                ApplicationArea = All;
            }
        }
    }
}