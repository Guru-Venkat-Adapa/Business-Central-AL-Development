pageextension 50040 "Posted Transfer Receipts Ext" extends "Posted Transfer Receipt"
{
    layout
    {
        addbefore("Transfer-from Code")
        {
            field("Sales Type"; Rec."Sales Type")
            {
                Caption = 'Sales Type';
                ApplicationArea = All;
                ShowMandatory = true;
                Editable = false;
            }
            field(Customer_Name; Rec.Customer_Name)
            {
                Caption = 'Customer Name';
                ApplicationArea = All;
                Editable = false;
            }
            //TBC-1016 --->
            field("Contact Name"; Rec."Contact Name")
            {
                ApplicationArea = All;
                Caption = 'Contact Name (Kind Attn.)';
                Editable = false;
            }
            //TBC-1016<---
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
            field("Master Sales Order No."; Rec."Master Sales Order No.")
            {
                ApplicationArea = All;
                Caption = 'Master Sales Order No.';
                Editable = false;
            }
            field("Custom Assigned User ID"; Rec."Custom Assigned User ID")
            {
                ApplicationArea = All;
                Caption = 'Custom Assigned User ID';
                Editable = false;
            }
            field("Service Persion ID"; Rec."Service Persion ID")
            {
                ApplicationArea = All;
                Caption = 'Service Person ID';
                Editable = false;
            }
        }
        //TBC-506 -->
        addafter("Shortcut Dimension 2 Code")
        {
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                CaptionClass = '1,2,3';
                ApplicationArea = All;
                Caption = 'Teams Code';
                Editable = false;
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            }
        }
        //TBC-506 <--
    }
}
