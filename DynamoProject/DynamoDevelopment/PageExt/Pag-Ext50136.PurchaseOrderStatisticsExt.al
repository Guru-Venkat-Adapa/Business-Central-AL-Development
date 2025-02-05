pageextension 50136 "Purchase Order Statistics  Ext" extends "Purchase Order Statistics"
{
    layout
    {
        modify(LineAmountGeneral)
        {
            CaptionClass = 'Amount Excl. GST';
        }
        modify(Total_General)
        {
            CaptionClass = 'Total Excl. GST';
        }
        modify("VATAmount[1]")
        {
            CaptionClass = 'GST Amount';
        }
        modify("TotalInclVAT_General")
        {
            CaptionClass = 'Total Incl. GST';
        }
        modify("TotalPurchLine[2].""Line Amount""")
        {
            CaptionClass = 'Amount Excl. GST';
        }
        modify(Total_Invoicing)
        {
            CaptionClass = 'Total Excl. GST';
        }
        modify(VATAmount_Invoicing)
        {
            CaptionClass = 'GST Amount';
        }
        modify(TotalInclVAT_Invoicing)
        {
            CaptionClass = 'Total Incl. GST';
        }
        modify("TotalPurchLine[3].""Line Amount""")
        {
            CaptionClass = 'Amount Excl. GST';
        }
        modify("TotalAmount1[3]")
        {
            CaptionClass = 'Total Excl. GST';
        }
        modify("VATAmount[3]")
        {
            CaptionClass = 'GST Amount';
        }
        modify(TotalInclVAT_Shipping)
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
        modify("TotalPurchLine[1].""Prepmt. Amt. Inv.""")
        {
            CaptionClass = 'Prepmt. Amt. Invoiced Excl. GST';
        }
        modify("TotalPurchLine[1].""Prepmt Amt Deducted""")
        {
            CaptionClass = 'Prepmt. Amt. Deducted Excl. GST';
        }
        modify("TotalPurchLine[1].""Prepmt Amt to Deduct""")
        {
            CaptionClass = 'Prepmt. Amt. to Deduct Excl. GST';
        }
        modify("TempVATAmountLine4.COUNT")
        {
            Caption = 'No. of GST Lines';
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
