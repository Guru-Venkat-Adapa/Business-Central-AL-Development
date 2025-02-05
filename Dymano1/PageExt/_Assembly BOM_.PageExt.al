pageextension 50146 "Assembly BOM" extends "Assembly BOM"
{
    layout
    {
        // Add changes to page layout here
        addafter("Quantity per")
        {
            field("Discount %"; Rec."Discount %")
            {
                ApplicationArea = ALL;
                Caption = 'Line Discount %';
            }
        }
    }
    var myInt: Integer;
}
