pageextension 50003 ExtVendorCard extends "Vendor Card"
{
    layout
    {
        addafter("No.")
        {
            field("Focus Vendor No."; Rec."Focus Vendor No.")
            {
                ApplicationArea = All;
                Caption = 'Focus Vendor No.';
            }
            field("CRM Vendor No."; Rec."CRM Vendor No.")
            {
                ApplicationArea = ALL;
                ToolTip = 'Specifies the value of the CRM Vendor No. field.';
                Visible = false;
            }
        }
        addlast(General)
        {
            field("Is MSME"; Rec."Is MSME")
            {
                ApplicationArea = All;
                Caption = 'IS MSME';
                ToolTip = 'Specifies the value of the is MSME field.';
            }
            group(MSME)
            {
                Caption = '';
                Visible = Rec."Is MSME";
                field("MSME No"; Rec."MSME No")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'MSME NO';
                    ToolTip = 'Specifies the value of the MSME number field.';
                }
            }
        }
    }
}
