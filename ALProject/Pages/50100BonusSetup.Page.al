page 50100 "Bonus Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Bonus Setup";
    Caption = 'Bonus Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Bonus No."; Rec."Bonus No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Bonus No.';
                    Caption = 'Bonus No.';
                }
            }
        }
    }
    trigger OnOpenPage()

    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            rec.Insert();
        end;
    end;
}