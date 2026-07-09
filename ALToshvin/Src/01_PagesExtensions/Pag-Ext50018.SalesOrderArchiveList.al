pageextension 50018 SalesOrderArchiveList extends "Sales Order Archives"
{
    layout
    {
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
