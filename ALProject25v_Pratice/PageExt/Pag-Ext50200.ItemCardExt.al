pageextension 50205 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("Last Trans Posting date"; Rec."Last Trans Posting date")
            {
                ApplicationArea = All;
                Caption = 'Last Transaction Posting date';
            }
        }
    }
}
