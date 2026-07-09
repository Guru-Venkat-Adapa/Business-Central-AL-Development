pageextension 50036 "Nav Sales Order Statistics Ext" extends "Sales Order Statistics"
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
            Visible = false;
        }
        modify("TotalAmount2[1]")
        {
            Visible = false;
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
            Visible = false;
        }
        modify(TotalExclVAT_Invoicing)
        {
            Visible = false;
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
            Visible = false;
        }
        modify("TotalAmount2[3]")
        {
            Visible = false;
        }
        modify(PrepmtTotalAmount)
        {
            CaptionClass = 'Prepmt. Amount Excl. GST';
        }
        modify(PrepmtVATAmount)
        {
            Visible = false;
        }
        modify(PrepmtTotalAmount2)
        {
            Visible = false;
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