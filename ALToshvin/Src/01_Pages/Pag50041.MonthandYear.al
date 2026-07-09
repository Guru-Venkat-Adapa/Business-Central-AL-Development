page 50041 "Month and Year"
{
    ApplicationArea = All;
    Caption = 'Enter Year/Month';
    PageType = List;
    SourceTable = "Date";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Period No."; Rec."Period Name")
                {
                    ToolTip = 'Specifies the number of the period shown in the line.';
                }
            }
        }
    }
}