pageextension 50129 "Purchase Statistics Ext" extends "Purchase Statistics"
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
