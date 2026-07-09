tableextension 50035 "Vendor Bank Account Ext" extends "Vendor Bank Account"
{
    fields
    {
        field(50100; "IFSC Code"; Text[20])
        {
            Caption = 'IFSC Code';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
        }
        field(50001; "CIN No."; Text[21])
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Custom IFSC Code"; Text[11])
        {
            DataClassification = CustomerContent;
        }
        //TBC-905 --->
        field(50003; "Beneficiary Name"; Text[100])
        {
            Caption = 'Beneficiary Name';
            DataClassification = ToBeClassified;
        }
        //TBC-905 <---
    }
}
