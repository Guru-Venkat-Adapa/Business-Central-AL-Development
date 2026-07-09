pageextension 50105 "Bank Account Ledger Entries" extends "Bank Account Ledger Entries"
{
    //TBC-990 --->
    layout
    {
        //TBC-947 --->
        addafter("Description")
        {
            field("UTR/Cheque No."; Rec."UTR/Cheque No.")
            {
                ApplicationArea = All;
                Caption = 'UTR/Cheque No.';
                Editable = false;
            }
        }
        //TBC-947 <---
        addafter("Shortcut Dimension 3 Code")
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
                Caption = 'Comment';
                Editable = false;
            }
            field(Voucher; Voucher)
            {
                ApplicationArea = All;
                Caption = 'Voucher';
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(Voucher);
        PostedNarration.Reset();
        PostedNarration.SetRange("Transaction No.", Rec."Transaction No.");
        PostedNarration.SetRange("Entry No.", 0);
        if PostedNarration.FindFirst() then
            Voucher := PostedNarration.Narration;

    end;

    var
        Voucher: Text;

        PostedNarration: Record "Posted Narration";

    //TBC-990 <---
}
