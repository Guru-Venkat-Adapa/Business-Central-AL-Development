tableextension 50103 "Item Ext" extends Item
{
    fields
    {
        field(60000; Item_Ledeger_Amount; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Item No." = field("No."), "Item Ledger Entry Type" = const(Purchase)));
        }
        field(60100; ItemCategoryCode; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Purchase Line" where("Document Type" = const(Order),
                                                                Type = const(Item), "Item Category Code" = field("Item Category Code")));
        }
    }
}