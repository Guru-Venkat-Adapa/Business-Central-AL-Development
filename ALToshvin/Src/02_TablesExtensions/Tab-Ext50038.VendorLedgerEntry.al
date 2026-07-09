tableextension 50038 "Vendor LedgerEntry" extends "Vendor Ledger Entry"
{
    fields
    {
        //TBC-905 ---->
        field(50000; "Beneficiary Name"; Text[100])
        {
            Caption = 'Beneficiary Name';
            DataClassification = ToBeClassified;
        }
        //TBC-905 <----
    }
}
