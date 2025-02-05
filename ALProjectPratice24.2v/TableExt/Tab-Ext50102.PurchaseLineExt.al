tableextension 50102 PurchaseLineExt extends "Purchase Line"
{
    fields
    {
        field(5100; "Item Margins"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        PurchOrder: Page "Purchase Order";
}
