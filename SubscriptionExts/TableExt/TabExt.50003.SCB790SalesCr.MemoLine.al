/// <summary>
/// TableExtension SCB 790 Sales Cr.Memo Line (ID 50003) extends Record Sales Cr.Memo Line //115.
/// </summary>
tableextension 50003 "SCB 790 Sales Cr.Memo Line" extends "Sales Cr.Memo Line" //115
{
    fields
    {
        field(6082669; "SCB Subscription No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Subscription No.';
            TableRelation = "Sales Header"."No." where("Document Type" = const("Blanket Order"), "SCB Blanket Order Type" = const("Subscription order"));
        }
        field(6082670; "SCB Subscription Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Subscription Line No.';
        }
        field(6082677; "SCB Subscription Info"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Subscription Info';
        }
        field(6083562; "SCB Blanket Order Type"; enum "SCB 790 Blanket Order Type")
        {
            Editable = false;
            Caption = 'Blanket Order Type';
            DataClassification = CustomerContent;
        }
    }
}
