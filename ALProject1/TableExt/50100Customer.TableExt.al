tableextension 50100 "Customer Ext" extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Bonuses"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("bonus Header" where("Customer No." = field("No.")));
            Editable = false;
            Caption = 'Bonuses';
        }
        field(50101; "Customer Category SDM"; Code[20])
        {
            Caption = 'Customer Category SDM';
            TableRelation = "Customer Category";
           // ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(50102;CusToSoData;Text[100])
        {
            Caption='Cus to SO data';
            DataClassification=CustomerContent;
        }
    }
    var
        x: Label 'You cannot delete Customer %1 because there is at least one Bonus assigned.';

    trigger OnBeforeDelete()
    var
        a: Record "bonus Header";
    begin
        a.SetRange("Customer No.", "No.");
        if not a.IsEmpty() then
            Error(x, "No.");
    end;
}