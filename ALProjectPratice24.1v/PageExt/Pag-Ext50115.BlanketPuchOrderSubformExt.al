pageextension 50115 "Blanket Puch Order Subform Ext" extends "Blanket Purchase Order Subform"
{
    layout
    {
        modify(AmountBeforeDiscount)
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Subtotal Excl. GST', Currency.Code);
        }
        modify("Total Amount Excl. VAT")
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Total  Excl. GST', Currency.Code);
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
        DocumentTotals: Codeunit "Document Totals";
        Currency: Record "Currency";
}
