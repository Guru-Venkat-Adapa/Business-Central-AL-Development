tableextension 50042 "G/L Entry" extends "G/L Entry"
{
    fields
    {
        //TBC-1010 --->
        field(50041; "UTR/Cheque No."; Code[50])
        {
            Caption = 'UTR/Cheque No.';
            DataClassification = ToBeClassified;
        }
        //TBC-1010 <---
    }
}
