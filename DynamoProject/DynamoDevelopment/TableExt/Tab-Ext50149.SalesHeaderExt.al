tableextension 50149 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        modify("Prices Including VAT")
        {
            Caption = 'Price Including GST';
            // trigger OnAfterValidate()
            // begin
            //     if "Prices Including VAT" then
            //         Message('Price Includes GST')
            //     else
            //         Message('Price Exclusive GST');
            // end;
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'GST Bus. Posting Group';
        }
        modify("VAT Reporting Date")
        {
            Caption = 'GST Date';
        }
        modify("Amt. Ship. Not Inv. (LCY)")
        {
            Caption = 'Amount Shipped Not Invoiced (LCY) Incl. GST';
        }
        modify("Amount Including VAT")
        {
            Caption = 'Amount Including GST';
        }
        field(50200; TotalAmount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50201; TotalUnitCost; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50202; TotalQuantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50203; BundleTotalAmount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50204; BundleTotalUnitCost; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50205; BundleMargin; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        // field(50206; "Sales Order Margin"; Decimal)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = sum("Sales Line".OrderMargin where("Document No." = field("No."),
        //     "Document Type" = field("Document Type")));
        // }
    }
}
