report 50019 "Domestic GRN"
{
    ApplicationArea = All;
    Caption = 'Domestic GRN';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Src\Reports\Layouts\DomesticGRN.rdl';
    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Posted Purchase Receipt';

            column(No_; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Folio_No_; "Folio No.") { }
            column(DepartmentName; DepartmentName) { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Address; "Buy-from Address") { }
            column(Buy_from_Address_2; "Buy-from Address 2") { }
            column(Buy_from_City; "Buy-from City") { }
            column(Buy_from_County; "Buy-from County") { }
            column(Buy_from_Post_Code; "Buy-from Post Code") { }
            column(Buy_from_Country_Region_Code; "Buy-from Country/Region Code") { }
            column(Bill_of_Entry_No_; "Bill of Entry No.") { }
            column(Bill_of_Entry_Date; "Bill of Entry Date") { }
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
            column(PrintDate; PrintDate) { }
            column(PrintTime; PrintTime) { }
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
                column(Item_No_; "No.") { }
                column(Line_No_; "Line No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure; "Unit of Measure") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Bin_Code; BinCode) { }
                column(SrNo; SrNo) { }

                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLinkReference = "Purch. Rcpt. Line";
                    DataItemTableView = sorting("Document No.", "Item No.", "Document Line No.");
                    DataItemLink = "Document No." = field("Document No."), "Item No." = field("No."), "Document Line No." = field("Line No.");
                    column(Lot_No_; "Lot No.") { }
                }

                trigger OnPreDataItem()
                begin
                    SrNo := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    SrNo += 1;

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
                Clear(DepartmentName);
                DimesnValue.Reset();
                DimesnValue.SetRange(Code, "Purch. Rcpt. Header"."Shortcut Dimension 1 Code");
                if DimesnValue.FindFirst() then
                    DepartmentName := DimesnValue.Name;
            end;
        }
    }

    trigger OnPreReport()

    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);

        PrintDate := Today;
        PrintTime := Time;
    end;

    var
        CompanyInfo: Record "Company Information";
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
        SrNo: Integer;
        PrintDate: Date;
        PrintTime: Time;
        BinContent: Record "Bin Content";
        BinCode: Code[20];
        DimesnValue: Record "Dimension Value";
        DepartmentName: Text[50];


}
