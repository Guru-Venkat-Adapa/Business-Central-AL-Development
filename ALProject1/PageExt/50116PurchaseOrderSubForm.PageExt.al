pageextension 50116 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("Temp TextLine"; Rec."Temp TextLine")
            {
                Caption = 'Temp TextLine';
                ApplicationArea = All;
            }
        }
    }
}