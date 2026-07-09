pageextension 50042 "Warehouse Shipment Ext" extends "Warehouse Shipment"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        addbefore("Location Code")
        {
            field("Sales Type"; Rec."Sales Type")
            {
                Caption = 'Sales Type';
                ApplicationArea = All;
                ShowMandatory = true;
            }
        }
        addlast(General)
        {
            field("Requisition Purpose"; Rec."Requisition Purpose")
            {
                ApplicationArea = All;
                Caption = 'Requisition Purpose';
            }
            field("Part Requisition Form"; Rec."Part Requisition Form")
            {
                ApplicationArea = All;
                Caption = 'Part Requisition Form';
            }
            field("Expected RDC Return Date"; Rec."Expected RDC Return Date")
            {
                ApplicationArea = All;
                Caption = 'Expected RDC Return Date';
            }
            field("Service Persion ID"; Rec."Service Persion ID")
            {
                ApplicationArea = All;
                Caption = 'Service Person ID';
            }
            field(Note; Rec.Note)
            {
                ApplicationArea = All;
                Caption = 'Note';
            }
            field("Value Declaration"; Rec."Value Declaration")
            {
                ApplicationArea = All;
                Caption = 'Value Declaration';
            }
            // Start of 957

            //TBC-973 --->
            field("Party PO Received Date"; Rec."Party PO Received Date")
            {
                ApplicationArea = All;
                Caption = 'Party PO Received Date';
            }
            //TBC-973 <---
            group(ShippingNoseries)
            {
                Caption = '';
                Visible = Rec."Shipping No. Series" = '';
                field("Shipping No. Series"; Rec."Shipping No. Series")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping No. Series';
                }
            }
            //end of 957
        }
    }
}
