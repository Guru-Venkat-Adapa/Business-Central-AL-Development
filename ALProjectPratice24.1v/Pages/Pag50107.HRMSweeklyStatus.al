page 50107 "HRMS weekly Status"
{
    ApplicationArea = All;
    Caption = 'HRMS weekly Status';
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = WeeklyTimeSheet;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(WeekStartDate; Rec.WeekStartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Select Week Date';
                }
                field(WeekEndDate; Rec.WeekEndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    trigger OnValidate()
                    begin
                        if Rec.WeekStartDate > Rec.WeekEndDate then
                            Error('End date should be greater than start date');
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GetDates)
            {
                ApplicationArea = All;
                Caption = 'Send Email';
                Promoted = true;
                PromotedCategory = Process;
                Image = Email;
                trigger OnAction()
                var
                    Code: Codeunit "HRMS Status";
                begin
                    Code.SimpleEMail(Rec);
                end;
            }
        }
    }
}
