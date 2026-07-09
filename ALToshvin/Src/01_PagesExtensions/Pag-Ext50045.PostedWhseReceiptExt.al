pageextension 50045 "Posted Whse. Receipt Ext" extends "Posted Whse. Receipt"
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
            field("Carriage Name"; Rec."Carriage Name")
            {
                ApplicationArea = All;
                Caption = 'Carriage Name';
                Editable = false;
            }
            field("Mode Of Shipment"; Rec."Mode Of Shipment")
            {
                ApplicationArea = All;
                Caption = 'Mode Of Shipment';
                Editable = false;
            }
            field("Pre carriage By"; Rec."Pre carriage By")
            {
                ApplicationArea = All;
                Caption = 'Pre Carriage By';
                Editable = false;
            }
            field("Follo Number Master"; Rec."Follo Number Master")
            {
                ApplicationArea = All;
                Caption = 'Follo Number Master';
                Editable = false;
            }
            field("AWB No."; Rec."AWB No.")
            {
                ApplicationArea = All;
                Caption = 'AWB No.';
                Editable = false;
            }
            field("AWB Date"; Rec."AWB Date")
            {
                ApplicationArea = All;
                Caption = 'AWB Date';
                Editable = false;
            }
            field("Bill of Entry No."; Rec."Bill of Entry No.")
            {
                ApplicationArea = All;
                Caption = 'Bill of Entry No.';
                Editable = false;
            }
            field("Bill of Entry Date"; Rec."Bill of Entry Date")
            {
                ApplicationArea = All;
                Caption = 'Bill of Entry Date';
                Editable = false;
            }
            field("Vendor Bill No."; Rec."Vendor Bill No.")
            {
                ApplicationArea = All;
                Caption = 'Vendor Bill No.';
                Editable = false;
            }
            field("Vendor Bill Date"; Rec."Vendor Bill Date")
            {
                ApplicationArea = All;
                Caption = 'Vendor Bill Date';
                Editable = false;
            }
            field("Gross Weight"; Rec."Gross Weight")
            {
                ApplicationArea = All;
                Caption = 'Gross Weight';
                Editable = false;
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = All;
                Caption = 'Net Weight';
                Editable = false;
            }

            field("Port Code"; Rec."Port Code")
            {
                ApplicationArea = All;
                Caption = 'Port Code';
                Editable = false;
            }
        }
    }
}
