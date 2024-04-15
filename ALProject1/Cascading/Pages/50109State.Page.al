page 50109 "State Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "State Table";
    Caption = 'State Page';
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(StateName; Rec.StateName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of a state';
                    Caption = 'State name';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = All;
                    Caption = 'Country Name';
                    ToolTip = 'Specifies the relation of State and country';
                    LookupPageId = "Country Page";
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}