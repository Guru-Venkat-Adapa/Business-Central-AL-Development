page 50104 "Weekly Status"
{
    ApplicationArea = All;
    Caption = 'Weekly Status';
    PageType = Worksheet;
    SourceTable = WeeklyReport;
    UsageCategory = Lists;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            // field("Line No."; Rec."Line No.")
            // {
            //     Caption = 'No.';
            //     ShowMandatory = true;
            // }
            field(FirstDay; Rec.FirstDay)
            {
                ToolTip = 'Specifies the value of the First Day field.', Comment = '%';
                trigger OnValidate()
                begin
                    SetDate();
                end;
            }
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(Day1; Rec.Day1)
                {
                    ToolTip = 'Specifies the value of the Day1 field.';
                    CaptionClass = '1,5,,' + Day1;
                }
                field(Day2; Rec.Day2)
                {
                    ToolTip = 'Specifies the value of the Day2 field.';
                    CaptionClass = '1,5,,' + Day2;
                }
                field(Day3; Rec.Day3)
                {
                    ToolTip = 'Specifies the value of the Day3 field.';
                    CaptionClass = '1,5,,' + Day3;
                }
                field(Day4; Rec.Day4)
                {
                    ToolTip = 'Specifies the value of the Day4 field.';
                    CaptionClass = '1,5,,' + Day4;
                }
                field(Day5; Rec.Day5)
                {
                    ToolTip = 'Specifies the value of the Day5 field.';
                    CaptionClass = '1,5,,' + Day5;
                }
                field(Day6; Rec.Day6)
                {
                    ToolTip = 'Specifies the value of the Day6 field.';
                    CaptionClass = Day6;
                }
                field(Day7; Rec.Day7)
                {
                    ToolTip = 'Specifies the value of the Day7 field.';
                    CaptionClass = '1,5,,' + Day7;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetDate();
    end;

    var
        Day1, Day2, Day3, Day4, Day5, Day6, Day7 : text[20];
        WeekStartDate: Date;

    procedure SetDate()
    begin
        Clear(Day1);
        Clear(Day2);
        Clear(Day3);
        Clear(Day4);
        Clear(Day5);
        Clear(Day6);
        Clear(Day7);
        if Rec.FirstDay <> 0D then begin
            WeekStartDate := CalcDate('<-CW>', Rec.FirstDay);
            if WeekStartDate <> 0D then begin
                Day1 := 'Monday(' + Format(WeekStartDate) + ')';
                Day2 := 'Tuesday(' + Format(CalcDate('<+1D>', WeekStartDate)) + ')';
                Day3 := 'Wednesday(' + Format(CalcDate('<+2D>', WeekStartDate)) + ')';
                Day4 := 'Thursday(' + Format(CalcDate('<+3D>', WeekStartDate)) + ')';
                Day5 := 'Friday(' + Format(CalcDate('<+4D>', WeekStartDate)) + ')';
                Day6 := 'Saturday(' + Format(CalcDate('<+5D>', WeekStartDate)) + ')';
                Day7 := 'Sunday(' + Format(CalcDate('<+6D>', WeekStartDate)) + ')';
            end;
            CurrPage.Update();
        end;
    end;
}
