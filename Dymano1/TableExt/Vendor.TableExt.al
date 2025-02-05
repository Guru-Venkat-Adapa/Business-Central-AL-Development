tableextension 50101 Vendor extends Vendor
{
    fields
    {
        field(50100; "Primary Contact Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Contact.Name where("Company No."=field("Primary Contact No.")));
        }
    }
    var Pageb: Page 7774;
}
