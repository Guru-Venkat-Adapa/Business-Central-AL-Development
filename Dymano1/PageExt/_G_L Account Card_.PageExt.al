pageextension 50104 "G/L Account Card" extends "G/L Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Tax Group Code")
        {
            field("Tax Liable"; Rec."Tax Liable")
            {
                ApplicationArea = all;
                Caption = 'Tax Liable';
                ToolTip = 'Tax Liable';
                Editable = true;
            }
        }
    }
}
