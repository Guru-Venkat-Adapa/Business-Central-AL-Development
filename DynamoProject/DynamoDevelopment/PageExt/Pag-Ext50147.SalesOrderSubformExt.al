pageextension 50147 "Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        // addafter(Quantity)
        // {
        //     field(TotalInclGST; Rec.TotalInclGST)
        //     {
        //         ApplicationArea = All;
        //         Caption = 'Toatl Incl GST';
        //     }
        //     field(TotalUnitcost; Rec.TotalUnitcost)
        //     {
        //         ApplicationArea = All;
        //         Caption = 'Total Unit Cost';
        //     }
        // }

        // modify("Line Discount %")
        // {
        //     // trigger OnAfterValidate()
        //     // var
        //     //     SalesHeader: Record "Sales Header";
        //     // begin

        //     // end;
        // }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
                SalesLineUpdates: Record "Sales Line";
            begin
                SalesHeader.SetRange("Document Type", Rec."Document type");
                SalesHeader.SetRange("No.", Rec."Document No.");
                if SalesHeader.FindSet() then begin
                    SalesLineUpdates.SetFilter("Document No.", SalesHeader."No.");
                    SalesLineUpdates.SetFilter("Document Type", Format(SalesHeader."Document Type"));
                    If SalesLineUpdates.FindSet() then
                        repeat
                            IF (SalesLineUpdates.Type = SalesLineUpdates.Type::" ") and (SalesLineUpdates."BOM Item No." <> '') then begin
                                SalesLineUpdates."Item Margins" := Round(SalesHeader.BundleMargin, 0.01);
                                SalesLineUpdates.Modify(false);
                            end;
                        until SalesLineUpdates.Next() = 0;
                end;
            end;
        }
        modify("TotalSalesLine.""Line Amount""")
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Subtotal Excl GST', Currency.Code);
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
        modify("Item Margins")
        {
            Caption = 'Bundle/Item Margin';
        }

    }
    // var
    // test:Record "Shpfy Order Header";
}
