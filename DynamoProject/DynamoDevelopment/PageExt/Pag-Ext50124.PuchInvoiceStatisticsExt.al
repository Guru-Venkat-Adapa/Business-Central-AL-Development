pageextension 50124 "Puch Invoice Statistics Ext" extends "Purchase Invoice Statistics"
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
