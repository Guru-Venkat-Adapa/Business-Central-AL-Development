pageextension 50103 PurchOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Item Margins"; Rec."Item Margins")
            {
                ApplicationArea = All;
                Caption = 'Item Margins';
                ToolTip = 'Item Margins';
            }
        }
    }
}
