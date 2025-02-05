pageextension 50138 "Purchase Statistics Ext" extends "Purchase Statistics"
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
        modify(TotalAmount1ACY)
        {
            Caption = 'Total excl. GST (ACY)';
        }
        modify(VATAmountACY)
        {
            Caption = 'GST Amount (ACY)';
        }
        modify(TotalAmount2ACY)
        {
            Caption = 'Total Incl. GST (ACY)';
        }
    }
}
