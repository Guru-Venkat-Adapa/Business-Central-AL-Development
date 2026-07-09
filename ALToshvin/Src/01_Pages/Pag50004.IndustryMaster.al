page 50004 "Industry Master"
{
    ApplicationArea = All;
    Caption = 'Industry Master';
    PageType = List;
    SourceTable = Industry;
    UsageCategory = Lists;
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Industry Description"; Rec."Industry Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Industry Description field.';
                }
            }
        }
    }
}
