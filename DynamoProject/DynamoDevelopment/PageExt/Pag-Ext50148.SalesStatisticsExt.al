pageextension 50148 "Sales Statistics Ext" extends "Sales Statistics"
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
            CaptionClass = 'GST Amount';
        }
        modify(TotalAmount2)
        {
            CaptionClass = 'Total Incl. GST';
        }
    }
}
