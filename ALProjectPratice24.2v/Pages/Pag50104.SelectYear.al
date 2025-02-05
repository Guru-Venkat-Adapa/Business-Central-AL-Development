page 50104 "Select Year"
{
    ApplicationArea = All;
    Caption = 'Select Year';
    PageType = List;
    SourceTable = "Date";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Period No."; Rec."Period No.")
                {
                    Caption = 'Year';
                }
            }
        }
    }
}

page 50105 "Select Month"
{
    ApplicationArea = All;
    Caption = 'Select Month';
    PageType = List;
    SourceTable = "Date";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Month; Date2DMY(Rec."Period Start", 1))
                {
                    Caption = 'Month';
                }
            }
        }
    }
}
