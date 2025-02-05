tableextension 50100 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        // field(50100; InvoiceAmt; Decimal)
        // {
        //     Caption = 'Invoice Amount';
        //     FieldClass = FlowField;
        //     CalcFormula = sum("Sales Invoice Line"."Line Amount" where("Order No." = field("No.")));
        // }
        // field(50101; BalanceAmt; Decimal)
        // {
        //     Caption = 'Balance Amount';
        // }
        // field(50102; TotalAmt; Decimal)
        // {
        //     Caption = 'Total Amount';
        //     FieldClass = FlowField;
        //     CalcFormula = sum("Sales Line"."Amount Including VAT" where("Document No." = field("No.")));
        // }
        field(5100; TotalUnitcost; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5101; TotalAmount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5102; TotalUnitPricetoSell; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5103; "Order Margin"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        test: Record "Sales Line";
        Sales: Page "Sales Order Subform";
}
