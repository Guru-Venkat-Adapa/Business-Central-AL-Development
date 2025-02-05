pageextension 50100 "Customer List Ext" extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(Bonuses; Rec.Bonuses)
            {
                ToolTip = 'Shows bonuses of the cyustomer';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast(navigation)
        {
            action("Bonus")
            {
                Caption = 'Bonuses';
                ApplicationArea = All;
                Image = Discount;
                RunObject = page "Bonus List";
                RunPageLink = "Customer No." = field("No.");
            }
            action("Default Category")
            {
                Image = ChangeCustomer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                Caption = 'Default Category';
                ToolTip = 'Assigns the default category to all customers';

                trigger OnAction();
                var
                    CustManagement: Codeunit "Customer Management";
                begin
                    CustManagement.DefaultCategory();
                end;
            }
        }
    }
}