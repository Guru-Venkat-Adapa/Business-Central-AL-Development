namespace Toshvin.Toshvin;

using Microsoft.Foundation.Company;

pageextension 50027 "Company Information" extends "Company Information"
{
    layout
    {
        modify("Registration No.")
        {
            Visible = false;
        }
        addafter("Registration No.")
        {
            field("CIN No."; Rec."CIN No.")
            {
                ApplicationArea = All;
            }
        }
        //TBC-1031 --->
        addafter("Company Status")
        {
            field("Shimadzu Signature"; Rec."Shimadzu Signature")
            {
                ApplicationArea = All;
                Editable = true;
                Caption = 'Shimadzu Signature';

                trigger OnValidate()
                begin
                    CurrPage.SaveRecord();
                end;
            }
            field(Shimadzu; Rec.Shimadzu)
            {
                ApplicationArea = All;
                Editable = true;
                Caption = 'Shimadzu';

                trigger OnValidate()
                begin
                    CurrPage.SaveRecord();
                end;
            }
        }
        //TBC-1031 <---
    }
}
