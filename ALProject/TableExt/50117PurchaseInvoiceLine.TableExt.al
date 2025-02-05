tableextension 50117 "Purchase Invoice Line Ext" extends "Purch. Inv. Line"
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