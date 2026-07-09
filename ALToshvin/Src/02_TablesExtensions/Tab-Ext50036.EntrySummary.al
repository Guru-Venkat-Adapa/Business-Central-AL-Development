tableextension 50036 "Entry Summary" extends "Entry Summary"
{
    //TBC-950 --->
    fields
    {
        field(50000; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Reservation Entry"."Creation Date" where("Source Type" = field("Table ID"), "Lot No." = field("Lot No.")));
            Editable = false;
        }
    }
    //TBC-950 ---
}
