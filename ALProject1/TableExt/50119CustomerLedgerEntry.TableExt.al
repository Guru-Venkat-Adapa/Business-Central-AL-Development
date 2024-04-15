tableextension 50119 "Cust. Ledger Entry Ext" extends "Cust. Ledger Entry"
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