pageextension 50103 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter(ItemPicture)
        {
            part(ItemUnitofMeasure; "Item Units of Measure")
            {
                ApplicationArea = All;
                Caption = 'Item Units of Measure';
                SubPageLink = "Item No." = field("No.");
            }
        }
    }
}
