pageextension 50105 "Sales Shipment Header Ext" extends "Posted Sales Shipment"
{
    layout
    {
        // Add changes to page layout here
        addafter("Order No.")
        {
            field("Name Text"; Rec."Name Text")
            {
                ApplicationArea = All;
                Caption = 'Text For Name';
            }
        }
    }
}