pageextension 50151 "Sales Order Statistics Ext" extends "Sales Order Statistics"
{
    layout
    {
        modify(LineAmountGeneral)
        {
            CaptionClass = 'Amount Excl. GST';
        }
        modify("TotalAmount1[1]")
        {
            CaptionClass = 'Total Excl. GST';
        }
        modify(VATAmount)
        {
            CaptionClass = '10% GST';
        }
        modify("TotalAmount2[1]")
        {
            CaptionClass = 'Total Incl. GST';
        }
        modify(AmountInclVAT_Invoicing)
        {
            CaptionClass = 'Amount Excl. GST';
        }
        modify(TotalInclVAT_Invoicing)
        {
            CaptionClass = 'Total Excl. GST';
        }
        modify(VATAmount_Invoicing)
        {
            CaptionClass = '10% GST';
        }
        modify(TotalExclVAT_Invoicing)
        {
            CaptionClass = 'Total Incl. GST';
        }
        modify("TotalSalesLine[3].""Line Amount""")
        {
            CaptionClass = 'Amount Excl. GST';
        }
        modify("TotalAmount1[3]")
        {
            CaptionClass = 'Total Excl. GST';
        }
        modify("VATAmount[3]")
        {
            CaptionClass = '10% GST';
        }
        modify("TotalAmount2[3]")
        {
            CaptionClass = 'Toatl Incl. GST';
        }
        modify(PrepmtTotalAmount)
        {
            CaptionClass = 'Prepmt. Amount Excl. GST';
        }
        modify(PrepmtVATAmount)
        {
            CaptionClass = 'GST Amount';
        }
        modify(PrepmtTotalAmount2)
        {
            CaptionClass = 'Prepmt. Amount Incl. GST';
        }
        modify("TotalSalesLine[1].""Prepmt. Amt. Inv.""")
        {
            CaptionClass = 'Prepmt. Amt. Invoiced Excl. GST';
        }
        modify("TotalSalesLine[1].""Prepmt Amt Deducted""")
        {
            CaptionClass = 'Prepmt. Amt. Deducted Excl. GST';
        }
        modify("TotalSalesLine[1].""Prepmt Amt to Deduct""")
        {
            CaptionClass = 'Prepmt. Amt. to Deduct Excl. GST';
        }
    }
}
