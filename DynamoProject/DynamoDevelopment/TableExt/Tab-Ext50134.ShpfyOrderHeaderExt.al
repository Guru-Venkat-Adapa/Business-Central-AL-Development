tableextension 50134 "Shpfy Order Header Ext" extends "Shpfy Order Header"
{
    fields
    {
        field(50100; "Shipping Description"; Text[250])
        {
            Caption = 'Shipping Description';
            DataClassification = CustomerContent;
        }
    }
    var

        test: Report 30104;
}
