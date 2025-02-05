reportextension 50100 "Warehouse Shipment Ext" extends "Whse. - Shipment"
{
    RDLCLayout = '.Layouts/WhseShipmentUpdated.rdl';
    dataset
    {
        add("Warehouse Shipment Header")
        {
            column(Shipment_Date; Format("Shipment Date", 0, 9))
            {
            }
            column(External_Document_No_; "External Document No.") { }
            column(Status; Status) { }


        }
        add(Integer)
        {
            column(CompanyInfo; CompanyInfo.Picture) { }
            // column(companyPhone; CompanyInfo."Phone No.") { }
            // column(companyaddress; CompanyInfo.Address) { }
            // column(companyaddress2; CompanyInfo."Address 2") { }
            // column(companyFax; CompanyInfo."Fax No.") { }
            // column(companyCity; CompanyInfo.City) { }
            // column(companyCounty; CompanyInfo.County) { }
            // column(companyPostCode; CompanyInfo."Post Code") { }
        }
        addlast("Warehouse Shipment Line")
        {
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemLink = "No." = field("Source No.");
                column(CustomrNo; "Sales Header"."Bill-to Customer No.") { }
                column(Ship_to_Address; "Ship-to Address") { }
                column(Ship_to_Address_2; "Ship-to Address 2") { }
                column(Ship_to_Name; "Ship-to Name") { }
                column(Ship_to_City; "Ship-to City") { }
                column(Ship_to_County; "Ship-to County") { }
                column(Ship_to_Post_Code; "Ship-to Post Code") { }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        //CompanyInfo.CalcFields("Phone No.");
        // CompanyInfo.CalcFields("Fax No.");
        // CompanyInfo.CalcFields(Address);
        // CompanyInfo.CalcFields("Address 2");
        // CompanyInfo.CalcFields(City);
        // CompanyInfo.CalcFields(County);
        // CompanyInfo.CalcFields("Post Code")
    end;

    var
        CompanyInfo: Record "Company Information";
        rep : Report 1401;
}
