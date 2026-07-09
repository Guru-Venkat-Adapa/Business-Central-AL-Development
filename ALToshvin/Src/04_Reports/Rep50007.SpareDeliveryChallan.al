report 50007 "Spare Delivery Challan"
{
    ApplicationArea = All;
    Caption = 'Spare Delivery Challan';
    UsageCategory = Lists;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\04_Reports\Layouts\DeliverChallanSpare.rdl';
    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            RequestFilterFields = "No.";

            column(InvoiceNo; "No.") { }
            column(InvoiceDate; "Posting Date") { }
            column(Customer_PO_No_; "Customer PO No.") { }
            column(Order_No_; "Order No.") { }
            column(External_Document_No_; "External Document No.") { }
            column(Customer_PO_Date; "Customer PO Date") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Your_Reference; "Your Reference") { }
            column(Ship_to_Customer; "Ship-to Customer") { }
            column(Order_Date; "Order Date") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_County; "Ship-to County") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code") { }
            column(Ship_to_GST_Reg__No_; Cust."GST Registration No.") { }
            column(ShhipToStateName; RecState.Description) { }
            column(ShipToStateCode; State) { }
            column(StateNo; StateNo) { }
            column(Ship_to_Contact; "Ship-to Contact") { }
            column(Ship_to_Phone_No_; "Ship-to Phone No.") { }

            column(DispatchName; Loc.Name) { }
            column(DispatchAddress; Loc.Address) { }
            column(DispatchAddress2; Loc."Address 2") { }
            column(DispatchCity; Loc.City) { }
            column(DispatchCounty; Loc.County) { }
            column(DispatchCountryRegionCode; Loc."Country/Region Code") { }
            column(DispatchPostCode; Loc."Post Code") { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyPostCode; companyinfo."Post Code") { }
            column(CompanyGSTNo; CompanyInfo."GST Registration No.") { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(CompanyRegNo; CompanyInfo."Registration No.") { }
            column(CompanyPANNo; CompanyInfo."P.A.N. No.") { }
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyGSTRegNo; CompanyInfo."GST Registration No.") { }
            column(Mode_of_Transport; "Mode of Transport") { }
            column(Freight; Freight) { }
            column(Remarks; Remarks) { }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.") WHERE(Quantity = FILTER(<> 0));
                DataItemLink = "Document No." = field("No.");

                column(ItemNo; "No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(UnitPrice; "Unit Price")
                {
                }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Bin_Code; "Bin Code") { }
                column(Whse__Receipt_No_; "WarehouseReceptNo") { }

                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLinkReference = "Sales Shipment Line";
                    DataItemTableView = sorting("Document No.", "Item No.", "Document Line No.");
                    DataItemLink = "Document No." = field("Document No."), "Item No." = field("No."), "Document Line No." = field("Line No.");
                    column(Lot_No_; "Lot No.") { }
                    column(ILE_Quantity; Abs(Quantity)) { }
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(WarehouseReceptNo);
                    PostedWarehoueRece.Reset();
                    PostedWarehoueRece.SetRange("Source No.", "Sales Shipment Line"."Special Order Purchase No.");
                    PostedWarehoueRece.SetRange("Source Line No.", "Sales Shipment Line"."Special Order Purch. Line No.");
                    if PostedWarehoueRece.FindFirst() then
                        WarehouseReceptNo := PostedWarehoueRece."Whse. Receipt No.";
                end;

            }
            trigger OnAfterGetRecord()
            var
            begin
                if Loc.Get("Sales Shipment Header"."Location Code") then;
                Clear(StateNo);
                IF RecState.Get("Sales Shipment Header".State) then;
                StateNo := RecState."State Code (GST Reg. No.)";
                if Cust.Get("Sales Shipment Header"."Sell-to Customer No.") then;
                if SellToContact.Get("Sales Shipment Header"."Sell-to Contact No.") then;

                Clear(Remarks);
                // SalesComments.Reset();
                // SalesComments.SetRange("No.", "Sales Shipment Header"."No.");
                // SalesComments.SetRange("Document Line No.", 0);
                // if SalesComments.FindSet() then
                //     repeat
                //         if Remarks = '' then
                //             Remarks := SalesComments.Comment
                //         else
                //             Remarks += ',' + SalesComments.Comment;
                //     until SalesComments.Next() = 0;

                //TBC-986 <----
                PostedWhseShipmentLine.Reset();
                PostedWhseShipmentLine.SetRange("Posted Source Document", PostedWhseShipmentLine."Posted Source Document"::"Posted Shipment");
                PostedWhseShipmentLine.SetRange("Posted Source No.", "Sales Shipment Header"."No.");
                if PostedWhseShipmentLine.FindFirst() then begin
                    PostedWhseShipmentHeader.Reset();
                    PostedWhseShipmentHeader.SetRange("No.", PostedWhseShipmentLine."No.");
                    if PostedWhseShipmentHeader.FindFirst() then
                        Remarks := PostedWhseShipmentHeader.Note;
                end;
                //TBC-986 ---->

            end;
        }
    }
    trigger OnPreReport()

    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        RecState: Record State;
        Loc: Record Location;
        SalesComments: Record "Sales Comment Line";
        Remarks: Text[1000];
        Cust: Record Customer;
        P: Page "Posted Sales Shipment";
        SellToContact: Record Contact;
        PostedWarehoueRece: Record "Posted Whse. Receipt Line";
        WarehouseReceptNo: Code[20];
        StateNo: Code[10];

        PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";

}
