pageextension 50152 CustLedEntry extends "Customer Ledger Entries"
{
    layout
    {
        addbefore(Amount)
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = all;
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}