pageextension 50102 "Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
            begin
                SalesHeader.SetFilter("Document Type", Format(Rec."Document Type"));
                SalesHeader.SetFilter("No.", Rec."Document No.");
                if SalesHeader.FindFirst() then
                    if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
                        SalesHeader."Invoice Discount Value" += Rec."Unit Price";
                        SalesHeader.Modify(false);
                        InvoiceDiscountAmount := SalesHeader."Invoice Discount Value";
                    end;
            end;
        }
        addbefore("Line Discount %")
        {
            field("Item Margins"; Rec."Item Margins")
            {
                ApplicationArea = All;
                Caption = 'Item Margin';
            }
        }
    }
    var
        DocumentTotals: Codeunit "Document Totals";
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';

    // procedure ExplodeBOMCustom()
    // begin
    //     if Rec."Prepmt. Amt. Inv." <> 0 then
    //         Error(Text001);
    //     CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
    //     DocumentTotals.SalesDocTotalsNotUpToDate();
    // end;
    // trigger OnAfterGetCurrRecord()
    // var
    //     TotalDiscAmt: Decimal;
    //     SalesHeader: Record "Sales Header";
    // begin
    //     SalesHeader.SetFilter("Document Type", Format(Rec."Document Type"));
    //     SalesHeader.SetFilter("No.", Rec."Document No.");
    //     if SalesHeader.FindFirst() then
    //         if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
    //             SalesHeader."Invoice Discount Value" += Rec."Unit Price";
    //             SalesHeader.Modify(false);
    //             InvoiceDiscountAmount := SalesHeader."Invoice Discount Value";
    //         end;
    // end;
}
