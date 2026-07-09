pageextension 50022 "PurchaseOrder" extends "Purchase Order"
{
    layout
    {

        //TBC-1060 --->
        addafter("Vendor Invoice No.")
        {
            field("Vendor Invoice Date"; Rec."Vendor Invoice Date")
            {
                ApplicationArea = All;
                Caption = 'Vendor Invoice Date';
            }
        }
        //TBC-1060 <---
        modify("Your Reference")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("Purchase Order Type"; Rec."Purchase Order Type")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        addlast(General)
        {
            field("Custom Assigned User ID"; Rec."Custom Assigned User ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                Caption = 'Assigned User ID';
                trigger OnLookup(var Text: Text): Boolean
                var
                    Emp: Record Employee;
                begin
                    Emp.Reset();
                    if Page.RunModal(Page::"Employee List", Emp) = Action::LookupOK then
                        Rec."Custom Assigned User ID" := Emp."First Name" + ' ' + Emp."Last Name";
                end;
            }
            field("Purchase Type"; Rec."Purchase Type")
            {
                ApplicationArea = All;
                Caption = 'Purchase Type';
            }
            field("Folio No."; Rec."Folio No.")
            {
                ApplicationArea = All;
                Caption = 'Folio No.';
            }
            field("Transportation Chg."; Rec."Transportation Chg.")
            {
                ApplicationArea = All;
                Caption = 'Transportation Charge';
            }

            field("Delivery Terms"; Rec."Delivery Terms")
            {
                ApplicationArea = All;
                Caption = 'Delivery Terms';
            }
            field("Supplier Quote No."; Rec."Supplier Quote No.")
            {
                ApplicationArea = All;
                Caption = 'Supplier Quote No.';
            }
            field("Supplier Quote Date"; Rec."Supplier Quote Date")
            {
                ApplicationArea = All;
                Caption = 'Supplier Quote Date';
            }
            field(Warranty; Rec.Warranty)
            {
                ApplicationArea = All;
                Caption = 'Warranty';

            }
            field("Inco Terms"; Rec."Inco Terms")
            {
                ApplicationArea = All;
                Caption = 'Inco Terms';
            }

            //TBC-1062 --->
            field("Custom Freight Amount INR"; Rec."Custom Freight Amount INR")
            {
                ApplicationArea = All;
                Caption = 'Custom Freight Amount INR';
                Visible = false;

                trigger OnValidate()
                var
                    ExchageRate: Decimal;
                begin
                    if Rec."Currency Factor" <> 0 then
                        ExchageRate := 1 / Rec."Currency Factor"
                    else
                        ExchageRate := 1;
                    Rec.Validate("Custom Freight Amount", (Rec."Custom Freight Amount INR" * ExchageRate));
                end;
            }
            field("Custom Insurance Amount INR"; Rec."Custom Insurance Amount INR")
            {
                ApplicationArea = All;
                Caption = 'Custom Insurance Amount INR';
                Visible = false;

                trigger OnValidate()
                var
                    ExchageRate: Decimal;
                begin
                    if Rec."Currency Factor" <> 0 then
                        ExchageRate := 1 / Rec."Currency Factor"
                    else
                        ExchageRate := 1;
                    Rec.Validate("Custom Insurance Amount", (Rec."Custom Insurance Amount INR" * ExchageRate));
                end;
            }
            //TBC-1062 <---
            field("Custom Freight Amount"; Rec."Custom Freight Amount")
            {
                ApplicationArea = All;
                Caption = 'Custom Freight Amount';


                trigger OnValidate()
                var
                    PurchLine: Record "Purchase Line";
                    TotalPOAmount: Decimal;
                begin
                    Rec.TestStatusOpen();
                    TotalPOAmount := 0;

                    // Calculate total PO line amount
                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", Rec."Document Type");
                    PurchLine.SetRange("Document No.", Rec."No.");
                    if PurchLine.FindSet() then
                        repeat
                            TotalPOAmount += PurchLine."Line Amount";
                        until PurchLine.Next() = 0;

                    // Distribute Insurance Amount
                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", Rec."Document Type");
                    PurchLine.SetRange("Document No.", Rec."No.");
                    if PurchLine.FindSet() then
                        repeat
                            if Rec."Custom Freight Amount" <> 0 then begin
                                if (TotalPOAmount <> 0) and
                                   (PurchLine."Direct Unit Cost" <> 0) and
                                   (PurchLine.Quantity <> 0)
                                then
                                    PurchLine."Freight Amount" :=
                                        (Rec."Custom Freight Amount" / TotalPOAmount) * PurchLine."Line Amount"
                            end else
                                PurchLine."Freight Amount" := 0;
                            PurchLine.Modify(false);
                        until PurchLine.Next() = 0;
                end;
            }
            field("Custom Insurance Amount"; Rec."Custom Insurance Amount")
            {
                ApplicationArea = All;
                Caption = 'Custom Insurance Amount';



                trigger OnValidate()
                var
                    PurchLine: Record "Purchase Line";
                    TotalPOAmount: Decimal;
                begin
                    Rec.TestStatusOpen();
                    TotalPOAmount := 0;

                    // Calculate total PO line amount
                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", Rec."Document Type");
                    PurchLine.SetRange("Document No.", Rec."No.");
                    if PurchLine.FindSet() then
                        repeat
                            TotalPOAmount += PurchLine."Line Amount";
                        until PurchLine.Next() = 0;

                    // Distribute Insurance Amount
                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", Rec."Document Type");
                    PurchLine.SetRange("Document No.", Rec."No.");
                    if PurchLine.FindSet() then
                        repeat
                            if Rec."Custom Insurance Amount" <> 0 then begin
                                if (TotalPOAmount <> 0) and
                                   (PurchLine."Direct Unit Cost" <> 0) and
                                   (PurchLine.Quantity <> 0)
                                then
                                    PurchLine."Insurance Amount" :=
                                        (Rec."Custom Insurance Amount" / TotalPOAmount) * PurchLine."Line Amount"

                            end else
                                PurchLine."Insurance Amount" := 0;
                            PurchLine.Modify(false);
                        until PurchLine.Next() = 0;
                end;
            }
        }

        addafter("Custom Assigned User ID")
        {
            group(PostCode)
            {
                Caption = '';
                Visible = Rec."GST Vendor Type" = Rec."GST Vendor Type"::Import;

                field("Port Code (Imports)"; Rec."Port Code (Imports)")
                {
                    ApplicationArea = All;
                }
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
        modify("VAT Reporting Date")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = true;
        }
        modify("Location Code")
        {
            Editable = true;
            Caption = 'Warehouse Code';
            // trigger OnAfterValidate()
            // begin
            //     CheckShiptoAddress();
            // end;

            trigger OnAfterValidate()
            begin
                ValidateAndSyncCustomShipTo();
            end;
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                PurchLine: Record "Purchase Line";
            begin
                ValidateAndSyncCustomShipTo();
            end;
        }
        modify("Include GST in TDS Base")
        {
            Visible = false;
        }
        modify(ShippingOptionWithLocation)
        {
            // trigger OnAfterValidate()
            // begin
            //     CheckShiptoAddress();
            // end;
            trigger OnAfterValidate()
            begin
                ValidateAndSyncCustomShipTo();
            end;
        }
        moveafter("Posting Date"; "Expected Receipt Date")
        moveafter(Status; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        moveafter("Expected Receipt Date"; "Requested Receipt Date")
        moveafter("Requested Receipt Date"; "Promised Receipt Date")

    }
    actions
    {
        addafter(MoveNegativeLines)
        {
            action(BreakSpecialOrder)
            {
                ApplicationArea = All;
                Caption = 'Break Special Order';
                // Promoted = true;
                Image = CalculateDiscount;
                // PromotedCategory = Process;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseLine: Record "Purchase Line";
                    SalesLine: Record "Sales Line";
                    DiscountPage: Page "Special Order Discount";
                    PurchaseSubForm: Page "Purchase Order Subform";
                begin
                    // Check for Special Order lines before proceeding
                    if not Confirm('Do you want to break the Special Order?', false) then
                        exit;

                    if not PurchaseHeader.Get(Rec."Document Type", Rec."No.") then
                        exit;

                    Page.Run(Page::"Special Order DIscount", PurchaseHeader);
                end;
            }
            //TBC-964 ---> 
            action(BreakDropShipmentOrder)
            {
                ApplicationArea = All;
                Caption = 'Break Drop Shipment';
                Promoted = true;
                Image = CalculateDiscount;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseLine: Record "Purchase Line";
                    SalesLine: Record "Sales Line";
                    IsProcessed: Boolean;
                begin
                    // Confirmation
                    if not Confirm('Do you want to break the Drop Shipment Order?', false) then
                        exit;

                    // Get Purchase Header
                    if not PurchaseHeader.Get(Rec."Document Type", Rec."No.") then
                        Error('Purchase Order not found.');

                    // Reopen PO if Released
                    if PurchaseHeader.Status = PurchaseHeader.Status::Released then begin
                        PurchaseHeader.Status := PurchaseHeader.Status::Open;
                        PurchaseHeader.Modify(true);
                    end;

                    // Process Purchase Lines
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);

                    if PurchaseLine.FindSet() then
                        repeat
                            if PurchaseLine."Drop Shipment" then begin

                                // ===== Update Sales Line =====
                                if (PurchaseLine."Sales Order No." <> '') and
                                   (PurchaseLine."Sales Order Line No." <> 0) then begin

                                    SalesLine.Reset();
                                    SalesLine.SetRange("Document No.", PurchaseLine."Sales Order No.");
                                    SalesLine.SetRange("Line No.", PurchaseLine."Sales Order Line No.");

                                    if SalesLine.FindFirst() then begin
                                        // Break link
                                        SalesLine.Validate("Purchase Order No.", '');
                                        SalesLine.Validate("Purch. Order Line No.", 0);

                                        // Remove Drop Shipment
                                        SalesLine.Validate("Drop Shipment", false);

                                        // Clear Purchasing Code
                                        SalesLine.Validate("Purchasing Code", '');

                                        SalesLine.Modify(true);
                                    end;
                                end;

                                // ===== Update Purchase Line =====
                                PurchaseLine.Validate("Sales Order No.", '');
                                PurchaseLine.Validate("Sales Order Line No.", 0);
                                PurchaseLine.Validate("Drop Shipment", false);
                                PurchaseLine.Validate("Purchasing Code", '');

                                PurchaseLine.Modify(true);

                                // Mark as processed
                                IsProcessed := true;
                            end;
                        until PurchaseLine.Next() = 0;

                    // ✅ Show message only if something processed
                    if IsProcessed then
                        Message('The Drop Shipment Order has been successfully broken.')
                    else
                        Message('No Drop Shipment lines found to process.');
                end;
            }
            //TBC-964 <---
        }
        addafter(Print)
        {
            action(PrintPO)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Purchase Order ';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category10;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    PuchHeader: Record "Purchase Header";
                begin
                    PuchHeader.Reset();
                    PuchHeader.SetRange("Document Type", PuchHeader."Document Type"::Order);
                    PuchHeader.SetRange("No.", Rec."No.");

                    if not PuchHeader.FindFirst() then
                        Error('Purchase Order %1 not found.', Rec."No.");
                    COMMIT;
                    case PuchHeader."Purchase Type" of
                        PuchHeader."Purchase Type"::Domestic:
                            Report.RunModal(Report::CustomPurchaseOrder, true, false, PuchHeader);
                        PuchHeader."Purchase Type"::Import:
                            Report.RunModal(Report::"Import Purchase Order1", true, false, PuchHeader);
                        else
                            Report.RunModal(Report::CustomPurchaseOrder, true, false, PuchHeader);
                    end;
                end;
            }
            action(PrintAnnexure)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print PO Annexure ';
                Visible = Rec."Purchase Type" = Rec."Purchase Type"::Import;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category10;
                trigger OnAction()
                var
                    PuchHeader: Record "Purchase Header";
                begin
                    PuchHeader.Reset();
                    PuchHeader.SetRange("Document Type", PuchHeader."Document Type"::Order);
                    PuchHeader.SetRange("No.", Rec."No.");
                    if PuchHeader.FindFirst() then
                        Report.RunModal(Report::"Import PO Annexure", true, false, PuchHeader)
                end;
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        SyncCustomShipTo();
        UpdateShiptoforDropShip();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateShiptoforDropShip();
    end;

    trigger OnOpenPage()
    begin
        UpdateShiptoforDropShip();
    end;

    var
        YouCannotChangeShipToErr: Label 'You cannot change Ship-to Option because this PO is created from Special Sales Order.';

    local procedure ValidateAndSyncCustomShipTo()
    var
        PurchLine: Record "Purchase Line";
    begin

        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", Rec."No.");
        PurchLine.SetFilter("Sales Order Line No.", '<>0');
        if not PurchLine.IsEmpty() then begin
            if ShipToOptions <> ShipToOptions::Location then
                Error(YouCannotChangeShipToErr);
        end;
        if Rec."Sell-to Customer No." = '' then
            SyncCustomShipTo();
    end;

    local procedure SyncCustomShipTo()
    var
        NewValue: Enum "Purchase Order Ship-to Options";// replace with your enum
    begin
        Clear(NewValue);
        case ShipToOptions of
            ShipToOptions::Location:
                NewValue := Rec."Custom Ship-to"::Location;

            ShipToOptions::"Default (Company Address)":
                NewValue := Rec."Custom Ship-to"::"Default (Company Address)";

            ShipToOptions::"Customer Address":
                NewValue := Rec."Custom Ship-to"::"Customer Address";

            ShipToOptions::"Custom Address":
                NewValue := Rec."Custom Ship-to"::"Custom Address";
        end;

        if Rec."Custom Ship-to" <> NewValue then
            Rec.Validate("Custom Ship-to", NewValue);
    end;
    //Drop Shipment Ship-to updates 20-03-26
    procedure UpdateShiptoforDropShip()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", Rec."Document Type"::Order);
        PurchaseLine.SetRange("Document No.", Rec."No.");
        PurchaseLine.SetRange("Purchasing Code", 'DROP SHIP');
        if PurchaseLine.FindFirst() then begin
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.SetRange("No.", PurchaseLine."Sales Order No.");
            if SalesHeader.FindFirst() then begin
                if SalesHeader."Custom Ship-to" = SalesHeader."Custom Ship-to"::"Default (Sell-to Address)" then begin
                    Rec."Custom Ship-to" := Rec."Custom Ship-to"::"Customer Address";
                    ShipToOptions := ShipToOptions::"Customer Address";
                end else if SalesHeader."Custom Ship-to" = SalesHeader."Custom Ship-to"::"Alternate Shipping Address" then begin
                    Rec."Custom Ship-to" := Rec."Custom Ship-to"::"Customer Address";
                    ShipToOptions := ShipToOptions::"Customer Address";
                end else if SalesHeader."Custom Ship-to" = SalesHeader."Custom Ship-to"::"Custom Address" then begin
                    Rec."Custom Ship-to" := Rec."Custom Ship-to"::"Custom Address";
                    ShipToOptions := ShipToOptions::"Custom Address";
                end;

                Rec.Modify(false);
            end;
        end;
    end;
    //20-03-26
}
