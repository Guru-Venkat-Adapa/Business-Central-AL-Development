tableextension 50130 "Sales Line" extends "Sales Line"
{
    fields
    {
        field(50100; "Item Margins"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50110; "Explode Bundle"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
    // Add changes to keys here
    }
    fieldgroups
    {
    // Add changes to field groups here
    }
}
