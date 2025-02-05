tableextension 50104 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        modify("Qty. to Ship")
        {
            trigger OnAfterValidate()
            var
                code: Codeunit SalesOrder;
            begin
                // code.GetLCY(Rec);
            end;
        }
        modify("Unit Price")
        {
            CaptionClass = GetInvoiceDiscAmountWithVATAndCurrencyCaption('Unit Price Excl. GST');
        }
        modify("Line Amount")
        {
            CaptionClass = GetInvoiceDiscAmountWithVATAndCurrencyCaption('Line Amount Excl. GST');
        }
    }
    procedure GetInvoiceDiscAmountWithVATAndCurrencyCaption(InvDiscAmountCaptionClassWithVAT: Text): Text
    begin
        exit(InvDiscAmountCaptionClassWithVAT);
    end;

}
