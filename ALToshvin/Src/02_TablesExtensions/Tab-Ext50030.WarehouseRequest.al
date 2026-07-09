tableextension 50030 "Warehouse Request" extends "Warehouse Request"
{
    fields
    {
        field(50000; "Sales Type"; Text[100])
        {
            Caption = 'Sales Type';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Sales Order Type" WHERE("No." = FIELD("Source No.")));
        }
    }
}
