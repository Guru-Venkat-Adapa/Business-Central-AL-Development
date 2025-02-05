pageextension 50117 "Sales Quote Ext" extends "Sales Quote"
{
    layout
    {
        addafter(Status)
        {
            field("Order Margin"; Rec."Order Margin")
            {
                Caption = 'Quote Margin';
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Gross Profit")
        {
            Editable = false;
        }
    }
}
