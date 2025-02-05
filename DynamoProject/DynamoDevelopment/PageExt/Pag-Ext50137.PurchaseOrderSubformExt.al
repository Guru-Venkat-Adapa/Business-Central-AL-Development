pageextension 50137 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        modify(AmountBeforeDiscount)
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Subtotal Excl. GST', Currency.Code);
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
        modify("VAT Prod. Posting Group")
        {
            Caption = 'GST Prod. Posting Group';
        }
    }
    var
        Currency: Record Currency;
        DocumentTotals: Codeunit "Document Totals";
}
