tableextension 50112 "Purchase Receipt Header Ext" extends "Purch. Rcpt. Header"
{
    fields
    {
        // Add changes to table fields here\
       field(50100; "Temp Text"; Text[100])
        {
            Caption = 'Temp Text';
            DataClassification = CustomerContent;
        }
    }

}