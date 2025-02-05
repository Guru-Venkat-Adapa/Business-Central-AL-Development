tableextension 50203 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        field(50200; "Custom Quantity"; Decimal)
        {
            Caption = 'Custom Quantity';
            DataClassification = CustomerContent;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                If Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                    Rec.Validate("Qty. to Receive");
            end;
        }
        modify("Qty. to Receive")
        {
            trigger OnAfterValidate()
            begin
                If Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                    If (Rec.Quantity = rec."Qty. to Receive") then
                        rec."Custom Quantity" := Rec.Quantity
                    else
                        Rec."Custom Quantity" := Rec."Custom Quantity" - Rec."Qty. to Receive";
            end;
        }
    }
}
