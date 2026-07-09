pageextension 50009 SalesOrder extends "Sales Order"
{
    layout
    {
        //TBC-1020 --->
        addbefore("Work Description")
        {
            field("Approved By"; Rec."Approved By")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Approved By';
            }
            field("Approval Date and Time"; Rec."Approval Date and Time")
            {
                ApplicationArea = All;
                Caption = 'Approved Date and Time';
                Editable = false;
            }
            //TBC-1055 ------>
            field("Advance Payment Received"; Rec."Advance Payment Received")
            {
                ApplicationArea = All;
                Caption = 'Advance Payment Received';
                Editable = false;
                Visible = false;

                trigger OnAssistEdit()
                var
                    CustLedEntry: Record "Cust. Ledger Entry";
                    CustLedgerEntriesPage: Page "Customer Ledger Entries";
                    TotalAdvanceAmt: Decimal;
                begin
                    TotalAdvanceAmt := 0;

                    if Rec."Document Type" <> Rec."Document Type"::Order then
                        exit;

                    CustLedEntry.Reset();
                    CustLedEntry.SetRange("Document Type", CustLedEntry."Document Type"::Invoice);
                    CustLedEntry.SetRange("Customer No.", Rec."Sell-to Customer No.");
                    if Rec."External Document No." <> '' then
                        CustLedEntry.SetRange("External Document No.", Rec."External Document No.")
                    else
                        if Rec."Reference Number" <> '' then
                            CustLedEntry.SetRange("External Document No.", Rec."Reference Number");

                    CustLedgerEntriesPage.SetTableView(CustLedEntry);
                    CustLedgerEntriesPage.LookupMode(true);
                    if CustLedgerEntriesPage.RunModal() = Action::LookupOK then begin
                        CustLedgerEntriesPage.SetSelectionFilter(CustLedEntry);
                        if CustLedEntry.FindSet() then
                            repeat
                                CustLedEntry.CalcFields("Remaining Amount");
                                TotalAdvanceAmt += Abs(CustLedEntry."Remaining Amount");
                            until CustLedEntry.Next() = 0;
                        Rec."Advance Payment Received" := TotalAdvanceAmt;
                        Rec.Modify(false);
                    end;
                end;
            }
            //TBC-1055 <------
        }
        //TBC-1020 <---

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
        modify("Exclude GST in TCS Base")
        {
            Visible = false;
        }
        modify("Charge Group Code")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Opportunity No.")
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
        modify("Assigned User ID")
        {
            Visible = false;
        }
        addbefore("Sell-to Customer No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Sales Order Type field.';
            }
        }
        moveafter("Sell-to City"; "Sell-to County")
        moveafter("External Document No."; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
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
                field("Custom Assigned User ID"; Rec."Custom Assigned User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
            }
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("External Document No.")
        {
            Caption = 'Customer PO No.';
        }
        modify(ShippingOptions)
        {
            trigger OnAfterValidate()
            begin
                CheckShiptoAddress();
            end;
        }
        addafter("Work Description")
        {
            group(SEZInstruction)
            {
                Caption = '';
                Visible = Rec."GST Customer Type" = Rec."GST Customer Type"::"SEZ Unit";

                field("SEZ Instruction"; Rec."SEZ Instruction")
                {
                    ApplicationArea = All;
                }
            }
            group("DiscountTYpe")
            {
                Caption = '';
                Visible = not Rec."Spare Order";

                field("Discount Type"; Rec."Discount Type")
                {
                    ApplicationArea = All;
                    Caption = 'Discount Type';
                    ToolTip = 'Specifies the value of the Discount Type field.';
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
        addbefore("External Document No.")
        {
            group(" ")
            {
                Caption = '';
                Visible = Rec."Instrument Order";
                field("Master Sales Order Number"; Rec."Master Sales Order Number")
                {
                    ApplicationArea = All;
                }
            }
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
                field("TAPL Booking Month"; Rec."TAPL Booking Month")
                {
                    ApplicationArea = All;
                    Caption = 'TAPL Booking Month';
                    ToolTip = 'Select the TAPL Booking Month.';
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                    Caption = 'TAPL Booking Year';
                    ToolTip = 'Select the TAPL Booking Year.';
                    NotBlank = true;
                    BlankZero = true;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DateRec: Record Date;
                        CurrentYear: Integer;
                        SelectedYear: Integer;
                    begin
                        DateRec.Reset();
                        DateRec.SetRange("Period Type", DateRec."Period Type"::Year);
                        DateRec.SetRange("Period No.", 2000, 2099);

                        if Page.RunModal(Page::"Month and Year", DateRec) = Action::LookupOK then begin
                            SelectedYear := Date2DMY(DateRec."Period Start", 3);
                            CurrentYear := Date2DMY(Today, 3);
                            if SelectedYear > CurrentYear then
                                Error('The booking year cannot be greater than the current year.');
                            Rec.Validate(Year, DateRec."Period No.");
                        end;
                    end;
                }
            }
        }
        addafter(General)
        {
            group("Spares")
            {
                Caption = 'Spares';
                //Visible = Rec."Sales Order Type" = 'Spares/Tools Order';
                Visible = Rec."Spare Order";
                group("SpareGeneral")
                {
                    Caption = '';

                    field("CRM Quote No."; Rec."CRM Quote No.")
                    {
                        ApplicationArea = All;
                        // Editable = false;
                        Caption = 'Quote No.';
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
                    field("Customer PO Date"; Rec."Customer PO Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Customer PO Date field.';
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
                        Visible = false;
                    }
                }
            }



            group("Instrument")
            {
                Caption = 'General-2';
                //Visible = Rec."Sales Order Type" = 'Sales Order Instrument';
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
                field("New Customer"; Rec."New Customer")
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
                            CustomerRec: Record Customer;
                        begin
                            // Get the selected customer
                            if CustomerRec.Get(Rec."Dealer Customer Name") then begin
                                Rec."Dealer Customer Name" := CustomerRec.Name;
                                Rec."Dealer Customer Address" := CustomerRec.Address;
                                Rec."Dealer Customer Address 2" := CustomerRec."Address 2";
                                Rec."Dealer Customer City" := CustomerRec.City;
                                Rec."Dealer Customer County" := CustomerRec.County;
                                Rec."Dealer Country/Region Code" := CustomerRec."Country/Region Code";
                                Rec."Dealer Customer Post Code" := CustomerRec."Post Code";
                                Rec."Dealer Customer GST No." := CustomerRec."GST Registration No.";
                            end;
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
                        ApplicationArea = All;
                        Caption = 'Dealer Customer GST No.';
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
                            Rec."Industry Sub-Segment" := '';
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
                    field(Application; Rec.Application)
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
                            Emp: Record Employee;
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
                //TBC-503 -->
                field("Claim Contact Person"; Rec."Claim Contact Person")
                {
                    ApplicationArea = All;
                    Caption = 'Contact Person';
                }
                field("Claim Inst Sr. No."; Rec."Claim Inst Sr. No.")
                {
                    ApplicationArea = All;
                    Caption = 'Inst Sr. No';
                }
                field("Claim Inst. Model"; Rec."Claim Inst. Model")
                {
                    ApplicationArea = All;
                    Caption = 'Inst. Model';
                }
                field("Claim Narration"; Rec."Claim Narration")
                {
                    ApplicationArea = All;
                    Caption = 'Narration';
                }
                //TBC-503 <--
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
        addafter("Ship-to Country/Region Code")
        {
            field("Ship to Industry Caregory"; Rec."Ship to Industry Caregory")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ship-to Industry Category field.';
            }
        }
        addafter("External Document No.")
        {
            field("PO Date"; Rec."Customer PO Date")
            {
                Caption = 'Customer PO Date';
                ApplicationArea = All;
            }
            //TBC-973 -->
            field("Party PO Received Date"; Rec."Party PO Received Date")
            {
                Caption = 'Party PO Received Date';
                ApplicationArea = All;
            }
            //TBC-973 <--
        }
        addafter("Prepayment %")
        {
            field("Prepayment Amount"; Rec."Prepayment Amount")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    TotalAmt: Decimal;
                    SalesLine: Record "Sales Line";
                begin
                    Clear(TotalAmt);
                    if Rec."Prepayment Amount" = 0 then
                        Rec.Validate("Prepayment %", 0);

                    if Rec."Prepayment Amount" <> 0 then begin
                        // Use header total directly
                        SalesLine.Reset();
                        SalesLine.SetRange("Document Type", Rec."Document Type");
                        SalesLine.SetRange("Document No.", Rec."No.");
                        if SalesLine.FindSet() then
                            repeat
                                TotalAmt += SalesLine."Line Amount" + SalesLine."CGST Amount" + SalesLine."SGST Amount" + SalesLine."IGST Amount";
                            until SalesLine.Next() = 0;

                        if TotalAmt <> 0 then begin
                            Rec.Validate("Prepayment %", (Rec."Prepayment Amount" / TotalAmt) * 100);
                            Rec.Modify(false);
                        end;
                    end;
                end;
            }
        }

        addafter("Payment Terms Code")
        {
            field("Payment Term Details"; Rec."Payment Term Details")
            {

                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Terms Details field.';
                MultiLine = true;
            }
        }
        addlast(Control90)
        {
            group(CustomGST)
            {
                Caption = '';
                Visible = ShipToOptions = ShipToOptions::"Custom Address";
                field("Custom GST No"; Rec."Custom GST No")
                {
                    ApplicationArea = All;
                    Caption = 'GST Regd. No.';
                }
                field("Custom PAN No."; Rec."Custom PAN No.")
                {
                    ApplicationArea = All;
                    Caption = 'PAN No.';
                }
                field("Custom State"; Rec."Custom State")
                {
                    ApplicationArea = All;
                    Caption = 'State';
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
        modify("Print Confirmation")
        {
            Visible = false;
        }
        addlast("&Print")
        {
            action(SOProformaInvoice)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pro Forma Invoice';
                Image = ViewPostedOrder;
                Promoted = true;
                PromotedCategory = Category11;
                ToolTip = 'View or print the pro forma sales invoice.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", Rec."Document Type");
                    SalesHeader.SetRange("No.", Rec."No.");

                    if SalesHeader.FindFirst() then begin
                        if (SalesHeader."Service Order") or
                           (SalesHeader."Sales Order Type" = 'SERVICES') then
                            Report.RunModal(Report::"Service Proforma Invoice", true, false, SalesHeader)
                        else
                            Report.RunModal(Report::"Custom Pro Froma Invoice", true, false, SalesHeader);
                    end;
                end;
            }
            action(ServiceProformaInvoiceWithoutLogo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Service ProForma Invoice Without Logo';
                Ellipsis = true;
                Image = ViewPostedOrder;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category11;
                ToolTip = 'View or print the Service proforma sales invoice without LOGO.';
                Visible = Rec."Sales Order Type" = 'SERVICES';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", Rec."Document Type");
                    SalesHeader.SetRange("No.", Rec."No.");

                    if SalesHeader.FindFirst() then
                        Report.RunModal(Report::ServiceProformaWithoutLOGO, true, false, SalesHeader);
                end;
            }
            action("Send ProForm Invoice")
            {
                ApplicationArea = All;
                Caption = 'Send Pro Form Invoice';
                Image = Email;
                Promoted = true;
                PromotedCategory = Category11;

                trigger OnAction()
                var
                    Email: Codeunit Email;
                    Recipietns: List of [Text];
                    EmailMessage: Codeunit "Email Message";
                    EmailBody: Text;
                    Subject: Text;
                    RecRef: RecordRef;
                    EmailScenario: Codeunit "Email Scenario";
                    EmailAcc: Boolean;
                    EmailAccount: Record "Email Account";
                    TempBlob: Codeunit "Temp Blob";
                    OutStr: OutStream;
                    InStr: InStream;
                    SalesHeader: Record "Sales Header";
                begin
                    Clear(Subject);
                    Clear(Recipietns);
                    Clear(EmailBody);
                    if Rec."Sell-to E-Mail" <> '' then
                        Recipietns.Add(Rec."Sell-to E-Mail");

                    Subject := 'Pro Forma Invoice – ' + Rec."No.";

                    EmailBody := '<html>' + '<body>' + '<p>' + 'Dear ' + Rec."Sell-to Customer Name" + ',</p>'
                    + '<p>' + 'Please find attached the Pro Forma Invoice for your reference.' + '</p>'
                    + '<p>' + 'Thank you for your continued business.' + '</p>'
                    + '<p>' + 'Thanks &amp; Regards,' + '<br/>'
                    + 'Toshvin Analytical Pvt Ltd.' + '<br/>' + '</body>' + '</html>';

                    Clear(TempBlob);
                    Clear(OutStr);
                    Clear(InStr);
                    EmailMessage.Create(Recipietns, Subject, EmailBody, true);
                    SalesHeader.Reset();
                    SalesHeader.SetRange("No.", Rec."No.");
                    if SalesHeader.FindFirst() then begin
                        RecRef.GetTable(SalesHeader);
                        TempBlob.CreateOutStream(OutStr);
                        Report.SaveAs(Report::"Custom Pro Froma Invoice", '', ReportFormat::Pdf, OutStr, RecRef);
                        TempBlob.CreateInStream(InStr);
                        EmailMessage.AddAttachment('Pro Forma Invoice ' + Rec."No." + '.pdf', 'Pro Forma Invoice.pdf', InStr);
                    end;
                    if Enum::"Email Action"::Sent = Email.OpenInEditorModally(EmailMessage, Enum::"Email Scenario"::Default) then
                        Message('Email Sent');
                end;
            }
        }
        addafter(SendEmailConfirmation)
        {
            action("Custom Sales Order")
            {
                ApplicationArea = All;
                Caption = 'Print Confirmation';
                Promoted = true;
                PromotedCategory = Category11;
                PromotedIsBig = true;
                ToolTip = 'Print a sales order confirmation.';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", Rec."Document Type");
                    SalesHeader.SetRange("No.", Rec."No.");
                    if SalesHeader.FindFirst() then begin
                        if (SalesHeader."Service Order") or
                           (SalesHeader."Sales Order Type" = 'SERVICES') then
                            Report.RunModal(Report::"Service Sales Order", true, false, SalesHeader)
                        else
                            Report.RunModal(Report::"Branch Sales Order", true, false, SalesHeader);
                    end;
                end;
            }
        }
    }


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


        // for Executive master validation
        // CheckExeMaster := false;
        // if (Rec."Executive Master" <> '') then begin
        //     CheckExeMaster := true;
        //     if Rec."Executive Master2" <> '' then begin
        //         CheckExeMaster2 := true;
        //         if Rec."Executive Master3" <> '' then
        //             CheckExeMaster3 := true;
        //     end;
        // end;

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

    trigger OnAfterGetRecord()
    begin
        SetCMCAMCServiceOrder()
    end;

    procedure SetCMCAMCServiceOrder()
    begin
        if (Rec."CMC Order") or (Rec."AMC Order") or (Rec."Service Order") then
            AMCAMCVisible := true;
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

    var
        IndSub: Record "Industry Sub-Segment";
        AppSub: Record "Application Sub-Segment";
        CheckIndsub: Boolean;
        CheckAppsub: Boolean;
        CheckExeMaster: Boolean;
        CheckExeMaster2: Boolean;
        CheckExeMaster3: Boolean;
        AMCAMCVisible: Boolean;
}
