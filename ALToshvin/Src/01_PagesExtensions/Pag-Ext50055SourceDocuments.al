pageextension 50055 "Source Documents" extends "Source Documents"
{
    layout
    {
        addafter("Source Document")
        {
            field("Sales Type"; Rec."Sales Type")
            {
                ApplicationArea = All;
                Caption = 'Sales Type';
                Editable = false;
            }
        }
    }
}