pageextension 50132 "Purch. Cr Memo Statistics Ext" extends "Purch. Credit Memo Statistics"
{
    layout
    {
        modify(VATAmount)
        {
            CaptionClass = 'GST Amount';
        }
        modify(AmountInclVAT)
        {
            Caption = 'Amount Incl. GST';
        }
    }
}
