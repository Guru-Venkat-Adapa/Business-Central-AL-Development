pageextension 50107 "POsted Sales Credit Memo Ext" extends "Posted Sales Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter("External Document No.")
        {
            field("Name Text"; Rec."Name Text")
            {
                ApplicationArea = All;
                Caption = 'Text For Name';
            }
        }
    }
}