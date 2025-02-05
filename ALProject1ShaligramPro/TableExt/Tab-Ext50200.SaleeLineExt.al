tableextension 50200 "Salee Line Ext" extends "Sales Line"
{
    fields
    {
        field(50200; "Item Margins"; Decimal)
        {
            Caption = 'Item Margin';
            DataClassification = CustomerContent;
        }

    }
}
