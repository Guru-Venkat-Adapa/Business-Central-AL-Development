tableextension 50103 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "OriginalCopy"; Code[20])
        {
            Caption = 'Original Copy';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
