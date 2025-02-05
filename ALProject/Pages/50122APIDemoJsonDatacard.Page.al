page 50122 DemoJsondataCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Demojsontable;
    Caption = 'Demo Json Data Card';

    layout
    {
        area(Content)
        {
            group(Control)
            {
                field(id; Rec.id)
                {
                    ApplicationArea = All;
                    Caption = 'Id';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Username; Rec.Username)
                {
                    Caption = 'User Name';
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                }
                field(Phno; Rec.Phno)
                {
                    Caption = 'Phone Number';
                    ApplicationArea = All;
                }
                field(Street; Rec.Street)
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field(Pincode; Rec.Pincode)
                {
                    Caption = 'Pin Code';
                    ApplicationArea = All;
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