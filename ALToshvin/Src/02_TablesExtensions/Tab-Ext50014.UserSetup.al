namespace Toshvin.Toshvin;

using System.Security.User;

tableextension 50014 "User Setup" extends "User Setup"
{
    fields
    {
        field(50000; "Permission"; Boolean)
        {
            Caption = 'Employee Admin';
            DataClassification = ToBeClassified;
        }
        field(50001; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            //TableRelation = "Location";
        }
        //TBC-987 ---->
        field(50002; "Posting Permission"; Boolean)
        {
            Caption = 'Posting Permission';
            DataClassification = ToBeClassified;
        }
        //TBC-987 <----

        //TBC-1063 ---->
        field(50003; "Net Margin Permission"; Boolean)
        {
            Caption = 'Net Margin Permission';
            DataClassification = ToBeClassified;
        }
        //TBC-1063 <----

        //TBC-1071 --->
        field(50004; "Release/Reopen"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Release/Reopen';
        }
        //TBC-1071 <---
    }
}
