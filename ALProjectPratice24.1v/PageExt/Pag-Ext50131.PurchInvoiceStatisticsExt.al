pageextension 50131 "Purch Invoice Statistics Ext" extends "Purchase Invoice Statistics"
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
