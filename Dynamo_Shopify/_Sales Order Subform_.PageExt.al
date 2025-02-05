pageextension 50121 "Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Line Discount %")
        {
            field("Item Margins"; Rec."Item Margins")
            {
                Caption = 'Item Margins';
                ToolTip = 'Item Margins';
                Editable = false;
                ApplicationArea = all;
            }
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                ExplodeBOM();
            end;
        }
    }
    var ErrText001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
}
