namespace ALToshvin.ALToshvin;

using Microsoft.Sales.Document;

pageextension 50034 "Sales Invoice Ext" extends "Sales Invoice"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        modify("Your Reference")
        {
            Editable = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        addafter("Salesperson Code")
        {
            field("Custom Assigned User ID"; Rec."Custom Assigned User ID")
            {
                ApplicationArea = All;
            }
        }
        modify(ShippingOptions)
        {
            trigger OnAfterValidate()
            begin
                CheckShiptoAddress();
            end;
        }
        addlast(General)
        {
            group(GroupMaster)
            {
                Visible = Rec."Instrument Order";
                Caption = '';
                field("Group Master"; Rec."Group Master")
                {
                    ApplicationArea = All;
                    Caption = 'Group Master (Customer)';
                    ToolTip = 'Specifies the value of the group master field.';
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    BlankZero = true;
                    Caption = 'TAPL Booking Year';

                }
                field("TAPL Booking Month"; Rec."TAPL Booking Month")
                {
                    ApplicationArea = All;
                    Caption = 'TAPL Booking Month';
                }
            }
            //start of ticket no.- 918 on 30/03/26
            field("Deemed Export"; Rec."Deemed Export")
            {
                ApplicationArea = All;
                Caption = 'Deemed Export';
                ToolTip = 'Specifies the value of the Deemed Export field.';
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
                }
            }
            // end of ticket no.- 918
        }
        addafter(General)
        {
            group("Spares")
            {
                Caption = 'Spares';
                Visible = Rec."Spare Order";
                group("SpareGeneral")
                {
                    Caption = '';

                    field("CRM Quote No."; Rec."CRM Quote No.")
                    {
                        ApplicationArea = All;
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
                        Visible = false;
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

                    field("Service Person ID"; Rec."Executive Master")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 1';
                        ToolTip = 'Specifies the value of Executive Master 1.';

                        trigger OnValidate()
                        begin
                            if Rec."Executive Master" <> '' then
                                if Rec."Executive Master2" = Rec."Executive Master" then
                                    Error('Executive Master already exists.');
                        end;
                    }

                    field("ExecutiveMaster2"; Rec."Executive Master2")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 2';
                        ToolTip = 'Specifies the value of Executive Master 2.';
                        trigger OnValidate()
                        begin
                            if Rec."Executive Master" = Rec."Executive Master2" then
                                Error('Executive Master already exists.');
                        end;
                    }

                    field("CRM Employee ID 2"; Rec."CRM Employee ID 2")
                    {
                        ApplicationArea = All;
                        Caption = 'Approved By';
                        ToolTip = 'Specifies the value of the Approved By field.';
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

                    field("Customer PO No."; Rec."Customer PO No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Customer PO No. field.';
                        Visible = false;
                    }

                }

                group(SpareGenrral2)
                {
                    Caption = '';
                    field("Key/Non-Key"; Rec."Key/Non-Key")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Key/Non-Key field.';
                        Editable = false;
                    }
                    field("KEY/NON KEY(Principal Wise)"; Rec."KEY/NON KEY(Principal Wise)")
                    {
                        ApplicationArea = All;
                        Caption = 'KEY/NON KEY(Principal Wise)';
                        ToolTip = 'Specifies the value of the KEY/NON KEY(Principal Wise) field.';
                        Editable = false;
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
                    field("Sales Order Amount"; Rec."Sales Order Amount")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
            }
            group("Instrument")
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
                        ShowMandatory = true;
                    }
                    field("PO No."; Rec."Customer PO No.")
                    {
                        Caption = 'PO No.';
                        ApplicationArea = All;
                        Visible = false;
                    }
                    field(Campaign; Rec.Campaign)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Campaign field.';
                    }

                    field("Campaign Details"; Rec."Campaign Details")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Campaign Details field.';
                        MultiLine = true;
                    }
                    field("Performance Bank Guarantee"; Rec."Performance Bank Guarantee")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Performance Bank Guarantee field.';
                        MultiLine = true;
                        Visible = false;
                    }
                    field("Corporate Guarantee"; Rec."Corporate Guarantee")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Corporate Guarantee field.';
                        MultiLine = true;
                        Visible = false;
                    }
                    field(Insurance; Rec.Insurance)
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Insurance field.';
                        MultiLine = true;
                    }
                    field("Packing & Forwarding"; Rec."Packing & Forwarding")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Packing & Forwarding field.';
                        MultiLine = true;
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
                field("New CUstomer"; Rec."New Customer")
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the New Customer field.';
                }
                field("Dealer Customer"; Rec."Dealer Customer")
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Dealer Customer field.';
                }
                group("DealerCustomer")
                {
                    Caption = '';
                    Visible = Rec."Dealer Customer";

                    field("Dealer Customer Name"; Rec."Dealer Customer Name")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Dealer Customer Name field.';
                        ShowMandatory = true;
                        trigger OnValidate()
                        var

                        begin
                            // Get the selected customer
                            // if CustomerRec.Get(Rec."Dealer Customer Name") then begin
                            //     Rec."Dealer Customer Name" := CustomerRec.Name;
                            //     Rec."Dealer Customer Address" := CustomerRec.Address;
                            //     Rec."Dealer Customer Address 2" := CustomerRec."Address 2";
                            //     Rec."Dealer Customer City" := CustomerRec.City;
                            //     Rec."Dealer Customer County" := CustomerRec.County;
                            //     Rec."Dealer Country/Region Code" := CustomerRec."Country/Region Code";
                            //     Rec."Dealer Customer Post Code" := CustomerRec."Post Code";
                            //     Rec."Dealer Customer GST No." := CustomerRec."GST Registration No.";
                            // end;
                        end;
                    }
                    field("Dealer Customer Address"; Rec."Dealer Customer Address")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Dealer Customer Address field.';
                    }
                    field("Dealer Customer Address 2"; Rec."Dealer Customer Address 2")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Dealer Customer Address 2 field.';
                    }
                    field("Dealer Customer City"; Rec."Dealer Customer City")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Dealer Customer City field.';
                    }
                    field("Dealer Customer County"; Rec."Dealer Customer County")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Dealer Customer County field.';
                    }
                    field("Dealer Country/Region Code"; Rec."Dealer Country/Region Code")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Dealer Customer Country/Region Code field.';
                    }
                    field("Dealer Customer Post Code"; Rec."Dealer Customer Post Code")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Dealer Customer Post Code field.';
                    }
                    field("Dealer Customer GST No."; Rec."Dealer Customer GST No.")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Dealer Customer GST No. field.';
                    }
                }
                field("EMD Details"; Rec."EMD Details")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EMD Details field.';
                }
                group("EMDDetails")
                {
                    Caption = '';
                    Visible = Rec."EMD Details";

                    field("EMD No."; Rec."EMD No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EMD No. field.';
                    }
                    field("EMD Date"; Rec."EMD Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EMD Date field.';
                    }
                    field("EMD Due Date"; Rec."EMD Due Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EMD Due Date field.';
                    }
                }
                field("PBG Details"; Rec."PBG Details")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PBG Details field.';
                }

                group("PBGDetails")
                {
                    Caption = '';
                    Visible = Rec."PBG Details";

                    field("PBG No."; Rec."PBG No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the PBG No. field.';
                    }
                    field("PBG Date"; Rec."PBG Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the PBG Dete field.';
                    }
                    field("PBG Due Date"; Rec."PBG Due Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the PBG Due Dete field.';
                    }
                }
                field("Business Sector"; Rec."Business Sector")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Business Sector';
                    ToolTip = 'Specifies the value of the Business Sector field.';
                    ShowMandatory = true;
                }
                group(IndustrySegementation)
                {
                    Caption = 'Industry Segementation';
                    field(Industry; Rec.Industry)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Industry';
                        ToolTip = 'Specifies the industry.';
                        ShowMandatory = true;
                        trigger OnValidate()
                        begin
                            CheckIndsub := false;
                            if Rec.Industry <> '' then begin
                                IndSub.SetRange(Industry, Rec.Industry);
                                if IndSub.FindSet() then
                                    CheckIndsub := true;
                            end;
                        end;
                    }

                    field("Industry Sub-Segment"; Rec."Industry Sub-Segment")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Industry Sub-Segment';
                        ToolTip = 'Specifies the sub-segment related to the selected industry.';
                        TableRelation = if (Industry = const()) "Industry Sub-Segment".Industry
                        else
                        "Industry Sub-Segment"."Indu Sub-Seg Description" where(Industry = field(Industry));
                        Editable = CheckIndsub;
                        ShowMandatory = true;
                    }

                }
                group(ApplicationSegementation)
                {
                    Caption = 'Application Segementation';
                    field(CustomApplication; Rec.Application)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Application';
                        ToolTip = 'Specifies the application.';
                        ShowMandatory = true;
                        trigger OnValidate()
                        begin
                            CheckAppsub := false;

                            // Clear Application Sub-Segment when Application changes
                            Rec."Appliaction Sub-Segment" := '';

                            if Rec.Application <> '' then begin
                                AppSub.Reset();
                                AppSub.SetRange(Application, Rec.Application);
                                if AppSub.FindSet() then
                                    CheckAppsub := true;
                            end;
                        end;
                    }

                    field("Application Sub-Segment"; Rec."Appliaction Sub-Segment")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Application Sub-Segment';
                        ToolTip = 'Specifies the sub-segment related to the selected application.';
                        TableRelation = if (Application = const()) "Application Sub-Segment".Application
                        else
                        "Application Sub-Segment"."App Sub-Seg Description" where(Application = field(Application));
                        Editable = CheckAppsub;
                        ShowMandatory = true;
                    }
                }
                group(ExecutiveMaster)
                {
                    Caption = 'Executive Master';
                    field("Executive Master"; Rec."Executive Master")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 1';
                        ToolTip = 'Specifies the value of Executive Master 1.';

                    }
                    field("Share Of Exe Master"; Rec."Share Of Exe Master")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 1%';
                        ToolTip = 'Specifies the share percentage of Executive Master 1.';
                        Editable = true;
                        trigger OnValidate()
                        var

                        begin
                            CheckExeMaster := false;
                            CheckExeMaster2 := false;
                            CheckExeMaster3 := false;

                            if Rec."Share Of Exe Master" <> 0 then
                                CheckExeMaster := true;
                            if Rec."Share Of Exe Master" = 100 then
                                CheckExeMaster := false
                            else if Rec."Share Of Exe Master" > 100 then
                                Error('Share percentage cannot be more than 100.');
                        end;
                    }
                    field("Executive Master2"; Rec."Executive Master2")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 2';
                        ToolTip = 'Specifies the value of Executive Master 2.';
                        Editable = CheckExeMaster;
                        trigger OnValidate()
                        begin
                            CheckExeMaster2 := false;

                            if Rec."Executive Master" = Rec."Executive Master2" then
                                Error('Executive Master already exists.');
                        end;
                    }
                    field("Share Of Exe Master2"; Rec."Share Of Exe Master2")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 2%';
                        ToolTip = 'Specifies the share percentage of Executive Master 2.';
                        Editable = CheckExeMaster;
                        trigger OnValidate()
                        begin
                            CheckExeMaster2 := false;
                            CheckExeMaster3 := false;

                            if Rec."Share Of Exe Master2" <> 0 then
                                CheckExeMaster2 := true;
                            if Rec."Share Of Exe Master" + Rec."Share Of Exe Master2" = 100 then
                                CheckExeMaster2 := false
                            else if Rec."Share Of Exe Master" + Rec."Share Of Exe Master2" > 100 then
                                Error('Total share percentage cannot be more than 100.')
                        end;
                    }
                    field("Executive Master3"; Rec."Executive Master3")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 3';
                        ToolTip = 'Specifies the value of Executive Master 3.';
                        Editable = CheckExeMaster2;
                        trigger OnValidate()
                        begin
                            CheckExeMaster3 := false;

                            if (Rec."Executive Master" = Rec."Executive Master3") or
                               (Rec."Executive Master2" = Rec."Executive Master3") then
                                Error('Executive Master already exists.');
                        end;
                    }
                    field("Share Of Exe Master3"; Rec."Share Of Exe Master3")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 3%';
                        ToolTip = 'Specifies the share percentage of Executive Master 3.';
                        Editable = CheckExeMaster2;
                        trigger OnValidate()
                        begin
                            CheckExeMaster3 := false;

                            if Rec."Share Of Exe Master3" <> 0 then
                                CheckExeMaster3 := true;
                            if Rec."Share Of Exe Master" + Rec."Share Of Exe Master2" +
                           Rec."Share Of Exe Master3" = 100 then
                                CheckExeMaster3 := false
                            else if Rec."Share Of Exe Master" + Rec."Share Of Exe Master2" +
                               Rec."Share Of Exe Master3" > 100 then
                                Error('Total share percentage cannot be more than 100.')
                        end;
                    }
                    field("Executive Master4"; Rec."Executive Master4")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 4';
                        ToolTip = 'Specifies the value of Executive Master 4.';
                        Editable = CheckExeMaster3;
                        trigger OnValidate()
                        begin
                            if (Rec."Executive Master" = Rec."Executive Master4") or
                               (Rec."Executive Master2" = Rec."Executive Master4") or
                               (Rec."Executive Master3" = Rec."Executive Master4") then
                                Error('Executive Master already exists.');
                        end;
                    }
                    field("Share Of Exe Master4"; Rec."Share Of Exe Master4")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 4%';
                        ToolTip = 'Specifies the share percentage of Executive Master 4.';
                        Editable = CheckExeMaster3;
                        trigger OnValidate()
                        begin
                            if Rec."Share Of Exe Master" + Rec."Share Of Exe Master2" +
                               Rec."Share Of Exe Master3" + Rec."Share Of Exe Master4" <> 100 then
                                Error('Total share percentage should be equal to 100.');
                        end;
                    }
                }
            }

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
        addbefore("External Document No.")
        {
            group(" ")
            {
                Caption = '';
                Visible = Rec."Instrument Order";
                field("Master Sales Order Number"; Rec."Master Sales Order Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        modify(ProformaInvoice)
        {
            Visible = false;
        }
        addafter(DraftInvoice)
        {
            action(NavProformaInvoice)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pro Forma Invoice';
                Ellipsis = true;
                Image = ViewPostedOrder;
                ToolTip = 'View or print the pro forma sales invoice.';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", Rec."Document Type");
                    SalesHeader.SetRange("No.", Rec."No.");
                    if SalesHeader.FindFirst() then
                        Report.RunModal(Report::SparesSalesInvoice, true, false, SalesHeader);
                end;
            }
        }
        addlast(Category_PrintSend)
        {
            actionref(Nav_ProformaInvoice; NavProformaInvoice) { }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetCMCAMCServiceOrder()
    end;

    trigger OnOpenPage()
    begin

        // Industry and Industry Sub-Segment Validation
        CheckIndsub := false;
        if Rec.Industry <> '' then begin
            IndSub.SetRange(Industry, Rec.Industry);
            if IndSub.FindSet() then
                CheckIndsub := true;
        end;

        // Application and Application Sub-Segment Validation
        CheckAppsub := false;
        if Rec.Application <> '' then begin
            AppSub.SetRange(Application, Rec.Application);
            if AppSub.FindSet() then
                CheckAppsub := true;
        end;




        // Executive Master Validation
        CheckExeMaster := false;
        CheckExeMaster2 := false;
        CheckExeMaster3 := false;

        if Rec."Executive Master" <> '' then begin
            CheckExeMaster := true;
            if Rec."Executive Master2" <> '' then begin
                CheckExeMaster2 := true;
                if Rec."Executive Master3" <> '' then
                    CheckExeMaster3 := true;
            end;
        end;
    end;

    procedure CheckShiptoAddress()
    begin
        if ShipToOptions = ShipToOptions::"Default (Sell-to Address)" then
            Rec."Custom Ship-to" := ShipToOptions::"Default (Sell-to Address)"
        else if ShipToOptions = ShipToOptions::"Alternate Shipping Address" then
            Rec."Custom Ship-to" := ShipToOptions::"Alternate Shipping Address"
        else if ShipToOptions = ShipToOptions::"Custom Address" then
            Rec."Custom Ship-to" := ShipToOptions::"Custom Address";

        Rec.Modify(false);
    end;

    procedure SetCMCAMCServiceOrder()
    begin
        if (Rec."CMC Order") or (Rec."AMC Order") or (Rec."Service Order") then
            AMCAMCVisible := true;
    end;

    var
        AMCAMCVisible: Boolean;
        IndSub: Record "Industry Sub-Segment";
        AppSub: Record "Application Sub-Segment";
        CheckIndsub: Boolean;
        CheckAppsub: Boolean;
        CheckExeMaster: Boolean;
        CheckExeMaster2: Boolean;
        CheckExeMaster3: Boolean;
}
