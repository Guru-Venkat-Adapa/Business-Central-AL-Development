pageextension 50067 "Posted Sales Inv. - Update" extends "Posted Sales Inv. - Update"
{
    layout
    {
        addbefore("Shipping Agent Code")
        {
            field("Ship-to Name"; Rec."Ship-to Name")
            {
                ApplicationArea = All;
            }
            field("Ship-to Address"; Rec."Ship-to Address")
            {
                ApplicationArea = All;
            }
            field("Ship-to Address 2"; Rec."Ship-to Address 2")
            {
                ApplicationArea = All;
            }
            field("Ship-to City"; Rec."Ship-to City")
            {
                ApplicationArea = All;
            }
            field("Ship-to County"; Rec."Ship-to County")
            {
                ApplicationArea = All;
            }
            field("Ship-to Post Code"; Rec."Ship-to Post Code")
            {
                ApplicationArea = All;
            }
            field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
            {
                ApplicationArea = All;
            }
            field("Ship-to Contact"; Rec."Ship-to Contact")
            {
                ApplicationArea = All;
            }
            field("Ship-to Phone No."; Rec."Ship-to Phone No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
