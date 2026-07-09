report 50046 "ORC Sales Order Prof. Inv"
{
    //TBC-1031 ---->
    ApplicationArea = All;
    Caption = 'ORC Sales Order Proforma Invoice';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\Reports\Layouts\ORCSalesOrderProformaInvoice.rdl';
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = SORTING("No.") WHERE("Document Type" = CONST(Order), "Sales Order Type" = filter('SPARES ORC' | 'INSTRUMENT ORC'));
            RequestFilterFields = "No.";

            column("Document_No"; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_Address_2; "Bill-to Address 2") { }
            column(Bill_to_City; "Bill-to City") { }
            column(Bill_to_Post_Code; "Bill-to Post Code") { }
            column(Bill_to_County; "Bill-to County") { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            column(Bill_to_Country_Region_Code; "Bill-to Country/Region Code") { }
            column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
            column(CustGSTINNo; CustGSTINNo) { }

            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(Ship_to_County; "Ship-to County") { }
            column(Ship_to_Contact; "Ship-to Contact") { }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code") { }
            column(Ship_to_Phone_No_; "Ship-to Phone No.") { }
            column(ShipToGSTINNo; ShipToGSTINNo) { }

            column(Your_Reference; "Your Reference") { }
            column(PaymentTermsDescription; PaymentTermsDescription) { }
            column(ShipmentDescription; ShipmentDescription) { }
            column(Amount; Amount) { }
            column(CompanyInfo_ShimadzuSignature; CompanyInfo."Shimadzu Signature") { }
            column(CompanyInfo_Shimadzu; CompanyInfo.Shimadzu) { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = SalesHeader;
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST(Order));

                column(No_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Line_Amount; "Line Amount") { }
                column(SrNo; SrNo) { }
                column(Unit_Price; "Unit Price") { }

                trigger OnAfterGetRecord()
                var

                begin
                    SrNo += 1;
                end;
            }
            trigger OnAfterGetRecord()
            var
            begin
                SalesHeader.CalcFields(Amount);
                Clear(ShipmentDescription);
                if ShipmentMethod.Get(SalesHeader."Shipment Method Code") then
                    ShipmentDescription := ShipmentMethod.Description;

                Clear(PaymentTermsDescription);
                if PaymentTerms.Get(SalesHeader."Payment Terms Code") then
                    PaymentTermsDescription := PaymentTerms.Description;

                Clear(Cust);
                if Cust.Get(SalesHeader."Bill-to Customer No.") then
                    CustGSTINNo := Cust."GST Registration No.";

                Clear(ShipToAddress);
                if SalesHeader."Ship-to Code" <> '' then begin
                    if ShipToAddress.Get(SalesHeader."Ship-to Code") then
                        ShipToGSTINNo := ShipToAddress."GST Registration No.";
                end else
                    if Cust.Get(SalesHeader."Sell-to Customer No.") then
                        ShipToGSTINNo := Cust."GST Registration No.";

            end;
        }
    }
    trigger OnPreReport()

    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields("Shimadzu Signature");
        CompanyInfo.CalcFields(Shimadzu);
    end;

    var
        ShipmentMethod: Record "Shipment Method";
        ShipmentDescription: Text;
        PaymentTerms: Record "Payment Terms";
        PaymentTermsDescription: Text;
        Cust: Record Customer;
        CustGSTINNo: Text;
        ShipToGSTINNo: Text;
        ShipToAddress: Record "Ship-to Address";
        SrNo: Integer;
        CompanyInfo: Record "Company Information";


    //TBC-1031 <-----

}
