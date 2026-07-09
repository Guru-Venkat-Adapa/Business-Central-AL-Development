pageextension 50038 "Nav Transfer Order Ext" extends "Transfer Order"
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
            }
            field(Customer_Name; Rec.Customer_Name)
            {
                Caption = 'Customer Name';
                ApplicationArea = All;
            }
            //TBC-1016 --->
            field("Contact Name"; Rec."Contact Name")
            {
                ApplicationArea = All;
                Caption = 'Contact Name (Kind Attn.)';
            }
            //TBC-1016<---
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
            field("Master Sales Order No."; Rec."Master Sales Order No.")
            {
                ApplicationArea = All;
                Caption = 'Master Sales Order No.';
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
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }

        addafter("Shortcut Dimension 2 Code")
        {
            field("Custom Assigned User ID"; Rec."Custom Assigned User ID")
            {
                ApplicationArea = All;
                Caption = 'Assigned User ID';
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            //TBC-506 --->
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = Dimensions;
                Caption = 'Teams Code';
                ToolTip = 'Specifies the value of the Teams Code field.';

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            //TBC-506 <---
        }
    }
}