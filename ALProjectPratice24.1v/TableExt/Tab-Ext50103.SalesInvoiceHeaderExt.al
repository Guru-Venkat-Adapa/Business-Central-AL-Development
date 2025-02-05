tableextension 50103 "Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(50100; "Custom Amount (LCY)"; Decimal)
        {
            Caption = 'Custom Amount (LCY)';
            DataClassification = CustomerContent;
        }
    }
}
