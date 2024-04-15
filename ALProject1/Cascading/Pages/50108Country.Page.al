page 50108 "Country Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Country Table";
    Editable = true;
    Caption = 'Country Page';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(CountryId; Rec.CountryId)
                {
                    ApplicationArea = All;
                    Caption = 'Country Id';
                    ToolTip = 'Specifie sthe id for the country';
                }
                field(CountryName; Rec.CountryName)
                {
                    ApplicationArea = All;
                    Caption = 'Country Name';
                    ToolTip = 'specifies the country name';
                }
            }
        }
        area(FactBoxes)
        {
            part(Images; "Employee Picture")
            {
                ApplicationArea = All;
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