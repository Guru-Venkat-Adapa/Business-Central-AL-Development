tableextension 50110 "Item Ext" extends Item
{
    fields
    {
        field(50100; "Bar Code"; Media)
        {
            Caption = 'Bar Code';
            DataClassification = CustomerContent;
        }
    }
}
