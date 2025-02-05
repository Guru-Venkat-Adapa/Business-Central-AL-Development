pageextension 50127 "Sales Invoice Statistics Ext" extends "Sales Invoice Statistics"
{
    layout
    {
        modify(VATAmount)
        {
            CaptionClass = '20% GST';
        }
        modify(AmountInclVAT)
        {
            Caption = 'Total Incl. GST';
        }
    }
}
