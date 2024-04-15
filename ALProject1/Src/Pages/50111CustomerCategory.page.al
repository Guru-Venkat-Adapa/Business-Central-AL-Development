page 50111 "Customer Category List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Customer Category";
    Caption = 'Customer Category List';
    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the no of the series';
                    Caption = 'No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Describes the name of the series';
                    Caption = 'Description';
                }
                field(Default; Rec.Default)
                {
                    ApplicationArea = All;
                    ToolTip = 'If the user does not privide any property it takes its defalut value';
                    Caption = 'Default';
                }
                field(TotalCustomerForCategory; Rec.TotalCustomerForCategory)
                {
                    ApplicationArea = All;
                    Caption = 'Total Customers For Category';
                    ToolTip = 'Specifies the customer based on its category';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Default Category")
            {
                ApplicationArea = All;
                Image = CreateForm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Default Category';
                trigger OnAction()
                var
                    CustManagement: Codeunit "Customer Management";
                begin
                    OnBeforeCreateDefaultCategoryAction(Rec);
                    CustManagement.CreateDefaultCategory();
                    OnAfterDefaultCategoryAction(Rec);
                end;
            }
        }
    }
    [IntegrationEvent(true, true)]
    local procedure OnBeforeCreateDefaultCategoryAction(var CustomerCategory: Record "Customer Category")
    begin
    end;

    [IntegrationEvent(true, true)]
    local procedure OnAfterDefaultCategoryAction(var CustomerCategory: Record "Customer Category")
    begin

    end;

    var
        info: Page "Sales Order";
}