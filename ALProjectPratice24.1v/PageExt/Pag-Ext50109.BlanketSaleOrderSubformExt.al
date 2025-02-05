pageextension 50109 "Blanket Sale Order Subform Ext" extends "Blanket Sales Order Subform"
{
    layout
    {
        modify("SubtotalExclVAT")
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Subtotal Excl. GST', Currency.Code);
        }
        modify("Invoice Discount Amount")
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Inv. Discount Amount Excl. GST', Currency.Code);
        }
        modify("Total Amount Excl. VAT")
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Total Excl. GST', Currency.Code);
        }
        modify("Total VAT Amount")
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Total GST', Currency.Code);
        }
        modify("Total Amount Incl. VAT")
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Total Incl. GST', Currency.Code);
        }
    }
    var
        Currency: Record Currency;
        DocumentTotals: Codeunit "Document Totals";
}
