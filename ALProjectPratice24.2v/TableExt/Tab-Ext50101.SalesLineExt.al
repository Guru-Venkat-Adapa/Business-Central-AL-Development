tableextension 50101 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        // modify(Quantity)
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         ExplodeBOM();
        //     end;
        // }
        field(5100; "Item Margins"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        DocumentTotals: Codeunit "Document Totals";
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';

    // procedure ExplodeBOM()
    // begin
    //     if Rec."Prepmt. Amt. Inv." <> 0 then
    //         Error(Text001);
    //     // CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
    //     DocumentTotals.SalesDocTotalsNotUpToDate();
    // end;
}
