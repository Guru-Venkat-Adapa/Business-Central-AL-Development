report 50016 "Package Label"
{
    ApplicationArea = All;
    Caption = 'Package Label';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Src\Reports\Layouts\PackageLabel.rdl';
    dataset
    {
        dataitem(SalesShipmentInvoice; "Sales Shipment Header")
        {
            RequestFilterFields = "No.";

            column(No_; "No.") { }
            column(Document_Date; "Document Date") { }
            column(External_Document_No_; "External Document No.") { }
            column(Customer_PO_Date; "Customer PO Date") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }

            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(Ship_to_Phone_No_; "Ship-to Phone No.") { }
            column(Ship_to_Contact; "Ship-to Contact") { }
        }
    }

}
