pageextension 50208 "Bank Account Card Ext" extends "Bank Account Card"
{
    layout
    {
        addafter("Payment Export Format")
        {
            field("Company Releated"; Rec."Company Releated")
            {
                ApplicationArea = All;
                Caption = 'Company Information';
            }
        }
    }
}
