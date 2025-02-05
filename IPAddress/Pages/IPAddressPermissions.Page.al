page 50200 "IP Address Permissions"
{
    ApplicationArea = All;
    Caption = 'IP Address Pernissions';
    PageType = ListPart;
    SourceTable = "IP Address Data";
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("IP Address"; Rec."IP Address")
                {
                    ToolTip = 'Specifies the value of the IP Address field of the devices.';
                    Caption = 'IP Address';
                }
                field("Device Name"; Rec."Device Name")
                {
                    ToolTip = 'Specifies the Device Name of the IP Address where the user tries to login';
                    Caption = 'Device Name';
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User field.';
                    Caption = 'User';
                    Editable = false;
                }
            }
        }
    }
}
