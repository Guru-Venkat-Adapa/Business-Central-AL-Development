tableextension 50104 "Sales Shipment Header Ext" extends "Sales Shipment Header"
{
    fields
    {
        // Add changes to table fields here
        field(50105; "Name Text"; Text[100])
        {
            Caption = 'Text For Name';
        }
    }
}