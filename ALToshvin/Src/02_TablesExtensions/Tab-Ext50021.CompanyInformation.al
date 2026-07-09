namespace Toshvin.Toshvin;

using Microsoft.Foundation.Company;

tableextension 50021 "Company Information" extends "Company Information"
{
    fields
    {
        field(50000; "Synch API"; Boolean)
        {
            Caption = 'Synch API';
            DataClassification = ToBeClassified;
        }
        field(50001; "CIN No."; Text[21])
        {
            Caption = 'CIN No.';
            DataClassification = ToBeClassified;
        }
        //TBC-1031 --->
        field(50002; "Shimadzu Signature"; BLOB)
        {
            DataClassification = CustomerContent;

            SubType = Bitmap;

            trigger OnValidate()
            begin
                PictureUpdated := true;
            end;
        }
        field(50003; "Shimadzu"; BLOB)
        {
            DataClassification = CustomerContent;

            SubType = Bitmap;

            trigger OnValidate()
            begin
                PictureUpdated := true;
            end;
        }
        //TBC-1031 <---
    }
    var
        PictureUpdated: Boolean;
}

