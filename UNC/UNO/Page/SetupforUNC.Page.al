page 50101 "Setup for UNC"
{
    ApplicationArea = All;
    Caption = 'Setup Page for UNC';
    PageType = Card;
    SourceTable = NoSeriesSetup;
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Fund Nos."; Rec."Fund No.")
                {
                    Caption = 'Fund Transfer No.';
                    ToolTip = 'Specifies the value of the Custom Fund Nos. field.';
                }
                field("Fund Transfer line No."; Rec."Fund Transfer Line No.")
                {
                    Caption = 'Fund Transfer Subform Line No.';
                    ToolTip = 'Specifies the value of the Fund Document No. field.';
                }
                // field("Fund-Project No."; Rec."Fund-Project No.")
                // {
                //     ToolTip = 'Specifies the value of the Fund-Project No. field.';
                // }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.FindSet() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
