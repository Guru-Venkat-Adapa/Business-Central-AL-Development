tableextension 50040 "Customer Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        //TBc-947 --->
        field(50000; "UTR/Cheque No."; Code[50])
        {
            Caption = 'UTR/Cheque No.';
            DataClassification = ToBeClassified;
        }
        //TBc-947 <---

        //TBC-1010 --->
        field(50001; "Comment"; Text[250])
        {
            Caption = 'Comment';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        //TBC-1010 <---
    }
}
