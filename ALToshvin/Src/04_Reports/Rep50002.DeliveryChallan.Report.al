report 50002 DeliveryChallan
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Delivery Challan';
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\04_Reports\Layouts\DeliveryChallan.rdl';

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(No_; "No.") { }
            column(Order_Date; OrderDate) { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Sell_to_Address; "Sell-to Address") { }
            column(Sell_to_Address_2; "Sell-to Address 2") { }
            column(Your_Reference; "Your Reference") { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
            column(Mode_of_Transport; "Mode of Transport") { }
            column(Vehicle_Type; "Vehicle Type") { }
            column(GSTNo; GSTNo) { }
            column(StateName; StateName) { }
            column(StateCode; StateCode) { }

            //<------------     Lables     --------------------------->
            column(DeliveryChalanLbl; DeliveryChalanLbl) { }
            column(DispatchLocLbl; DispatchLocLbl) { }
            column(CustomerCodeLbl; CustomerCodeLbl) { }
            column(ConsigneeLbl; ConsigneeLbl) { }
            column(AddressLbl; AddressLbl) { }
            column(GSTINLbl; GSTINLbl) { }
            column(KindAttLbl; KindAttLbl) { }
            column(ContactLbl; ContactLbl) { }
            column(StateNameLbl; StateNameLbl) { }
            column(StateCodeLbl; StateCodeLbl) { }
            column(DCnoLbl; DCnoLbl) { }
            column(DCDateLbl; DCDateLbl) { }
            column(OurRefLbl; OurRefLbl) { }
            column(PONoLbl; PONoLbl) { }
            column(PODateLbl; PODateLbl) { }
            column(MOTLbl; MOTLbl) { }
            column(TransporterLbl; TransporterLbl) { }
            column(FreightLbl; FreightLbl) { }
            //<-----------            Footer Lables  ----------------------->
            column(Todaydate; Todaydate) { }
            column(TodayTime; TodayTime) { }
            column(ReceivedFooterLbl; ReceivedFooterLbl) { }
            column(ToshvinFooterLbl; ToshvinFooterLbl) { }
            column(AuthorizedFooterLbl; AuthorizedFooterLbl) { }
            column(FooterLbl; FooterLbl) { }
            column(PrintDtFooterLbl; PrintDtFooterLbl) { }
            column(PrintTimeFooterLbl; PrintTimeFooterLbl) { }
            column(PageFooterLbl; PageFooterLbl) { }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Shipment Header";
                DataItemTableView = sorting("Document No.", "Line No.");
                column(Item_No; "No.") { }
                column(Item_Description; Description) { }
                column(Quantity; Quantity) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Bin_Code; "Bin Code") { }
                column(SrNoLbl; SrNoLbl) { }
                column(CodeLbl; CodeLbl) { }
                column(DescriptionLbl; DescriptionLbl) { }
                column(HSNLbl; HSNLbl) { }
                column(QtyLbl; QtyLbl) { }
                column(GRNLbl; GRNLbl) { }
                column(WHBinLbl; WHBinLbl) { }
                dataitem(Location; Location)
                {
                    DataItemLink = Code = field("Location Code");
                    DataItemLinkReference = "Sales Shipment Header";
                    DataItemTableView = sorting(Code);
                    column(Loc_Add; Address) { }
                    column(Loc_Add2; "Address 2") { }
                    column(Loc_Post_Code; "Post Code") { }
                }
            }
            trigger OnAfterGetRecord()
            var
                State: Record State;
                Customer: Record Customer;
            // SalesShipmentLines: Record "Sales Shipment Line";
            // PurchaseLine: Record "Purchase Line";
            begin
                OrderDate := Format("Order Date", 0, '<Day,2>/<Month,2>/<Year4>');
                // <--------           State Name and  State Code from State table     ---------->
                State.SetRange(Code, "Sales Shipment Header"."GST Bill-to State Code");
                if State.FindFirst() then begin
                    StateName := State.Description;
                    StateCode := State."State Code (GST Reg. No.)";
                end;
                // <---------------           GST Number from Customer      -------------------->
                if Customer.get("Sell-to Customer No.") then
                    GSTNo := Customer."GST Registration No.";
                /*<------------          Purchase Order Number and purchase date from purchase lines        -----------> */
                // "Sales Shipment Line".SetRange("Document No.", "Sales Shipment Header"."No.");
                // if SalesShipmentLines.FindSet() then
                //     repeat
                //         PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                //         PurchaseLine.SetRange("Special Order Sales No.", SalesShipmentLines."Purchase Order No.");
                //         if PurchaseLine.FindFirst() then begin
                //             PoNo := PurchaseLine."Document No.";
                //             PoDate := Format(PurchaseLine."Order Date", 0, '<Day,2>/<Month,2>/<Year4>');
                //         end;
                //     until SalesShipmentLines.Next() = 0;
            end;
        }
    }
    trigger OnPreReport()

    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
        Todaydate := Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4>');
        TodayTime := System.DT2Time(CurrentDateTime);
    end;

    var
        CompanyInfo: Record "Company Information";
        GSTNo: Text[50];
        StateName: Text[50];
        StateCode: Text[10];
        Todaydate: Text;
        TodayTime: Time;
        // PoNo: Text;
        // PoDate: Text;
        OrderDate: Text;
        DeliveryChalanLbl: Label 'DELIVERY CHALLAN';
        DispatchLocLbl: Label 'Dispatch Location :';
        CustomerCodeLbl: Label 'Customer Code :';
        ConsigneeLbl: Label 'Consignee :';
        AddressLbl: Label 'Address :';
        GSTINLbl: Label 'GSTIN No. :';
        KindAttLbl: Label 'Kind Attn :';
        ContactLbl: Label 'Contact No. :';
        StateNameLbl: Label 'State :';
        StateCodeLbl: Label 'State Code :';
        DCnoLbl: Label 'DC No. :';
        DCDateLbl: Label 'DC Date :';
        OurRefLbl: Label 'Our Ref. :';
        PONoLbl: Label 'PO No. :';
        PODateLbl: Label 'PO Date :';
        MOTLbl: Label 'Mode of Transport :';
        TransporterLbl: Label 'Transporter :';
        FreightLbl: Label 'Freight :';
        SrNoLbl: Label 'Sr No.';
        CodeLbl: Label 'Code';
        DescriptionLbl: Label 'Description';
        HSNLbl: Label 'HSN/SAC';
        QtyLbl: Label 'Qty';
        GRNLbl: label 'GRN Ref.';
        WHBinLbl: Label 'WH. Bin';
        ReceivedFooterLbl: Label 'Received goods in good order & condition';
        ToshvinFooterLbl: Label 'For TOSHVIN ANALYTICAL PVT.LTD.';
        AuthorizedFooterLbl: Label 'AUTHORISED SIGNATORY';
        FooterLbl: Label 'THIS IS COMPUTER GENERATED INVOICE HENCE, NO SIGNATURE REQUIRED.';
        PrintDtFooterLbl: Label 'Print Date :';
        PrintTimeFooterLbl: Label 'Print Time :';
        PageFooterLbl: Label 'Page No. :';
}