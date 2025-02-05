tableextension 50101 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "Export Excel Data"; Code[20])
        {
            Caption = 'Export Excel Data';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
}
