page 50002 "Application Master"
{
    ApplicationArea = All;
    Caption = 'Application Master';
    PageType = List;
    SourceTable = Application;
    RefreshOnActivate = true;
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application Description"; Rec."Application Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application Description field.';
                }
            }
        }
    }
}
