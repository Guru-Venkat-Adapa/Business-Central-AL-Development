pageextension 50117 "Purchase Receipt Subform Ext" extends "Posted Purchase Rcpt. Subform"
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