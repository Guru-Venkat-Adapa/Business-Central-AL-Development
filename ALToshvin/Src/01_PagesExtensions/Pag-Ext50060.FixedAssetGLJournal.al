pageextension 50060 "Fixed Asset G/L Journal" extends "Fixed Asset G/L Journal"
{
    layout
    {
        addafter(Description)
        {
            field("Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = All;
                Caption = 'Posting Group';
                ToolTip = 'Specifies the Posting Group for the fixed asset transaction.';
                Editable = true;
            }
        }
    }
}
