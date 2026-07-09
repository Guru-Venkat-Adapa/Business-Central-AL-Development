page 50003 "Application Subsegement Master"
{
    ApplicationArea = All;
    Caption = 'Application Sub-Segement Master';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Application Sub-Segment";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Application; Rec.Application)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application field.';
                }
                field("App Sub-Seg Description"; Rec."App Sub-Seg Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the App Sub-Seg Description field.';
                }
            }
        }
    }
}
