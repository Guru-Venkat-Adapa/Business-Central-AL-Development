tableextension 50118 "Purchase Cr Memo Line Ext" extends "Purch. Cr. Memo Line"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Temp TextLine"; Text[100])
        {
            Caption = 'Temp Textline';
            DataClassification = CustomerContent;
        }
    }
}