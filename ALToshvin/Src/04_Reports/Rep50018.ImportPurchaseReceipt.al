report 50018 "Import Purchase Receipt"
{
    ApplicationArea = All;
    Caption = 'Import Purchase Receipt';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\Reports\Layouts\ImportPurchaseReceipt.rdl';
    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Posted Purchase Receipt';

            column(No_; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Address; "Buy-from Address") { }
            column(Buy_from_Address_2; "Buy-from Address 2") { }
            column(Buy_from_City; "Buy-from City") { }
            column(Buy_from_County; "Buy-from County") { }
            column(Buy_from_Post_Code; "Buy-from Post Code") { }
            column(Buy_from_Country_Region_Code; "Buy-from Country/Region Code") { }
            column(Reference_Invoice_No_; "Reference Invoice No.") { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }
            column(CompanyCity; CompanyInfo.City) { }
            column(CompanyCounty; CompanyInfo.County) { }
            column(CompanyCountryReg; CompanyInfo."Country/Region Code") { }
            column(BankName; CompanyInfo."Bank Name") { }
            column(BankBranch; CompanyInfo."Bank Branch No.") { }
            column(BankAcNo; CompanyInfo."Bank Account No.") { }
            column(CompanyPhNo; CompanyInfo."Phone No.") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(CompanyPANNo; CompanyInfo."P.A.N. No.") { }
            column(CompanyHomePage; CompanyInfo."Home Page") { }
            column(PhoneNoCaptionLbl; PhoneNoCaptionLbl) { }
            column(HomePageCaptionLbl; HomePageCaptionLbl) { }
            column(EmailCaptionLbl; EmailCaptionLbl) { }
            column(BankNameCaptionLbl; BankNameCaptionLbl) { }
            column(AccNoCaptionLbl; AccNoCaptionLbl) { }
            column(DocDateCaptionLbl; DocDateCaptionLbl) { }
            column(ShipmentNoCaptionLbl; ShipmentNoCaptionLbl) { }
            column(PaytoVenNoCaptionLbl; PaytoVenNoCaptionLbl) { }
            column(BillOfEntryNoLbl; BillOfEntryNoLbl) { }
            column(BillOfEntryDateLbl; BillOfEntryDateLbl) { }
            column(VendorInvoiceDateLbl; VendorInvoiceDateLbl) { }
            column(VendorInvoiceNoLbl; VendorInvoiceNoLbl) { }
            column(VendorNameLbl; VendorNameLbl) { }

            column(Bill_of_Entry_No_; BillEntryNo) { }
            column(Bill_of_Entry_Date; BillEntryDate) { }
            column(VendorBillNo; VendorBillNo) { }
            column(VendorBillEntryDate; VendorBillEntryDate) { }
            dataitem(Location; Location)
            {
                DataItemLink = Code = field("Location Code");
                DataItemLinkReference = "Purch. Rcpt. Header";
                DataItemTableView = sorting(Code);

                column(Loc_Name; Name) { }
                column(Loc_Address; Address) { }
                column(Loc_Address_2; "Address 2") { }
                column(Loc_City; City) { }
                column(Loc_County; County) { }
                column(Loc_Post_Code; "Post Code") { }
                column(Loc_Country_Region_Code; "Country/Region Code") { }
            }

            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Purch. Rcpt. Header";
                DataItemTableView = sorting("Document No.", "Line No.") where(Quantity = filter(<> 0));

                column(Document_No_; "Document No.") { }
                column(Line_No_; "Line No.") { }
                column(Item_No_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure; "Unit of Measure") { }
                column(Bin_Code; BinCode) { }



                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLinkReference = "Purch. Rcpt. Line";
                    DataItemTableView = sorting("Document No.", "Item No.", "Document Line No.");
                    DataItemLink = "Document No." = field("Document No."), "Item No." = field("No."), "Document Line No." = field("Line No.");
                    column(Lot_No_; "Lot No.") { }
                }


                trigger OnAfterGetRecord()
                begin
                    Clear(BinCode);
                    BinContent.Reset();
                    BinContent.SetRange("Location Code", "Purch. Rcpt. Line"."Location Code");
                    BinContent.SetRange("Item No.", "Purch. Rcpt. Line"."No.");
                    if BinContent.FindFirst() then
                        BinCode := BinContent."Bin Code";



                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(BillEntryNo);
                Clear(BillEntryDate);
                Clear(VendorBillNo);
                Clear(VendorBillEntryDate);

                PostedWhseReceiptLine.Reset();
                PostedWhseReceiptLine.SetRange("Posted Source No.", "Purch. Rcpt. Header"."No.");
                if PostedWhseReceiptLine.FindFirst() then begin
                    PostedWhseReceiptHeader.Reset();
                    PostedWhseReceiptHeader.SetRange("No.", PostedWhseReceiptLine."No.");
                    if PostedWhseReceiptHeader.FindFirst() then begin
                        BillEntryNo := PostedWhseReceiptHeader."Bill of Entry No.";
                        BillEntryDate := PostedWhseReceiptHeader."Bill of Entry Date";
                        VendorBillNo := PostedWhseReceiptHeader."Vendor Bill No.";
                        VendorBillEntryDate := PostedWhseReceiptHeader."Vendor Bill Date";
                    end;
                end else begin
                    BillEntryNo := "Purch. Rcpt. Header"."Bill of Entry No.";
                    BillEntryDate := "Purch. Rcpt. Header"."Bill of Entry Date";
                    VendorBillNo := "Purch. Rcpt. Header"."Vendor Bill No.";
                    VendorBillEntryDate := "Purch. Rcpt. Header"."Vendor Bill Date";
                end;
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
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
        PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
        BillEntryNo: Code[20];
        BillEntryDate: Date;
        VendorBillNo: Code[20];
        VendorBillEntryDate: Date;
        PhoneNoCaptionLbl: Label 'Phone No.';
        HomePageCaptionLbl: Label 'Home Page';
        BankNameCaptionLbl: Label 'Bank';
        AccNoCaptionLbl: Label 'Account No.';
        ShipmentNoCaptionLbl: Label 'Receipt No.';
        DocDateCaptionLbl: Label 'Document Date';
        PaytoVenNoCaptionLbl: Label 'Pay-to Vendor Name';
        EmailCaptionLbl: Label 'Email';
        BillOfEntryNoLbl: Label 'Bill Of Entry No.';
        BillOfEntryDateLbl: Label 'Bill Of Entry Date';
        VendorNameLbl: Label 'Pay-to Vendor Name';
        VendorInvoiceNoLbl: Label 'Vendor Invoice No.';
        VendorInvoiceDateLbl: Label 'Vendor Invoice Date';
        BinContent: Record "Bin Content";
        BinCode: Code[20];
}
