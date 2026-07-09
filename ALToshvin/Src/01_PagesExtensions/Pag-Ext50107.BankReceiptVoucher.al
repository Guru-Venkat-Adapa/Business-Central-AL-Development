pageextension 50107 "Bank ReceiptVoucher" extends "Bank Receipt Voucher"
{
    layout
    {
        //TBC-947 --->
        addafter("Bal. Account No.")
        {
            field("UTR/Cheque No."; Rec."UTR/Cheque No.")
            {
                ApplicationArea = All;
                Caption = 'UTR/Cheque No.';
            }
        }
        //TBC-947 <---
    }
}
