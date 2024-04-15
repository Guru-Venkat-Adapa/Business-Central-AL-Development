tableextension 50120 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(50105; "Name Text"; Text[100])
        {
            Caption = 'Text For Name';
        }
        field(50100; "Temp Text"; Text[100])
        {
            Caption = 'Temp Text';
            DataClassification = CustomerContent;
        }
    }
}