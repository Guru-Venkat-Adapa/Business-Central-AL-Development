pageextension 50209 "IC General Journal Ext" extends "IC General Journal"
{
    layout
    {
        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                Rec.Amount := -Rec.Amount;
            end;
        }
        addafter(ICAccountNo)
        {
            field("Project reference"; Rec."Project reference")
            {
                ApplicationArea = All;
                Caption = 'Project Reference';
            }
        }
    }
}
