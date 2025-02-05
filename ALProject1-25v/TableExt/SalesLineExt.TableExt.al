tableextension 50100 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50100; Length; Decimal)
        {
            Caption = 'Length';
            DataClassification = CustomerContent;
        }
        field(50101; Width; Decimal)
        {
            Caption = 'Width';
            DataClassification = CustomerContent;
        }
    }
}
