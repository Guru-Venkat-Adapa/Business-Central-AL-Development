namespace Toshvin.Toshvin;

using System.Security.User;

pageextension 50021 "User Setup" extends "User Setup"
{
    layout
    {
        addafter(PhoneNo)
        {

            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;
                Caption = 'Location Code';
                ToolTip = 'Specifies the location from where items are to be shipped. This field acts as the default location for new lines. You can update the location code for individual lines as needed.';
            }
            //TBC-987 ---->
            field("Posting Permission"; Rec."Posting Permission")
            {
                ApplicationArea = All;
                Caption = 'Posting Permission';
            }
            //TBC-987 <----

            //TBC-1063 ---->
            field("Net Margin Permission"; Rec."Net Margin Permission")
            {
                ApplicationArea = All;
                Caption = 'Net Margin Permission';
                ToolTip = 'Specifies whether the user has permission to view or modify net margin information.';
            }
            //TBC-1063 <----

            //TBC-1071 --->
            field("Realse/Reopen"; Rec."Release/Reopen")
            {
                ApplicationArea = All;
            }
            //TBC-1071 <---
        }
    }
}
