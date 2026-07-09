report 50011 ImportPurchaseOrder
{
    ApplicationArea = All;
    Caption = 'Purchase Order - Import';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\04_Reports\Layouts\ImportPurchaseOrder.rdlc';
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Purchase - Order';
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyInfoAddress; CompanyInfo.Address) { }
            column(CompanyInfoAddress2; CompanyInfo."Address 2") { }
            column(GSTNo; CompanyInfo."GST Registration No.") { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyPostCode; companyinfo."Post Code") { }
            //-------------   Vendor Details
            column(VendorName; "Buy-from Vendor Name") { }
            column(VendorNo; "Buy-from Vendor No.") { }
            column(VendorAddress; "Buy-from Address") { }
            column(VendorAddress2; "Buy-from Address 2") { }
            column(VendorCity; "Buy-from City") { }
            column(VendorCounty; "Buy-from County") { }
            column(VendorPostCode; "Buy-from Post Code") { }
            //--------------  Bill to Details
            column(Pay_to_Vendor_No_; "Pay-to Vendor No.") { }
            column(Pay_to_Name; "Pay-to Name") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(Pay_to_Address_2; "Pay-to Address 2") { }
            column(Pay_to_City; "Pay-to City") { }
            column(Pay_to_Post_Code; "Pay-to Post Code") { }
            //----------------- Ship to Details
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }

            //---------------   Order Details
            column(PuchOrderNo_; "No.") { }
            column(PuchOrdPostDt; PostingDateFormat) { }
            column(PuchOrdPayment_Terms_Code; "Payment Terms Code") { }
            column(Your_Reference; "Your Reference") { }
            column(CurrencyDesc; CurrencyDesc) { }
            // column(Transportation_Chg_; "Transportation Chg.") { }
            column(Delivery_Terms; "Delivery Terms") { }

            // -------- Labels
            column(VendorDetailLbl; VendorDetailLbl) { }
            column(PurchaseDetailLbl; PurchaseDetailLbl) { }
            column(PoNoLbl; PoNoLbl) { }
            column(PODateLbl; PODateLbl) { }
            column(OurRefLbl; OurRefLbl) { }
            column(TransportChgLbl; TransportChgLbl) { }
            column(DiliveryTermLbl; DiliveryTermLbl) { }
            column(PaymentTermLbl; PaymentTermLbl) { }
            column(BilltoLbl; BilltoLbl) { }
            column(ShiptoAddressLbl; ShiptoAddressLbl) { }
            column(AnnextureLbl; AnnextureLbl) { }
            column(CurrencyLbl; CurrencyLbl) { }
            column(SlNoLbl; SlNoLbl) { }
            column(PartNoLbl; PartNoLbl) { }
            column(DescriptionLbl; DescriptionLbl) { }
            column(RemarkLbl; RemarkLbl) { }
            column(OrCodeLbl; OrCodeLbl) { }
            column(QtyLbl; QtyLbl) { }
            column(RateLbl; RateLbl) { }
            column(GrossLbl; GrossLbl) { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemLinkReference = "Purchase Header";
                column(ItemNo; "No.") { }
                column(ItemDescription; Description) { }
                column(ItemQuantity; Quantity) { }
                column(ItemUnit_Price; "Direct Unit Cost") { }
                column(ItemLine_Amount; "Line Amount") { }
                column(Narration; Narration) { }
                trigger OnAfterGetRecord()
                var
                    PuchCommentLine: Record "Purch. Comment Line";
                begin
                    PuchCommentLine.SetRange("Document Type", "Purchase Line"."Document Type"::Order);
                    PuchCommentLine.SetRange("No.", "Purchase Line"."Document No.");
                    PuchCommentLine.SetRange("Line No.", "Purchase Line"."Line No.");
                    if PuchCommentLine.findfirst() then
                        Narration := PuchCommentLine.Comment
                    else
                        Narration := '';
                    // until SalesCommentLine.Next() = 0;
                end;
            }
            trigger OnAfterGetRecord()
            var
                Currency: Record Currency;
            begin
                PostingDateFormat := Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                if Currency.get("Purchase Header"."Currency Code") then
                    CurrencyDesc := Currency.Description;
            end;
        }
    }
    trigger OnPreReport()
    var
        State: Record State;
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
        If State.Get(CompanyInfo."State Code") then
            CompState := State.Description;
        CurrentDate := DT2Date(CurrentDateTime);
        CurrentDateFormat := Format(CurrentDate, 0, '<Day,2>/<Month,2>/<Year4>');

        CurrentTime := DT2Time(CurrentDateTime);
    end;

    var
        CompanyInfo: Record "Company Information";
        CompState: Text[50];
        CurrentDate: Date;
        CurrentTime: Time;
        CurrentDateFormat: Text;
        PostingDateFormat: Text;
        CurrencyDesc: Text[50];
        Narration: Text;
        VendorDetailLbl: Label 'Vendor Details';
        CurrencyLbl: Label 'Currency';
        PurchaseDetailLbl: Label 'Purchase Details';
        PoNoLbl: Label 'PO No. :';
        PODateLbl: Label 'PO Date :';
        OurRefLbl: Label 'Our Ref :';
        TransportChgLbl: Label 'Transportation Chg :';
        DiliveryTermLbl: Label 'Dilivery Terms :';
        PaymentTermLbl: Label 'Payment Terms :';
        BilltoLbl: Label 'Bill to :';
        ShiptoAddressLbl: Label 'Ship to Address :';
        AnnextureLbl: Label 'ANNEXURE';
        SlNoLbl: Label 'Sl No.';
        PartNoLbl: Label 'Part No.';
        DescriptionLbl: Label 'Description';
        RemarkLbl: Label 'Remark';
        OrCodeLbl: Label 'Or Code';
        QtyLbl: Label 'Qty';
        RateLbl: Label 'Rate';
        GrossLbl: Label 'Gross';
}
