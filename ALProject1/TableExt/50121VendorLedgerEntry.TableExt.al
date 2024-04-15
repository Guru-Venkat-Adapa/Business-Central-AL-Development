tableextension 50121 "Vendor Ledger Entry Ext" extends "Vendor Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Temp Text"; Text[100])
        {
            Caption = 'Temp Text';
            DataClassification = CustomerContent;
        }
    }
}