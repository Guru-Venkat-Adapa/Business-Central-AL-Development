pageextension 50111 "Sales Credit Memo SubForm Ext" extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Text Line"; Rec."Text Line")
            {
                Caption = 'Text For Line';
                ApplicationArea = All;
            }
        }
    }
}