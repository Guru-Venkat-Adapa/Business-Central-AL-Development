pageextension 50110 "Sales Invoice SubForm Ext" extends "Posted Sales Invoice Subform"
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