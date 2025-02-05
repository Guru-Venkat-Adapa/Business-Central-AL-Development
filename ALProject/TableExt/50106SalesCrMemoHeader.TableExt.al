tableextension 50106 "Sales Cr. Memo Header Ext" extends "Sales Cr.Memo Header"
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