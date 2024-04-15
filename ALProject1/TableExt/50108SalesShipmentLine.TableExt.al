tableextension 50108 "Sales Shipment Line Ext" extends "Sales Shipment Line"
{
    fields
    {
        // Add changes to table fields here
         field(50100; "Text Line"; Text[100])
        {
            Caption = 'Text For Line';
            DataClassification = CustomerContent;
        }
    }
}