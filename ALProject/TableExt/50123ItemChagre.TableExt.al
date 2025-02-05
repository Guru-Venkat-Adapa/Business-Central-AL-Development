tableextension 50123 "ItemChargeExt" extends "Item Charge"
{
    fields
    {
        // Add changes to table fields here
        field(50100; Item; Text[100])
        {
            Caption = 'Items';
            DataClassification = CustomerContent;
            TableRelation = Item.Description;
            ValidateTableRelation = false;
        }
        field(50101; ItemQty; Decimal)
        {
            Caption = 'ItemQty%';
            DataClassification = CustomerContent;
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

    var
        myInt: Integer;
}