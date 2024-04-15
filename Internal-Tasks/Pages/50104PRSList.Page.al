page 50104 "PRS List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "PRS Header";
    CardPageId = "PRS Card";

    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the value of the No. field';
                }
                field("Shortcut Dim 1 Code"; Rec."Shortcut Dim 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dim 1 Code';
                    ToolTip = 'Specifies the value of Shortcut Dim 1 Code field';
                }
                field("Shortcut Dim 2 Code"; Rec."Shortcut Dim 2 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dim 2 Code';
                    ToolTip = 'Specifies the value of Shortcut Dim 2 Code field';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';
                    ToolTip = 'Specifies the value of Comment field';
                }
                field("Project Ref. No."; Rec."Project Ref. No.")
                {
                    ApplicationArea = All;
                    Caption = 'Project Ref. No.';
                    ToolTip = 'Specifies the value of Project Ref. No. field';
                }
                field("Project Stage Code"; Rec."Project Stage Code")
                {
                    ApplicationArea = All;
                    Caption = 'Project Stage Code';
                    ToolTip = 'Specifies the value of Project Stage Code field';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    ToolTip = 'Specifies the value of Document Date field';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the value of Posting Date field';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    ToolTip = 'Specifies the value of Status field';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(deleteOrphan)
            {
                ApplicationArea = All;
                Caption = 'Delete Orphan';
                Image = Delete;

                trigger OnAction()
                var
                    line: Record "PRS Line";
                begin
                    line.SetFilter(line."Documnet No.", '');
                    line.SetRange(line."Line No.", 30000);
                    if line.FindSet() then begin
                        Message('%1 %2 ', line."No.", line.Description);
                        line.DeleteAll();
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}