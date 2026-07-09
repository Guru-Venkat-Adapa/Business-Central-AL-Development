pageextension 50093 "Posted Sales Invoice Lines" extends "Posted Sales Invoice Lines"
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
        addafter("Document No.")
        {
            //TBC-967 --->
            field(SalesOrderType; SalesOrderType)
            {
                ApplicationArea = All;
                Caption = 'Sales Order Type';
            }
            //TBC-967 <---
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                Caption = 'Invoice Posting Date';
            }
            field(Rec; Rec."Order No.")
            {
                ApplicationArea = All;
                Caption = 'Sales Order#';
            }
            field(MasterSalesOrderNo; MasterSalesOrderNo)
            {
                ApplicationArea = All;
                Caption = 'Master Sale Order#';
            }
        }

        addafter("Line Discount %")
        {
            field("Gross Value"; GrossValue)
            {
                ApplicationArea = All;
                Caption = 'Gross Value';
            }
        }
        //TBC 891 -->
        addafter("Sell-to Customer Name")
        {
            field(CustomerCity; CustomerCity)
            {
                ApplicationArea = All;
                Caption = 'Customer City';
            }
            field(CustomerPO; CustomerPO)
            {
                ApplicationArea = All;
                Caption = 'Customer PO No.';
            }
            field(CustomerPODate; CustomerPODate)
            {
                ApplicationArea = All;
                Caption = 'Customer PO Date';
            }
            field(DepartmentName; DepartmentName)
            {
                ApplicationArea = All;
                Caption = 'Department Name';
            }
            field(RegionName; RegionName)
            {
                ApplicationArea = All;
                Caption = 'Region Name';
            }
            field(TeamsName; TeamsName)
            {
                ApplicationArea = All;
                Caption = 'Teams Name';
            }
            field(ExecutiveMaster; ExecutiveMaster)
            {
                ApplicationArea = All;
                Caption = 'Service Person ID';
            }
            field(ExecutiveMaster2; ExecutiveMaster2)
            {
                ApplicationArea = All;
                Caption = 'Executive Master 2';
            }
            //TBC-897 --->
            field(LotNo; LotNo)
            {
                ApplicationArea = All;
                Caption = 'Lot No.';
            }
            field(PurchaseOrderNo; PurchaseOrderNo)
            {
                ApplicationArea = All;
                Caption = 'Purchase Order#';
            }
            field(PurchaseOrderDate; PurchaseOrderDate)
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Date';
            }
            field(PurchaseOrderValue; PurchaseOrderValue)
            {
                ApplicationArea = All;
                Caption = 'Purchase Order value';
            }
            //TBC-897 <---
            field("GST Customer Type"; Rec."GST Customer Type")
            {
                ApplicationArea = All;
            }
            field(ServiceType; ServiceType)
            {
                ApplicationArea = All;
                Caption = 'Service Type';
            }
            field(ServiceDescription; ServiceDescription)
            {
                ApplicationArea = All;
                Caption = 'Service Description';
            }
            field(VisitDate; VisitDate)
            {
                ApplicationArea = All;
                Caption = 'Visit Date';
            }
            field(ContractStartDate; ContractStartDate)
            {
                ApplicationArea = All;
                Caption = 'Contract From';
            }
            field(ContractEndDate; ContractEndDate)
            {
                ApplicationArea = All;
                Caption = 'Contract To';
            }

            field("CMC/AMC Start Date"; Rec."CMC/AMC Start Date")
            {
                ApplicationArea = All;
                Caption = 'Contract Period Start Date';
            }
            field("CMC/AMC End Date"; Rec."CMC/AMC End Date")
            {
                ApplicationArea = All;
                Caption = 'Contract Period End Date';
            }

        }
        addafter("Unit Price")
        {
            field("GST Group Code"; Rec."GST Group Code")
            {
                ApplicationArea = All;
            }
            field("CGST Percentage"; CGSTPer)
            {
                ApplicationArea = all;
                Caption = 'CGST %';
            }
            field("CGST Amount"; CGSTAmt)
            {
                ApplicationArea = All;
                Caption = 'CGST Amount';
            }
            field("SGST Percentage"; SGSTPer)
            {
                ApplicationArea = All;
                Caption = 'SGST %';
            }
            field("SGST Amount"; SGSTAmt)
            {
                ApplicationArea = All;
                Caption = 'SGST Amount';
            }
            field("IGST Percentage"; IGSTPer)
            {
                ApplicationArea = All;
                Caption = 'IGST %';
            }
            field("IGST Amount"; IGSTAmt)
            {
                ApplicationArea = All;
                Caption = 'IGST Amount';
            }
        }
        moveafter("IGST Amount"; "Amount Including VAT")

        addafter(Description)
        {
            field(PrincipalName; PrincipalName)
            {
                ApplicationArea = All;
                Caption = 'Principal Name';
            }

            field("HSN/SAC Code"; Rec."HSN/SAC Code")
            {
                ApplicationArea = All;
            }
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Line Discount %")
        {
            field(LineAmountIncludingGST; LineAmountIncludingGST)
            {
                ApplicationArea = All;
                Caption = 'Line Amount Including GST';
                Editable = false;
            }
            field(OrderComments; OrderComments)
            {
                ApplicationArea = All;
                Caption = 'Order Comment';
            }
            field(LineComments; LineComments)
            {
                ApplicationArea = All;
                Caption = 'Line Comment';
            }
        }
        //TBC 891 <--
    }
    trigger OnAfterGetRecord()
    var
    begin

        Clear(GrossValue);
        Clear(MasterSalesOrderNo);
        Clear(SalesOrderType); //TBC-967
        if SalesInvoicetHeader.Get(Rec."Document No.") then begin
            MasterSalesOrderNo := SalesInvoicetHeader."Master Sales Order Number";
            SalesOrderType := SalesInvoicetHeader."Sales Order Type";//TBC-967
        end;
        //TBC-967 --->
        If RecItem.Get(Rec."No.") then
            PrincipalName := Rec.Principal;
        //TBC-967 <---

        GrossValue := Rec.Quantity * Rec."Unit Price";

        //TBC - 891 -->
        Clear(RegionName);
        Clear(DepartmentName);
        Clear(TeamsName);
        Clear(CustomerCity);
        Clear(CustomerPO);
        Clear(CustomerPODate);
        Clear(ServiceType);
        Clear(ServiceDescription);
        Clear(OrderComments);
        Clear(LineComments);
        Clear(VisitDate);
        Clear(ContractStartDate);
        Clear(ContractEndDate);
        Clear(ExecutiveMaster);
        Clear(ExecutiveMaster2);


        Dimension.Reset();
        Dimension.SetRange(Code, Rec."Shortcut Dimension 1 Code");
        if Dimension.FindFirst() then
            DepartmentName := Dimension.Name;

        Dimension.Reset();
        Dimension.SetRange(Code, Rec."Shortcut Dimension 2 Code");
        if Dimension.FindFirst() then
            RegionName := Dimension.Name;

        SalesInvoicetHeader.Reset();
        SalesInvoicetHeader.SetRange("No.", Rec."Document No.");
        if SalesInvoicetHeader.FindFirst() then begin
            if Rec.Type = Rec.Type::Item then begin
                Dimension.Reset();
                Dimension.SetRange(Code, SalesInvoicetHeader."Shortcut Dimension 3 Code");
                if Dimension.FindFirst() then
                    TeamsName := Dimension.Name;

                if Cust.Get(Rec."Sell-to Customer No.") then
                    CustomerCity := Cust.City;

                CustomerPO := SalesInvoicetHeader."External Document No.";
                CustomerPODate := SalesInvoicetHeader."Customer PO Date";
                ServiceType := SalesInvoicetHeader.Service_Type_;
                ServiceDescription := SalesInvoicetHeader."Service Description";
                VisitDate := SalesInvoicetHeader."Visit Date";
                ContractStartDate := SalesInvoicetHeader."Contract Start Date";
                ContractEndDate := SalesInvoicetHeader."Contract End Date";
                ExecutiveMaster := SalesInvoicetHeader."Executive Master";
                ExecutiveMaster2 := SalesInvoicetHeader."Executive Master2";

                Clear(OrderComments);
                SalesCommentLine.Reset();
                SalesCommentLine.SetRange("No.", SalesInvoicetHeader."No.");
                SalesCommentLine.SetRange("Document Line No.", 0);
                if SalesCommentLine.FindSet() then
                    repeat
                        if OrderComments = '' then
                            OrderComments := SalesCommentLine.Comment
                        else
                            OrderComments := OrderComments + ' ' + SalesCommentLine.Comment;
                    until SalesCommentLine.Next() = 0;

                Clear(LineComments);
                SalesCommentLine.Reset();
                SalesCommentLine.SetRange("No.", SalesInvoicetHeader."No.");
                SalesCommentLine.SetRange("Document Line No.", Rec."Line No.");
                if SalesCommentLine.FindSet() then
                    repeat
                        if LineComments = '' then
                            LineComments := SalesCommentLine.Comment
                        else
                            LineComments := LineComments + ' ' + SalesCommentLine.Comment;
                    until SalesCommentLine.Next() = 0;
            end;
        end;
        //TBC - 891 <--

        // TBC-897 -->
        SalesShipmentLine.Reset();
        SalesShipmentLine.SetRange("Order No.", Rec."Order No.");
        SalesShipmentLine.SetRange("Order Line No.", Rec."Order Line No.");
        SalesShipmentLine.SetRange(Type, SalesShipmentLine.Type::Item);
        if SalesShipmentLine.FindFirst() then begin
            PurchaseOrderNo := SalesShipmentLine."Special Order Purchase No.";

            ILE.Reset();
            ILE.SetRange("Entry Type", ILE."Entry Type"::Sale);
            ILE.SetRange("Document Type", ILE."Document Type"::"Sales Shipment");
            ILE.SetRange("Document No.", SalesShipmentLine."Document No.");
            ILE.SetRange("Document Line No.", SalesShipmentLine."Line No.");
            if ILE.FindFirst() then
                LotNo := ILE."Lot No.";
        end;

        if PurchaseOrderNo <> '' then begin
            PurchHeader.Reset();
            PurchHeader.SetRange("No.", PurchaseOrderNo);
            if PurchHeader.FindFirst() then begin
                PurchaseOrderDate := PurchHeader."Posting Date";
                PurchHeader.CalcFields(Amount);
                PurchaseOrderValue := PurchHeader.Amount;
            end else begin

                PurchHeaderArchive.Reset();
                PurchHeaderArchive.SetRange("No.", PurchaseOrderNo);
                if PurchHeaderArchive.FindLast() then begin
                    PurchaseOrderDate := PurchHeaderArchive."Posting Date";
                    PurchHeaderArchive.CalcFields(Amount);
                    PurchaseOrderValue := PurchHeaderArchive.Amount;
                end;
            end;
        end;
        // TBC-897 <--

        //TBC-1050 --->
        Clear(IGSTAmt);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        Clear(IGSTPer);
        Clear(CGSTPer);
        Clear(SGSTPer);
        Clear(LineAmountIncludingGST);
        DetGSTLedgerEntry.Reset();
        DetGSTLedgerEntry.SetRange("Document No.", Rec."Document No.");
        DetGSTLedgerEntry.SetRange("Document Line No.", Rec."Line No.");
        DetGSTLedgerEntry.SetRange("Document Type", DetGSTLedgerEntry."Document Type"::Invoice);
        if DetGSTLedgerEntry.FindSet() then
            repeat
                case DetGSTLedgerEntry."GST Component Code" of
                    'IGST':
                        begin
                            IGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            IGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                    'CGST':
                        begin
                            CGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            CGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                    'SGST':
                        begin
                            SGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            SGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                end;
            until DetGSTLedgerEntry.Next() = 0;
        LineAmountIncludingGST := Rec.Amount + CGSTAmt + SGSTAmt + IGSTAmt;
        //TBC-1050 <---
    end;

    var
        SalesInvoicetHeader: Record "Sales Invoice Header";
        MasterSalesOrderNo: Code[20];
        GrossValue: Decimal;
        Dimension: Record "Dimension Value";
        RegionName: Text;
        DepartmentName: Text;
        TeamsName: Text;
        Cust: Record Customer;
        CustomerCity: Text;
        CustomerPO: Code[35];
        CustomerPODate: Date;
        ServiceType: Code[20];
        ServiceDescription: Text;
        VisitDate: Date;
        ExecutiveMaster: Text;
        OrderComments: Text;
        LineComments: Text;
        SalesCommentLine: Record "Sales Comment Line";
        ContractStartDate: Date;
        ContractEndDate: Date;
        ExecutiveMaster2: Text;
        LotNo: code[50];  //TBC-897
        PurchaseOrderNo: Code[20];//TBC-897
        PurchaseOrderDate: Date;//TBC-897
        PurchaseOrderValue: Decimal;//TBC-897
        SalesShipmentLine: Record "Sales Shipment Line";//TBC-897
        PurchHeader: Record "Purchase Header";//TBC-897
        ILE: Record "Item Ledger Entry";//TBC-897
        PurchHeaderArchive: Record "Purchase Header Archive";//TBC-897
        SalesOrderType: Text; //TBC-967
        PrincipalName: Text; //TBC-967
        RecItem: Record Item;//TBC-967
        DetGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        SGSTPer: Decimal;
        LineAmountIncludingGST: Decimal;
}
