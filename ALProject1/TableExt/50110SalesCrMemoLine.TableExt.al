tableextension 50110 "Sales Credit Memo Line Ext" extends "Sales Cr.Memo Line"
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