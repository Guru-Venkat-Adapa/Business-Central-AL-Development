pageextension 50058 "Sales Line" extends "Sales Lines"
{
    layout
    {

        //TBC-1030  ---->
        addafter("Outstanding Quantity")
        {
            field("Outstanding Qty. (Base)"; Rec."Outstanding Qty. (Base)")
            {
                ApplicationArea = All;
            }
        }
        //TBC-1030 <----
        //TBC 1004 --->
        modify("Shipment Date")
        {
            Visible = false;
        }
        //TBC 1004 <---
        //TBC - 828  -->
        addafter("Document No.")
        {
            //TBC-988 --->
            field("Sales Order Type"; SalesOrderType)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Sales Order Type';
            }
            //TBC-988 <---
            //TBC 1004 ---->
            field(DeliveryChallan; DeliveryChallan)
            {
                ApplicationArea = All;
                Caption = 'Delivery Challan#';
                Editable = false;
            }
            field(ToshvinInvoice; ToshvinInvoice)
            {
                ApplicationArea = All;
                Caption = 'Toshvin invoice#';
                Editable = false;
            }
            //TBC 1004 <----
            field("Document Date"; DocumentDate)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Document Date';
            }
            //TBC-988 --->
            field(MasterSalesOrderNo; MasterSalesOrderNo)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Master Sales Order No.';
            }
            //TBC-988 <---
        }
        modify("Line No.")
        {
            Visible = true;
            Editable = false;
        }
        movebefore("No."; "Line No.")

        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
            Editable = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
            Editable = false;
        }
        modify("ShortcutDimCode[3]")
        {
            Visible = true;
            Editable = false;
        }
        moveafter("Location Code"; "Shortcut Dimension 1 Code")

        addafter("Shortcut Dimension 1 Code")
        {
            field(DepartmentName; DepartmentName)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Department Name';
            }
        }
        moveafter(DepartmentName; "Shortcut Dimension 2 Code")
        addafter("Shortcut Dimension 2 Code")
        {
            field(RegionName; RegionName)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Region Name';
            }
        }
        moveafter(RegionName; "ShortcutDimCode[3]")
        addafter("ShortcutDimCode[3]")
        {
            field(TeamsName; TeamsName)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Teams Name';
            }
        }
        //TBC - 828 <--
        addbefore(Quantity)
        {
            //TBC-988 --->
            field("Purchasing Code"; Rec."Purchasing Code")
            {
                ApplicationArea = All;
            }
            //TBC-988 <---
            //TBC 1004 --->
            field("Special Order Purchase No."; Rec."Special Order Purchase No.")
            {
                ApplicationArea = All;
                Caption = 'Special Order PO#';
                Editable = false;
            }
            field(DropShipPO; DropShipPO)
            {
                ApplicationArea = All;
                Caption = 'Drop Ship PO#';
                Editable = false;
            }
            Field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order#';
                Editable = false;
            }
            //TBC 1004 <---
            field("HSN/SAC Code"; Rec."HSN/SAC Code")
            {
                ApplicationArea = All;
            }
        }
        //TBC-988 --->
        addafter(Quantity)
        {
            field(LotNo; LotNo)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Lot No.';
            }
            field(TrackingQty; TrackingQty)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Tracking Quantity';
            }
        }
        addafter("Outstanding Quantity")
        {
            field(Status; Status)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Status';
            }
        }
        addafter("Sell-to Customer Name")
        {
            field(DealerCustomerName; DealerCustomerName)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Dealer Customer Name';
            }
            field(AssignedUserID; AssignedUserID)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Assigned User ID';
            }
        }
        //TBC-988 <---
    }
    actions
    {
        addlast(Processing)
        {
            action(ValidateAllQuantities)
            {
                Caption = 'Validate Quantity for All';
                Image = Check;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                    CountLines: Integer;
                    CalculateTax: Codeunit "Calculate Tax";
                begin
                    // Copy filters from the page record to Sales Line
                    SalesLine.CopyFilters(Rec);
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetFilter("HSN/SAC Code", '<>%1', '');
                    if SalesLine.FindSet() then begin
                        repeat
                            SalesLine.Validate(Quantity, SalesLine.Quantity);
                            SalesLine.Validate("HSN/SAC Code", SalesLine."HSN/SAC Code");
                            SalesLine.Modify(true);
                            CalculateTax.CallTaxEngineOnSalesLine(SalesLine, SalesLine);
                            CountLines += 1;
                        until SalesLine.Next() = 0;
                        Message('Quantity validated successfully for %1 lines.', CountLines);
                    end else
                        Message('No Sales Lines found to validate.');
                    CurrPage.Update(true);
                end;
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        //TBC - 828  -->
        Clear(DepartmentName);
        Clear(RegionName);
        Clear(TeamsName);
        Clear(SalesOrderType);
        Clear(Status);
        Clear(AssignedUserID);
        Clear(DealerCustomerName);
        Clear(MasterSalesOrderNo);


        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            DocumentDate := SalesHeader."Document Date";
            SalesOrderType := SalesHeader."Sales Order Type";  //TBC-988
            Status := SalesHeader.Status; //TBc-988
            AssignedUserID := SalesHeader."Custom Assigned User ID"; //TBC-988
            MasterSalesOrderNo := SalesHeader."Master Sales Order Number"; //TBC-988

            if SalesHeader."Dealer Customer" then
                DealerCustomerName := SalesHeader."Dealer Customer Name"
            else
                DealerCustomerName := '';

            Dimension.Reset();
            Dimension.SetRange(Code, SalesHeader."Shortcut Dimension 3 Code");
            if Dimension.FindFirst() then
                TeamsName := Dimension.Name;

        end;

        Dimension.Reset();
        Dimension.SetRange(Code, Rec."Shortcut Dimension 1 Code");
        if Dimension.FindFirst() then
            DepartmentName := Dimension.Name;

        Dimension.Reset();
        Dimension.SetRange(Code, Rec."Shortcut Dimension 2 Code");
        if Dimension.FindFirst() then
            RegionName := Dimension.Name;
        //TBC - 828  <--

        //TBC 1004 --->
        Clear(DropShipPO);

        if Rec."Drop Shipment" then begin
            PurchaseLine.Reset();
            PurchaseLine.SetRange("Drop Shipment", true);
            PurchaseLine.SetRange("Sales Order No.", Rec."Document No.");
            PurchaseLine.SetRange("Sales Order Line No.", Rec."Line No.");
            if PurchaseLine.FindFirst() then
                DropShipPO := PurchaseLine."Document No."
            else
                DropShipPO := '';
        end else
            DropShipPO := '';

        Clear(DeliveryChallan);
        Clear(ToshvinInvoice);
        SalesShipmentHeader.Reset();
        SalesShipmentHeader.SetRange("Order No.", Rec."Document No.");
        if SalesShipmentHeader.FindSet() then
            repeat
                if DeliveryChallan = '' then
                    DeliveryChallan := SalesShipmentHeader."No."
                else
                    DeliveryChallan += ',' + SalesShipmentHeader."No.";
            until SalesShipmentHeader.Next() = 0;

        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("Order No.", Rec."Document No.");
        if SalesInvoiceHeader.FindSet() then
            repeat
                if ToshvinInvoice = '' then
                    ToshvinInvoice := SalesInvoiceHeader."No."
                else
                    ToshvinInvoice += ',' + SalesInvoiceHeader."No.";
            until SalesInvoiceHeader.Next() = 0;
        //TBC 1004 <---

        //TBC-1061 --->
        Clear(LotNo);
        Clear(TrackingQty);
        // First try Reservation Entry (reserved + lot assigned)
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Source Subtype", Rec."Document Type".AsInteger());
        ReservationEntry.SetRange("Source ID", Rec."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", Rec."Line No.");
        ReservationEntry.SetFilter("Lot No.", '<>%1', '');
        if ReservationEntry.FindFirst() then begin
            LotNo := ReservationEntry."Lot No.";
            TrackingQty := Abs(ReservationEntry."Quantity (Base)");
        end else begin
            // Fallback: Tracking Specification (lot assigned but not reserved)
            TrackingSpecification.Reset();
            TrackingSpecification.SetRange("Source Type", Database::"Sales Line");
            TrackingSpecification.SetRange("Source Subtype", Rec."Document Type".AsInteger());
            TrackingSpecification.SetRange("Source ID", Rec."Document No.");
            TrackingSpecification.SetRange("Source Ref. No.", Rec."Line No.");
            TrackingSpecification.SetFilter("Lot No.", '<>%1', '');
            if TrackingSpecification.FindFirst() then begin
                LotNo := TrackingSpecification."Lot No.";
                TrackingQty := Abs(TrackingSpecification."Quantity (Base)");
            end;
        end;
        //TBC-1061 <---

    end;

    var
        DocumentDate: Date;
        SalesHeader: Record "Sales Header";
        Dimension: Record "Dimension Value";
        RegionName: Text;
        DepartmentName: Text;
        TeamsName: Text;
        SalesOrderType: Text;
        Status: Enum "Sales Document Status";
        AssignedUserID: Text;
        DealerCustomerName: Text;
        MasterSalesOrderNo: Code[20];
        TrackingQty: Decimal;
        PurchaseLine: Record "Purchase Line";
        DropShipPO: Code[20];
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        DeliveryChallan: Text;
        ToshvinInvoice: Text;
        ReservationEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification";
        LotNo: Code[50];

}
