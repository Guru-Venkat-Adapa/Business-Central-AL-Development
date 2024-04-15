tableextension 50115 "Purchase Line Ext" extends "Purchase Line"
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