pageextension 50149 "Sales Quote Subform Ext" extends "Sales Quote Subform"
{
    layout
    {
        modify("Subtotal Excl. VAT")
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(CaptionText, Currency.Code);
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
        modify("Unit Price")
        {
            CaptionClass = UnitPriceCaption;
        }
        modify("Line Amount")
        {
            CaptionClass = LineAmountCaption;
        }

        addafter("Unit Price")
        {
            field("Item Margins"; Rec."Item Margins")
            {
                Caption = 'Bundle/Item Margin';
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";

    begin
        CaptionText := '';
        SalesHeader.get(Rec."Document Type", Rec."Document No.");
        IF SalesHeader."Prices Including VAT" then begin
            CaptionText := 'Subtotal Incl. GST';
            UnitPriceCaption := ' Unit Price Incl. GST';
            LineAmountCaption := 'Line Amount Incl. GST';
        end
        else begin
            CaptionText := 'Subtotal Excl. GST';
            UnitPriceCaption := ' Unit Price Excl. GST';
            LineAmountCaption := 'Line Amount Excl. GST';
        end;
    end;

    var
        CaptionText: Text;
        UnitPriceCaption: Text;
        LineAmountCaption: Text;
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
}
