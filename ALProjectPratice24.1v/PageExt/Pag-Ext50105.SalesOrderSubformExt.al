pageextension 50105 "Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        modify("TotalSalesLine.""Line Amount""")
        {
            // Caption = 'Subtotal Excl. GST';
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Subtotal Excl. GST', Currency.Code);
        }
        modify("Invoice Discount Amount")
        {
            // Caption = 'Inv. Discount Amount Excl. GST';
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Inv. Discount Amount Excl. GST', Currency.Code);
        }
        modify("Total Amount Excl. VAT")
        {
            // Caption = 'Total Amount Excl. GST';
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Total Amount Excl. GST', Currency.Code);

        }
        modify("Total VAT Amount")
        {
            // Caption = 'Total GST Amount';
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Total GST Amount', Currency.Code);
        }
        modify("Total Amount Incl. VAT")
        {
            // Caption = 'Total Amount Incl. GST';
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Total Amount Incl. GST', Currency.Code);
        }
        modify("Unit Price")
        {
            Caption = 'Unit Price Excl. GST';
        }
        modify("Line Amount")
        {
            //    CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Total Amount Incl. GST');
            Caption = 'Line Amount Excl. GST';
        }
    }
}
