tableextension 50116 "Purchase Receipt Ext" extends "Purch. Rcpt. Line"
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