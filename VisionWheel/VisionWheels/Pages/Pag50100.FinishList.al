namespace VisionWheels.VisionWheels;

page 50200 "Finish List"
{
    ApplicationArea = All;
    Caption = 'Finish List';
    PageType = List;
    SourceTable = "Finish ";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Importdata)
            {
                ApplicationArea = All;
                Caption = 'Import data from CSV file';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    Xmlport.Run(50200, false, true);
                end;
            }
            action(ImportCommentLine)
            {
                ApplicationArea = All;
                Caption = 'Import data from CSV file to Comment Line';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    Xmlport.Run(50201, false, true);
                    Message('Imported data into comment line successfully');
                end;
            }
        }
    }
}
