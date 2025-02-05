tableextension 60000 items extends Item
{
    fields
    {
        field(60000; item_Ledeger_Amount; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Sales Amount (Actual)" where("Item No." = field("No.")));

        }
    }
}

