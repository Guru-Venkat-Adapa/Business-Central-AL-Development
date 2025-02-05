report 50101 OriDulTriReport
{
    ApplicationArea = All;
    Caption = 'OriDulTriReport';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
