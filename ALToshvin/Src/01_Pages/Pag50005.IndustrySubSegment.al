page 50005 "Industry SubSegment"
{
    ApplicationArea = All;
    Caption = 'Industry SubSegment';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Industry Sub-Segment";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Industry; Rec.Industry)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Industry field.';
                }
                field("Indu Sub-Seg Description"; Rec."Indu Sub-Seg Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Industry Sub-Seg Description field.';
                }
            }
        }
    }
}
