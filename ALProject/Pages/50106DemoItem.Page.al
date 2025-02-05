page 50106 "Demo Item"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Demo Item";
    Editable = true;
    Caption = 'Demo Item';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Id; rec.Id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the id for the table and acts as a primary key ';
                    Caption = 'Id';
                }
                field("Item No."; rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item no.';
                    Caption = 'Item No.';
                }
                field("Item Name"; rec."Item Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item name';
                    Caption = 'Item Name';
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