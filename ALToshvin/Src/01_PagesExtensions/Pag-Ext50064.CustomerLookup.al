pageextension 50064 "Customer Lookup" extends "Customer Lookup"
{
    layout
    {
        addafter("No.")
        {
            field("Focus Customer No."; Rec."Focus Customer No.")
            {
                ApplicationArea = All;
                Caption = 'Focus Customer No.';
                ToolTip = 'Specifies the Focus Customer No. field.';
            }
        }
    }
}
