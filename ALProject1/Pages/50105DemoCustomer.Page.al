page 50105 "Demo Customer"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Demo Customer";
    Caption = 'Demo Customer';
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the id for the table and acts as a primary key ';
                    Caption = 'Id';

                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer no.';
                    Caption = 'Customer No.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name';
                    Caption = 'Customer Name';
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