pageextension 50044 "Posted Whse. Shipment Ext" extends "Posted Whse. Shipment"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        addbefore("Whse. Shipment No.")
        {
            field("Sales Type"; Rec."Sales Type")
            {
                Caption = 'Sales Type';
                ApplicationArea = All;
                ShowMandatory = true;
                Editable = false;
            }
        }
        addlast(General)
        {
            field("Requisition Purpose"; Rec."Requisition Purpose")
            {
                ApplicationArea = All;
                Caption = 'Requisition Purpose';
                Editable = false;
            }
            field("Part Requisition Form"; Rec."Part Requisition Form")
            {
                ApplicationArea = All;
                Caption = 'Part Requisition Form';
                Editable = false;
            }
            field("Expected RDC Return Date"; Rec."Expected RDC Return Date")
            {
                ApplicationArea = All;
                Caption = 'Expected RDC Return Date';
                Editable = false;
            }
            //TBC-973 --->
            field("Party PO Received Date"; Rec."Party PO Received Date")
            {
                ApplicationArea = All;
                Caption = 'Party PO Received Date';
                Editable = false;
            }
            //TBC-973 <---
        }
    }
}
