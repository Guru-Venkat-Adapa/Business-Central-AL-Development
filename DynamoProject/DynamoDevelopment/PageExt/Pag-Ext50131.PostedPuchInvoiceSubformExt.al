pageextension 50131 "Post Puch Invoice Subform Ext" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        modify("Invoice Discount Amount")
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Invoice Discount Amount Excl. GST', Currency.Code);
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
        modify("Direct Unit Cost")
        {
            CaptionClass = 'Direct Unit Cost Excl. GST';
        }
        modify("Line Amount")
        {
            CaptionClass = 'Line Amount Excl. GST';
        }
    }
    var
        DocumentTotals: Codeunit "Document Totals";
        Currency: Record "Currency";
}
