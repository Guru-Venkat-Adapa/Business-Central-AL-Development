pageextension 50150 PaymentJournalExt extends "Payment Journal"
{
    layout
    {
        addafter("Creditor No.")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Show related sales Order No.';
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