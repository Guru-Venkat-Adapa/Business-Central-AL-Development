pageextension 50106 "Detailed Cust. Ledg. Entries" extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        //TBC-947 --->
        addafter("Customer No.")
        {
            field("UTR/Cheque No."; Rec."UTR/Cheque No.")
            {
                ApplicationArea = All;
                Caption = 'UTR/Cheque No.';
                Editable = false;
            }
            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
                Caption = 'Comment';
                Editable = false;
            }
        }
        //TBC-947 <---
    }
}
