pageextension 50120 "Customer Ledger Entries Ext" extends "Customer Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Name Text"; Rec."Name Text")
            {
                ApplicationArea = All;
                Caption = 'Text For Name';
            }
        }
    }
}