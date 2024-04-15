tableextension 50113 "Purchase Invoice Header Ext" extends "Purch. Inv. Header"
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