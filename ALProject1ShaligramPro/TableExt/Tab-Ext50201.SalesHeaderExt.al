tableextension 50201 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50200; "Order Margin"; Decimal)
        {
            Caption = 'Order Margin';
            DataClassification = CustomerContent;
        }
        field(50201; TotalUnitcost; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50202; TotalAmount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50203; TotalBOMAmount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50204; TotalUnitCostBOMItem; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50205; TotalDiscountAmount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50206; NoOfCortons; Integer)
        {
            DataClassification = ToBeClassified;
        }
        // modify("Prices Including VAT")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         SalesLine: Record "Sales Line";
        //         TotalLineAmount: Decimal;
        //         salesOrder: Page "Sales Order Subform";
        //     begin
        //         SalesLine.Get(Rec."Document Type", Rec."No.");
        //         repeat
        //             TotalLineAmount := TotalLineAmount + SalesLine."Line Amount";
        //         until SalesLine.Next() = 0;
        //         SalesHeader.TotalDiscountAmount := Round(TotalLineAmount * salesOrder.InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
        //     end;
        // }
    }
    // var
    // code1:Codeunit 9215;
}
