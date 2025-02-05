tableextension 50145 "Puch Header Ext" extends "Purchase Header"
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
