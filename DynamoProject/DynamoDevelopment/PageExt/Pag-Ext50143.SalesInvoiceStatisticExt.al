pageextension 50143 "Sales Invoice Statistic Ext" extends "Sales Invoice Statistics"
{
    layout
    {
        modify(VATAmount)
        {
            CaptionClass = '10% GST';
        }
        modify(AmountInclVAT)
        {
            Caption = 'Total Incl. GST';
        }
    }
}
