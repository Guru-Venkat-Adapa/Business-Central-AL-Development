pageextension 50200 "User Card Ext" extends "User Card"
{
    layout
    {
        addlast(content)
        {
            part(IPAddress; "IP Address Permissions")
            {
                ApplicationArea = All;
                Caption = 'IP Address Permission Setup';
                SubPageLink = "User ID" = field("User Name");
            }
        }
    }
}
