xmlport 50101 "Import Item"
{
    Caption = 'Impost Item';
    Format = VariableText;
    TextEncoding = UTF8;
    Direction = Import;
    UseRequestPage = false;
    TableSeparator = '<NewLine>';
    schema
    {
        textelement(Control)
        {
            tableelement(Item; Item)
            {
                XmlName = 'Item';
                fieldelement(No; Item."No.") { }
                fieldelement(Description; Item.Description) { }
                fieldelement(Type; Item.Type) { }
                fieldelement(Inventory; Item.Inventory) { }
                fieldelement(BaseUnit; Item."Base Unit of Measure") { }
                fieldelement(CostIsAdjusted; Item."Cost is Adjusted") { }
                fieldelement(UnitCost; Item."Unit Cost") { }
                fieldelement(UnitPrice; Item."Unit Price") { }
                fieldelement(VendorNo; Item."Vendor No.") { }
            }
        }
    }
}