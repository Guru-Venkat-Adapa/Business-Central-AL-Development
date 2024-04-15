tableextension 50114 "Purchase Cr. Memo Header Ext" extends "Purch. Cr. Memo Hdr."
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