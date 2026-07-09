pageextension 50053 "Req. Worksheet" extends "Req. Worksheet"
{
    layout
    {
        modify(Quantity)
        {
            Editable = false;
        }
        addafter("Due Date")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = All;
                Caption = 'Sales Order No.';
                Editable = false;
            }
            field("Sales Order Line No."; Rec."Sales Order Line No.")
            {
                ApplicationArea = All;
                Caption = 'Sales Order Line No.';
                Editable = false;
            }

        }
    }
}
