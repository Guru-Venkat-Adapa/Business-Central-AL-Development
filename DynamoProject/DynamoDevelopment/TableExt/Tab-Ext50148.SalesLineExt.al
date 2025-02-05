tableextension 50148 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        // modify("Unit Price")
        // {
        //     CaptionClass = 'Unit Price Excl. GST';
        // }
        // modify("Line Amount")
        // {
        //     CaptionClass = 'Line Amount Excl. GST';
        // }
        field(50200; LineDiscountAmountCustom; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50201; OrderMargin; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50202; BundleMargin; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        // 
        // modify(Quantity)
        // {
        //     trigger OnAfterValidate()
        //     var
        //         code: Codeunit Margin;
        //     begin
        //         code.BundleMargin(Rec);
        //     end;
        // }
    }
}
