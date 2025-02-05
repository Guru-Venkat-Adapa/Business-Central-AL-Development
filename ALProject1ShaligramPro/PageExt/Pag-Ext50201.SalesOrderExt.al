pageextension 50201 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {
            field("Order Margin"; Rec."Order Margin")
            {
                Caption = 'Order Margin';
                ApplicationArea = All;
            }
            // field(NoOfCortons; Rec.NoOfCortons)
            // {
            //     ApplicationArea = All;
            //     Caption = 'No. Of Cartons';
            // }
        }
    }
}
