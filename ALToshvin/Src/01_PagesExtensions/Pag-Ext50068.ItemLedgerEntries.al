pageextension 50068 "Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                Caption = 'Customer PO#';
            }
        }
    }
}
