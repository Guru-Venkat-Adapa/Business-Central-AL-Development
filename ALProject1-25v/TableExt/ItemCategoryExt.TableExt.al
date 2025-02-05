tableextension 50104 "Item Category Ext" extends "Item Category"
{
    fields
    {
        field(50100; "ToatlAmount"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Purchase Line" where("Document Type" = const(Order), "Item Category Code" = field(Code)));
        }
    }
}
