pageextension 50119 "Purchase Cr Memo Subform Ext" extends "Posted Purch. Cr. Memo Subform"
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