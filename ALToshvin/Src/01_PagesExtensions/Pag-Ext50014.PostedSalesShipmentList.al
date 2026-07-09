pageextension 50014 PostedSalesShipmentList extends "Posted Sales Shipments"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        addafter("No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order Type field.';
            }
        }
        modify("External Document No.")
        {
            Caption = 'Customer PO No.';
        }
    }
}
