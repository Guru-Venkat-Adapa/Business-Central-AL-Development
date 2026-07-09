pageextension 50039 "Posted Transfer Shipment Exts" extends "Posted Transfer Shipment"
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
            field("Service Persion ID"; Rec."Service Persion ID")
            {
                ApplicationArea = All;
                Caption = 'Service Person ID';
                Editable = false;
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
        //TBC-506 -->
        addafter("Shortcut Dimension 2 Code")
        {
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                CaptionClass = '1,2,3';
                Editable = false;
                ApplicationArea = Dimensions;
                Caption = 'Teams Code';
                ToolTip = 'Specifies the value of the Teams Code field.';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            }
        }
        //TBC-506 <--
    }
    actions
    {
        modify("&Print")
        {
            Visible = false;
        }
        addafter("&Print")
        {
            action("CustomPrint")
            {
                ApplicationArea = All;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    TransShptHeader: Record "Transfer Shipment Header";
                begin
                    TransShptHeader.Reset();
                    TransShptHeader.SetRange("No.", Rec."No.");
                    if TransShptHeader.FindFirst() then
                        Report.RunModal(Report::"Posted Transfer Shipment", true, false, TransShptHeader);
                end;
            }
        }
    }
}
