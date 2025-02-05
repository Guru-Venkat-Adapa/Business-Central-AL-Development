page 50101 Quaterly
{
    ApplicationArea = All;
    Caption = 'Quaterly';
    PageType = Worksheet;
    SourceTable = Quater;
    UsageCategory = Administration;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(SelectQuater; Rec.SelectQuater)
                {
                    ToolTip = 'Specifies the Quater of the year.';
                    Editable = true;
                }
            }
            group(Details)
            {
                field(StartDate; Rec.StartDate)
                {
                    ToolTip = 'Specifies the Start Date of the Quater.';
                    Editable = false;
                }
                field(EndDate; Rec.EndDate)
                {
                    ToolTip = 'Specifies the End Date Of the Quater.';
                    Editable = false;
                }
            }
        }
    }
}
