pageextension 50121 "Vendor Ledger Entries Ext" extends "Vendor Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Temp Text"; Rec."Temp Text")
            {
                Caption = 'Temporary Text';
                ApplicationArea = All;
            }
        }
    }
}