pageextension 50010 PostedSalesInvoice extends "Posted Sales Invoice"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
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
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Your Reference")
        {
            Visible = false;
        }
        modify("VAT Reporting Date")
        {
            Visible = false;
        }
        modify("Salesperson Code")
        {
            Visible = false;
        }
        addbefore("Work Description")
        {
            field("Custom Assigned User ID"; Rec."Custom Assigned User ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the ID of the user who is responsible for the document.';
            }
        }
        addafter("Custom Assigned User ID")
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
        addlast(General)
        {
            group(GroupMaster)
            {
                Visible = Rec.ORCInstrument;
                Caption = '';
                field("Group Master"; Rec."Group Master")
                {
                    ApplicationArea = All;
                    Caption = 'Group Master (Customer)';
                    ToolTip = 'Specifies the value of the group master field.';
                }
            }
            //start of ticket no.- 918 on 30/03/26
            field("Deemed Export"; Rec."Deemed Export")
            {
                ApplicationArea = All;
                Caption = 'Deemed Export';
                ToolTip = 'Specifies the value of the Deemed Export field.';
                Editable = false;
            }
            group(DeemedExport)
            {
                Caption = '';
                Visible = Rec."Deemed Export" = true;
                field("Deemed Export Instruction"; Rec."Deemed Export Instruction")
                {
                    ApplicationArea = All;
                    Caption = 'Deemed Export Instruction';
                    ToolTip = 'Specifies the value of the Deemed Export Instruction field.';
                    Editable = false;
                }
            }
            // end of ticket no.- 918
        }
        addafter(General)
        {
            group(Service)
            {
                Caption = 'Service';
                Visible = AMCAMCVisible;
                field("CMC_Service Type"; Rec."Service_Type_")
                {
                    ApplicationArea = All;
                    Caption = 'Service Type';

                }
                field("CMC_Service Description"; Rec."Service Description")
                {
                    ApplicationArea = All;
                    Caption = 'Service Description';
                    MultiLine = true;
                }
                field("CMC_No. of Visit"; Rec."No. of Visit")
                {
                    ApplicationArea = All;
                    Caption = 'No. of Visits';
                }
                field("CMC_Visit Date"; Rec."Visit Date")
                {
                    ApplicationArea = All;
                    Caption = 'Visit Date';
                }
                field("CMC_Invoice Term"; Rec."Invoice Term")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Term';
                }
                field("Service Executive Master"; Rec."Executive Master")
                {
                    ApplicationArea = All;
                    Caption = 'Service Person ID';
                    ToolTip = 'Specifies the value of the Service Person ID field.';
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract From';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract To';
                }
            }
        }

        addafter("No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order Type field.';
            }
        }
        addafter("Ship-to Country/Region Code")
        {
            field("Ship to Industry Caregory"; Rec."Ship to Industry Caregory")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ship-to Industry Category field.';
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
                ToolTip = 'Specifies the value of the Customer PO Date field.';
            }
            //TBC-973 -->
            field("Party PO Received Date"; Rec."Party PO Received Date")
            {
                Caption = 'Party PO Received Date';
                ApplicationArea = All;
                Editable = false;
            }
            //TBC-973 <--
        }
        addafter(General)
        {
            group("Spares")
            {
                Caption = 'Spares';
                ///Visible = Rec."Sales Order Type" = 'Spares/Tools Order';
                Visible = Rec."Spare Order";
                group("SpareGeneral")
                {
                    Caption = '';

                    field("CRM Quote No."; Rec."CRM Quote No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = 'CRM Quote No.';
                        ToolTip = 'Specifies the value of the CRM Quote No. field.';
                    }
                    field("Quotation Date"; Rec."Quotation Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Quotation Date field.';
                    }
                    field("Reference Number"; Rec."Reference Number")
                    {
                        ApplicationArea = All;
                        Caption = 'Reference Number';
                        ToolTip = 'Specifies the value of the Reference Number field.';
                    }
                    field("Delivery Term"; Rec."Delivery Term")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Delivery Term';
                        ToolTip = 'Specifies the value of the Delivery Term field.';
                    }
                    field("Freight Terms"; Rec."Freight Terms")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Freight Term';
                        ToolTip = 'Specifies the value of the Freight Terms field.';
                    }
                }
                group(SpareGeneral1)
                {
                    Caption = '';
                    field("Spare_Executive Master"; Rec."Executive Master")
                    {
                        ApplicationArea = All;
                        Caption = 'Service Person ID';
                        ToolTip = 'Specifies the value of the Service Person ID field.';
                    }
                    field("CRM Employee ID 2"; Rec."CRM Employee ID 2")
                    {
                        ApplicationArea = All;
                        Caption = 'Authorized Person ID';
                        ToolTip = 'Specifies the value of the CRM Employee ID 2 field.';
                    }

                    field("RDC No"; Rec."RDC No")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'RDC No.';
                        ToolTip = 'Specifies the value of the RDC No. field.';
                    }
                    field("RDC Date"; Rec."RDC Date")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'RDC Date';
                        ToolTip = 'Specifies the value of the RDC Date field.';
                    }
                }
                group(SpareGenrral2)
                {
                    Caption = '';
                    field("Key/Non-Key"; Rec."Key/Non-Key")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Key/Non-Key field.';
                    }
                    field("KEY/NON KEY(Principal Wise)"; Rec."KEY/NON KEY(Principal Wise)")
                    {
                        ApplicationArea = All;
                        Caption = 'KEY/NON KEY(Principal Wise)';
                        ToolTip = 'Specifies the value of the KEY/NON KEY(Principal Wise) field.';
                    }

                    field("Advance Rec. Amt."; Rec."Advance Rec. Amt.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Advance Rec. Amt. field.';
                        DecimalPlaces = 2;
                        Editable = false;
                    }
                    field("Approval Ref"; Rec."Approval Ref")
                    {
                        ApplicationArea = All;
                        Caption = 'Approval Reference';
                        ToolTip = 'Specifies the value of the Approval Reference field.';
                    }
                    field("Special Instruction"; Rec."Special Instruction")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Special Instruction';
                        ToolTip = 'Specifies the value of the Special Instruction field.';
                        MultiLine = true;
                    }
                    field("Special Remark-Sez"; Rec."Special Remark-Sez")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Special Remark-Sez';
                        ToolTip = 'Specifies the value of the Special Remark-Sez field.';
                        MultiLine = true;
                    }
                    field("Discount Type"; Rec."Discount Type")
                    {
                        ApplicationArea = All;
                        Caption = 'Discount Type';
                        ToolTip = 'Specifies the value of the Discount Type field.';
                    }
                }
            }
            group(Instrument)
            {
                Caption = 'General-2';
                Visible = Rec."Instrument Order";
                group("Instrument1")
                {
                    Caption = '';

                    field("CRM No."; Rec."CRM Quote No.")
                    {
                        Caption = 'CRM No.';
                        ApplicationArea = All;

                    }


                    field("Business Sector"; Rec."Business Sector")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Business Sector';
                        ToolTip = 'Specifies the value of the Business Sector field.';
                    }
                    field("Inr. Special Instruction"; Rec."Special Instruction")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Packing & Forwarding field.';
                        Caption = 'Any Specific Instructions';
                        MultiLine = true;
                    }
                    field("Service Remark"; Rec."Service Remark")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Service Remark field.';
                        MultiLine = true;
                    }
                }
                group(ExecutiveMaster)
                {
                    Caption = 'Executive Master';
                    field("Executive Master"; Rec."Executive Master")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 1';
                        ToolTip = 'Specifies the value of the executive masater field.';

                    }
                    field("Share Of Exe Master"; Rec."Share Of Exe Master")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 1%';
                        ToolTip = 'Specifies the value of the share of Executive Master 1 field.';

                    }
                    field("Executive Master2"; Rec."Executive Master2")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 2';
                        ToolTip = 'Specifies the value of the Executive Master 2 field.';

                    }
                    field("Share Of Exe Master2"; Rec."Share Of Exe Master2")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 2%';
                        ToolTip = 'Specifies the value of the share of Executive Master 2% field.';

                    }
                    field("Executive Master3"; Rec."Executive Master3")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 3';
                        ToolTip = 'Specifies the value of the Executive Master 3 field.';

                    }
                    field("Share Of Exe Master3"; Rec."Share Of Exe Master3")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 3%';
                        ToolTip = 'Specifies the value of the share of Executive Master 3% field.';

                    }
                    field("Executive Master4"; Rec."Executive Master4")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Mater 4';
                        ToolTip = 'Specifies the value of the Executive Master 4 field.';

                    }
                    field("Share Of Exe Master4"; Rec."Share Of Exe Master4")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 4%';
                        ToolTip = 'Specifies the value of the share of Executive Master 4% field.';

                    }
                }
            }
            group(Claim)
            {
                Caption = 'Claim';
                Visible = Rec."Claim Order";
                field("SHI Claim No"; Rec."SHI Claim No")
                {
                    ApplicationArea = All;
                    Caption = 'Principal Claim No.';  //TBC-503
                }
                field("Claim Date"; Rec."Claim Date")
                {
                    Caption = 'Date of Claim';
                    ApplicationArea = All;
                }
                field("Invoice No"; Rec."Sale Invoice No. Ref.")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice No.';
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Date';
                }
                field("Order Master"; Rec."Order Master")
                {
                    ApplicationArea = All;
                    Caption = 'Order Master';
                }
                field("Description of Trouble"; Rec."Description of Trouble")
                {
                    ApplicationArea = All;
                    Caption = 'Description of Trouble';
                }
                field("Trouble object"; Rec."Trouble object")
                {
                    ApplicationArea = All;
                    Caption = 'Trouble Object';
                }
                field("Claim Accept Ref. No"; Rec."Claim Accept Ref. No")
                {
                    ApplicationArea = All;
                    Caption = 'Claim Acceptance Ref. No.';
                }

                field("Claim_RDC No"; Rec."RDC No")
                {
                    ApplicationArea = All;
                    Caption = 'RDC No.';
                }
                field("Claim_RDC Date"; Rec."RDC Date")
                {
                    ApplicationArea = All;
                    Caption = 'RDC Date';
                }
                field("Advance Received Date"; Rec."Advance Received Date")
                {
                    ApplicationArea = All;
                    Caption = 'Advanced Received Date';
                }
            }
        }
    }
    actions
    {
        addafter(SendCustom)
        {
            action(PrintCustom)
            {
                ApplicationArea = All;
                Caption = 'Print Hard Copy';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    PostedSalesInv: Record "Sales Invoice Header";
                begin
                    PostedSalesInv.Reset();
                    PostedSalesInv.SetRange("No.", Rec."No.");
                    if PostedSalesInv.FindFirst() then
                        if (PostedSalesInv."Instrument Order") OR (PostedSalesInv."Spare Order") then
                            Report.RunModal(Report::"Tax Invoice Hard Copy", true, false, PostedSalesInv)
                        else
                            Report.RunModal(Report::"Service Tax Invoice Hard Copy", true, false, PostedSalesInv);
                end;
            }
        }
        addafter(Print)
        {
            action(ServiceTaxivoiceWithoutLOGO)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Service Tax invoice Without Logo';
                Ellipsis = true;
                Visible = Rec."Sales Order Type" = 'SERVICES';
                Image = ViewPostedOrder;
                ToolTip = 'View or print the Service Tax Invoice without Logo.';
                Promoted = true;
                PromotedCategory = Category6;
                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader.Reset();
                    SalesInvHeader.SetRange("No.", Rec."No.");
                    if SalesInvHeader.FindFirst() then
                        Report.RunModal(Report::ServiceTaxInvoiceWithoutLOGO, true, false, SalesInvHeader);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetCMCAMCServiceOrder()
    end;

    procedure SetCMCAMCServiceOrder()
    begin
        if (Rec."CMC Order") or (Rec."AMC Order") or (Rec."Service Order") then
            AMCAMCVisible := true;
    end;

    var
        AMCAMCVisible: Boolean;
}
