tableextension 50144 "Sales Cr.Memo Header Ext" extends "Sales Cr.Memo Header"
{
    fields
    {
        modify("VAT Reporting Date")
        {
            Caption = 'GST Date';
        }
    }
}
