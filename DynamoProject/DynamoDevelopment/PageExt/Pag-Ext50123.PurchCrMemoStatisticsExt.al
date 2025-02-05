pageextension 50123 "Purch. Cr Memo Statistics Ext" extends "Purch. Credit Memo Statistics"
{
    layout
    {
        modify(VATAmount)
        {
            CaptionClass = 'GST Amount';
        }
        modify(AmountInclVAT)
        {
            CaptionClass = 'Total Incl. GST';
        }
    }
}
