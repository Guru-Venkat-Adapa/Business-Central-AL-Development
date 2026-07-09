pageextension 50065 "Sales Invoice Extension" extends "Sales Invoice"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;

            }
        }
        modify("Sell-to Contact No.")
        {
            Visible = false;
        }
        modify(SellToMobilePhoneNo)
        {
            Visible = false;
        }
        modify("Sell-to Contact")
        {
            Caption = 'Contact Name (Kind Attn.)';
        }
        modify(SellToPhoneNo)
        {
            Visible = false;
        }
        modify(SellToEmail)
        {
            Visible = false;
        }
        addafter("Sell-to Country/Region Code")
        {
            field("Sell-to Phone No."; Rec."Sell-to Phone No.")
            {
                ApplicationArea = All;
            }
            field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
            {
                ApplicationArea = All;
            }
        }
        addafter("No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = All;
                Caption = 'Sales Order Type';
                Editable = false;
            }
        }
        modify("External Document No.")
        {
            Caption = 'Customer PO No.';
        }
        addafter("External Document No.")
        {
            field("Customer PO Date"; Rec."Customer PO Date")
            {
                ApplicationArea = All;
                Caption = 'Customer PO Date';
            }
            //TBC-973 -->
            field("Party PO Received Date"; Rec."Party PO Received Date")
            {
                Caption = 'Party PO Received Date';
                ApplicationArea = All;
            }
            //TBC-973 <--
        }
        moveafter("Customer PO Date"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        modify("Shortcut Dimension 1 Code")
        {
            ShowMandatory = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            ShowMandatory = true;
        }
        addafter("Shortcut Dimension 2 Code")
        {
            group("TeamsCode")
            {
                Caption = '';
                Visible = not Rec."Instrument Order";

                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Teams Code';
                    ToolTip = 'Specifies the value of the Teams Code field.';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
            }
        }
        modify("Charge Group Code")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("VAT Reporting Date")
        {
            Visible = false;
        }
        addafter("Exclude GST in TCS Base")
        {
            group("")
            {
                Caption = '';
                Visible = Rec."GST Customer Type" = Rec."GST Customer Type"::"SEZ Unit";

                field("SEZ Instruction"; Rec."SEZ Instruction")
                {
                    ApplicationArea = All;
                    Caption = 'SEZ Instruction';
                }
            }
        }
    }

    actions
    {
        addafter("Update Reference Invoice No.")
        {
            //TBC-892 --->
            action("Update GST Ship to State")
            {
                ApplicationArea = All;
                Caption = 'Update GST Ship to State Code';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ShipToAddress: Record "Ship-to Address";
                begin
                    // Validate document
                    if (Rec."No." = '') or
                       (Rec."Document Type" <> Rec."Document Type"::Invoice) or
                       (Rec."Ship-to Code" = '') then
                        exit;

                    // Update only if GST Ship-to State Code is blank
                    if not Confirm('Do you want to update GST Ship-to State Code for this invoice?', false) then
                        exit;

                    if Rec."GST Ship-to State Code" = '' then begin
                        if ShipToAddress.Get(Rec."Sell-to Customer No.", Rec."Ship-to Code") then begin
                            if ShipToAddress.State <> '' then begin
                                Rec."GST Ship-to State Code" := ShipToAddress.State;
                                Rec.Modify(false);
                                Message('GST Ship-to State Code updated successfully.');
                            end;
                        end;
                    end;
                end;
            }
            //TBC-892 <---
        }
    }
}
