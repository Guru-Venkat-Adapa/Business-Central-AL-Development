pageextension 50122 "Sales Order Page Ext" extends "Sales Order"
{
    layout
    {
        modify("Customer Type")
        {
            ShowMandatory = true;
        }
        modify("Referral Source")
        {
            ShowMandatory = true;
        }
        // addafter("Order Margin")
        // {
        //     field("Sales Order Margin"; Rec."Sales Order Margin")
        //     {
        //         ApplicationArea = all;
        //         Caption = 'Sales Order Margin';
        //         ToolTip = ' ';
        //     }
        // }

    }
    actions
    {
        modify(PostPrepaymentInvoice)
        {
            Caption = 'Post Invoice';
            Promoted = true;
            PromotedOnly = true;
            PromotedCategory = Process;
        }
        modify(PagePostedSalesPrepaymentInvoices)
        {
            Caption = 'Payment Invoice';
            Promoted = true;
            PromotedOnly = true;
            PromotedCategory = Process;
        }
    }
}
