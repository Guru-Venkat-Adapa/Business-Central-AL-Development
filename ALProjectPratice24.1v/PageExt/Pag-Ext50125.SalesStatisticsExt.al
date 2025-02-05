pageextension 50125 "Sales Statistics Ext" extends "Sales Statistics"
{
    layout
    {
        modify(Amount)
        {
            CaptionClass = 'Amount Excl. GST';
        }
        modify(TotalAmount1)
        {
            CaptionClass = 'Total Excl. GST';
        }
        modify(VATAmount)
        {
            CaptionClass = '20% GST';
        }
        modify(TotalAmount2)
        {
            CaptionClass = 'Total Incl. GST';
        }
    }
}
