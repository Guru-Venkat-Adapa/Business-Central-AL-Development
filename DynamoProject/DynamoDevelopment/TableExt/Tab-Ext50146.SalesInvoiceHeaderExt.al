tableextension 50150 "Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        modify("VAT Reporting Date")
        {
            Caption = 'GST Date';
        }
        modify("Amount Including VAT")
        {
            Caption = 'Amount Including GST';
        }
    }
}
