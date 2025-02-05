page 50112 "Free Gift List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Free Gifts";
    Caption = 'Free Gift List';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Customer Category"; Rec."Customer Category")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Category';
                    ToolTip = 'Specifies the customer based on their category';
                }
                field("item No"; Rec."item No")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the which item has the free gift';
                }
                field("Minimum Order"; Rec."Minimum Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'this specifies teh minimum number of items to order to get the free gift';
                    Caption = 'Minimum Order';
                }
                field("Gift Quantity"; Rec."Gift Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Gift Quantity';
                    ToolTip = 'Specifies the how many gifts a customer get on that item based on the category';
                    Style = Strong;
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