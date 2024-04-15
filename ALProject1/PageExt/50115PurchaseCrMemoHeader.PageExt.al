pageextension 50115 "Purchase Credit Memo Header" extends "Posted Purchase Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter("Order Address Code")
        {
            field("Temp Text"; Rec."Temp Text")
            {
                Caption = 'Temporary Text';
                ApplicationArea = All;
            }
        }
    }
}