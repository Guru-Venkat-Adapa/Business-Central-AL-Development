tableextension 50105 "Sales Invoice Header Ext" extends "Sales Invoice Header"
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