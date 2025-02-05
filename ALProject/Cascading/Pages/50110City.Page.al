page 50110 "City Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "City table";
    Editable = true;
    Caption = 'City Page';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(CityName; Rec.CityName)
                {
                    ApplicationArea = All;
                    Caption = 'City Name';
                    ToolTip = 'Specifies the name of a city';
                }
                field(state; Rec.state)
                {
                    ApplicationArea = All;
                    Caption = 'State Name';
                    ToolTip = 'Specifies the relation between city and state';
                    LookupPageId = "State Page";
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