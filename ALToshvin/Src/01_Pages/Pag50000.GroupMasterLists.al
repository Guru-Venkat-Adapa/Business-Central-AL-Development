page 50000 "Group Master Lists"
{
    ApplicationArea = All;
    SourceTable = "Group Master";
    PageType = List;
    RefreshOnActivate = true;
    UsageCategory = Lists;
    Caption = 'Group Master Lists';
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Group Code"; Rec."Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Group Code field.';
                }
                field("Group Description"; Rec."Group Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Group Description field.';
                }
            }
        }
    }
}

