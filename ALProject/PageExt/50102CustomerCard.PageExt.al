pageextension 50102 "Customer Card Page Ext" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Customer Category SDM"; Rec."Customer Category SDM")
            {
                Caption = 'Customer Category SDM';
                ApplicationArea = All;
            }
            field(CusToSoData; Rec.CusToSoData)
            {
                Caption = 'Cus to SO data';
                ApplicationArea = All;
                ToolTip = 'Custom Field to get data from customer to sales order based on specific customer';
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addlast("F&unctions")
        {
            action("Default Category")
            {
                Image = ChangeCustomer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                Caption = 'default Category';
                ToolTip = 'Assigns the default Category for the customers';
                trigger OnAction()
                var
                    CustManagement: Codeunit "Customer Management";
                begin
                    CustManagement.DefaultCategory(Rec."No.");
                end;
            }
        }
    }

    var
        myInt: Integer;
}