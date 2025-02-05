pageextension 50204 "Assembly BOM Ext" extends "Assembly BOM"
{
    layout
    {
        addafter("Quantity per")
        {
            field("Discount %"; Rec."Discount %")
            {
                Caption = 'Discount %';
                ApplicationArea = All;
            }
        }
    }
}
