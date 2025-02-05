pageextension 50128 "Sale Cr Memo Statistics Ext" extends "Sales Credit Memo Statistics"
{
    layout
    {
        modify(VATAmount)
        {
            CaptionClass = 'GST Amount';
        }
        modify(AmountInclVAT)
        {
            Caption = 'Total Incl. GST';
        }
    }
}
