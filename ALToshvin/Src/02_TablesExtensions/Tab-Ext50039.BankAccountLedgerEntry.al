tableextension 50039 "Bank Account Ledger Entry" extends "Bank Account Ledger Entry"
{
    fields
    {

        //TBC-1000 --->
        field(50000; "Comment"; Text[250])
        {
            Caption = 'Comment';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        //TBC-1000 <---
        //TBC-905 --->
        field(50001; "Beneficiary Name"; Text[100])
        {
            Caption = 'Beneficiary Name';
            DataClassification = ToBeClassified;
        }
        //TBC-905 <---

        //TBc-947 --->
        field(50002; "UTR/Cheque No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        //TBC-947 <---
    }
}
