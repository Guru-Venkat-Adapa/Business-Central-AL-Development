page 50102 "No. Series Setup MRS Header"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "No. Series Setup MRS Header";
    Caption = 'MRS Header No. Series Setup';
    // InsertAllowed = false;
    // DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies which no. series is been used';
                    Caption = 'No. Series';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if rec.IsEmpty() then
            Rec.Insert();
    end;
}