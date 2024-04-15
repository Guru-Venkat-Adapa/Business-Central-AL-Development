/// <summary>
/// PageExtension SCB 790 Order Role Center Ext. (ID 50001) extends Record Order Processor Role Center.
/// </summary>
pageextension 50103 "SCB 790 Order Role Center Ext." extends "Order Processor Role Center"
{
    layout
    {
    }

    actions
    {
        addlast(Creation)
        {
            action("SCB Subscription Order")
            {
                RunObject = page "Subscription Order";
                RunPageMode = Create;
                ApplicationArea = All;
                Image = NewOrder;
                Caption = 'Subscription Order';
                ToolTip = 'Subscription Order';
            }
        }
        addlast(Embedding)
        {
            action("SCB Subscription List")
            {
                RunObject = page "Subscription List";
                RunPageMode = View;
                ApplicationArea = All;
                Image = BlanketOrder;
                Caption = 'Subscription List';
                ToolTip = 'Subscription List';

            }
        }
    }

}