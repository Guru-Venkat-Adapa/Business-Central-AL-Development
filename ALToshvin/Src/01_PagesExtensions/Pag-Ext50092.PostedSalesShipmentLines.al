pageextension 50092 "Posted Sales Shipment Lines" extends "Posted Sales Shipment Lines"
{
    layout
    {
        //TBC - 835 --->
        addbefore("No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Caption = 'Line No.';
                Editable = false;
            }
        }
        //TBC - 835 <---
        //TBC - 835 <---
        addafter("No.")
        {
            //TBC-983--->
            field(Prinicipal; Prinicipal)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Principal Name';
            }
            //TBC-983<---
        }
        addafter("Document No.")
        {
            //TBC-983 --->
            field("Sales Order Type"; SalesOrderType)
            {
                ApplicationArea = All;
                Caption = 'Sales Order Type';
                Editable = false;
            }
            //TBC-983 <---

            field(PostedInvoice; PostedInvoice)
            {
                ApplicationArea = All;
                Caption = 'Posted Invoice No.';
            }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                Caption = 'Invoice Posting Date';
            }
            field(SalesOrderNo; SalesOrderNo)
            {
                ApplicationArea = All;
                Caption = 'Sale Order#';
            }
            field(MasterSalesOrderNo; MasterSalesOrderNo)
            {
                ApplicationArea = All;
                Caption = 'Master Sale Order#';
            }
        }
        addafter("Sell-to Customer No.")
        {
            field(CustomerName; CustomerName)
            {
                ApplicationArea = All;
                Caption = 'Customer Name';
            }
        }
        addafter(Quantity)
        {
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = All;
            }
        }
        addafter("Quantity Invoiced")
        {
            field("Gross Value"; GrossValue)
            {
                ApplicationArea = All;
                Caption = 'Gross Value';
            }
        }
        //TBC - 762 -->
        addafter("Location Code")
        {
            field(LotNo; LotNo)
            {
                ApplicationArea = All;
                Caption = 'Lot No.';
            }
            //TBC-977 ---->
            field(LotDate; LotDate)
            {
                ApplicationArea = All;
                Caption = 'Lot Date';
                Editable = false;
            }
            field(PurchReceiptNo; PurchReceiptNo)
            {
                ApplicationArea = All;
                Caption = 'Posted Purchase Receipt No.';
                Editable = false;
            }
            field(PurchReceiptDate; PurchReceiptDate)
            {
                ApplicationArea = All;
                Caption = 'Posted Purchase Receipt Date';
                Editable = false;
            }
            //TBC-977 <----
        }
        addbefore(Quantity)
        {
            field(PurchaseRate; PurchaseRate)
            {
                ApplicationArea = All;
                Caption = 'Purchase cost';
            }
        }
        //TBC - 761 <--
    }
    trigger OnAfterGetRecord()
    var
    begin
        Clear(CustomerName);
        Clear(SalesOrderNo);
        Clear(MasterSalesOrderNo);
        Clear(GrossValue);
        Clear(SalesOrderType);
        if SalesShipmetHeader.Get(Rec."Document No.") then begin
            SalesOrderNo := SalesShipmetHeader."Order No.";
            MasterSalesOrderNo := SalesShipmetHeader."Master Sales Order Number";
            SalesOrderType := SalesShipmetHeader."Sales Order Type";  //TBC-983
        end;

        if Cust.Get(Rec."Sell-to Customer No.") then
            CustomerName := Cust.Name;

        GrossValue := Rec.Quantity * Rec."Unit Price";

        //TBC-983 --->
        Clear(Prinicipal);
        if RecItem.Get(Rec."No.") then
            Prinicipal := RecItem.Principal;
        //TBC-983 <---

        //TBC - 762 -->
        Clear(LotNo);
        Clear(PostedInvoice);
        Clear(PurchaseRate);
        Clear(PurchReceiptNo); //TBC-977
        Clear(PurchReceiptDate);//TBC-977
        Clear(LotDate); //TBC-977
        ILE.Reset();
        ILE.SetRange("Entry Type", ILE."Entry Type"::Sale);
        ILE.SetRange("Document Type", ILE."Document Type"::"Sales Shipment");
        ILE.SetRange("Document No.", Rec."Document No.");
        ILE.SetRange("Document Line No.", Rec."Line No.");
        if ILE.FindFirst() then begin
            LotNo := ILE."Lot No.";

            // //TBC-977 --->
            // ItemAppEntry.Reset();
            // ItemAppEntry.SetRange("Outbound Item Entry No.", ILE."Entry No.");
            // if ItemAppEntry.FindSet() then
            //     repeat
            //         if AppliedILE.Get(ItemAppEntry."Inbound Item Entry No.") then
            //             if AppliedILE."Document Type" = AppliedILE."Document Type"::"Purchase Receipt" then begin
            //                 PurchReceiptNo := AppliedILE."Document No.";
            //                 PurchReceiptDate := AppliedILE."Posting Date";
            //                 LotDate := AppliedILE."Posting Date";
            //                 exit;
            //             end;
            //     until ItemAppEntry.Next() = 0;
            // //TBC-977 <----
        end;

        //TBC-977 --->
        ItemLedEntry.Reset();
        ItemLedEntry.SetRange("Item No.", Rec."No.");
        ItemLedEntry.SetRange("Lot No.", LotNo);
        if ItemLedEntry.FindSet() then begin
            repeat
                // Direct document types
                if ItemLedEntry."Document Type" in
                   [ItemLedEntry."Document Type"::"Purchase Receipt",
                    ItemLedEntry."Document Type"::"Transfer Receipt",
                    ItemLedEntry."Document Type"::"Sales Return Receipt"]
                then begin
                    PurchReceiptNo := ItemLedEntry."Document No.";
                    PurchReceiptDate := ItemLedEntry."Posting Date";
                    LotDate := ItemLedEntry."Posting Date";
                    exit;
                end
                // Entry type check
                else if ItemLedEntry."Entry Type" in
                        [ItemLedEntry."Entry Type"::"Positive Adjmt.",
                         ItemLedEntry."Entry Type"::Sale]
                then begin
                    PurchReceiptNo := ItemLedEntry."Document No.";
                    PurchReceiptDate := ItemLedEntry."Posting Date";
                    LotDate := ItemLedEntry."Posting Date";
                    exit;
                end;
            until ItemLedEntry.Next() = 0;
        end;
        //TBC-977 <----


        SalesInvHeader.Reset();
        SalesInvHeader.SetRange("Order No.", Rec."Order No.");
        if SalesInvHeader.FindFirst() then
            PostedInvoice := SalesInvHeader."No.";

        ValueEntry.Reset();
        ValueEntry.SetRange("Document No.", Rec."Document No.");
        ValueEntry.SetFilter("Entry Type", '%1|%2', ValueEntry."Entry Type"::"Direct Cost", ValueEntry."Entry Type"::"Indirect Cost");
        ValueEntry.SetRange("Item No.", Rec."No.");
        if ValueEntry.FindSet() then
            repeat
                PurchaseRate += ValueEntry."Cost per Unit";
            until ValueEntry.Next() = 0;

        //TBC - 762 <--

    end;

    var
        CustomerName: Text;
        Cust: Record Customer;
        SalesShipmetHeader: Record "Sales Shipment Header";
        SalesOrderNo: Code[20];
        MasterSalesOrderNo: Code[20];

        GrossValue: Decimal;
        ILE: Record "Item Ledger Entry";
        LotNo: Code[50];
        SalesInvHeader: Record "Sales Invoice Header";
        PostedInvoice: Code[20];
        ValueEntry: Record "Value Entry";
        PurchaseRate: Decimal;
        PurchReceiptDate: Date;//TBC-977
        PurchReceiptNo: Code[20];//TBC-977
        ItemAppEntry: Record "Item Application Entry";//TBC-977
        AppliedILE: Record "Item Ledger Entry";//TBC-977
        LotDate: Date; //TBC-977
        SalesOrderType: Text; //TBC-983
        Prinicipal: Text;//TBC-983
        RecItem: Record Item;//TBC-983
        ItemLedEntry: Record "Item Ledger Entry";

}
