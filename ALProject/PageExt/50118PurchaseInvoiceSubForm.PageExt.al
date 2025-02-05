pageextension 50118 "Purchase Invoice Subform Ext" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Temp TextLine"; Rec."Temp TextLine")
            {
                Caption = 'Temp TextLine';
                ApplicationArea = All;
            }
        }
    }
}