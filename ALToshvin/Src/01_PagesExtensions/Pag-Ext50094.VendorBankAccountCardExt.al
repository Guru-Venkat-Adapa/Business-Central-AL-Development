pageextension 50094 "Vendor Bank Account Card Ext" extends "Vendor Bank Account Card"
{
    layout
    {
        addafter("Bank Account No.")
        {
            field("IFSC Code"; Rec."Custom IFSC Code")
            {
                ApplicationArea = All;
                Caption = 'IFSC Code';
            }
            field("CIN No."; Rec."CIN No.")
            {
                ApplicationArea = All;
                Caption = 'CIN No.';
            }
        }
        //TBC-905 --->
        addafter("Transit No.")
        {
            field("Beneficiary Name"; Rec."Beneficiary Name")
            {
                ApplicationArea = All;
            }
        }
        //TBC-905 <---
    }
}
