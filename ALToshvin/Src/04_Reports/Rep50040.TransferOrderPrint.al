report 50040 "Transfer Order Print"
{
    ApplicationArea = All;
    Caption = 'Transfer Order';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\Reports\Layouts\TransferOrder.rdl';
    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");

            column(No_; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Custom_Assigned_User_ID; "Custom Assigned User ID") { }
            column(Expected_RDC_Return_Date; "Expected RDC Return Date") { }
            column(Part_Requisition_Form; "Part Requisition Form") { }
            column(Requisition_Purpose; "Requisition Purpose") { }
            column(Contact_Name; "Contact Name") { }
            column(CompanyInfo_Name; CompanyInfo.Name) { }

            column(Cust_Name; CustName) { }
            column(Cust_Address; CustAddress) { }
            column(Cust_Address2; CustAddress2) { }
            column(Cust_City; CustCity) { }
            column(Cust_Post_Code; CustPostCode) { }
            column(Cust_County; CustCounty) { }
            column(Cust_Country_Region_Code; CustCountryRegionCode) { }
            column(Cust_GST_Registration_No_; CustGSTRegistrationNo) { }

            column(Name; LocName) { }
            column(Address; LocAddress) { }
            column(Address2; LocAddress2) { }
            column(City; LocCity) { }
            column(Post_Code; LocPostCode) { }
            column(County; LocCounty) { }
            column(Country_Region_Code; LocCountryRegionCode) { }
            column(Phone_No_; LocPhoneNo) { }

            column(Execution_Date; ExecutionDate) { }
            column(Execution_Time; ExecutionTime) { }
            column(GRNNo; GRNNo) { }

            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLinkReference = "Transfer Header";

                column(Item_No_; "Item No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(SrNo; SrNo) { }

                trigger OnAfterGetRecord()
                begin
                    Clear(SrNo);
                    SrNo += 1;
                end;

            }
            trigger OnAfterGetRecord()
            var
            begin
                Clear(LocName);
                Clear(LocAddress);
                Clear(LocAddress2);
                Clear(LocCity);
                Clear(LocPostCode);
                Clear(LocCounty);
                Clear(LocCountryRegionCode);
                Clear(LocPhoneNo);
                if Loc.Get("Transfer Header"."Transfer-from Code") then begin
                    LocName := Loc.Name;
                    LocAddress := Loc.Address;
                    LocAddress2 := Loc."Address 2";
                    LocCity := Loc.City;
                    LocPostCode := Loc."Post Code";
                    LocCounty := Loc.County;
                    LocCountryRegionCode := Loc."Country/Region Code";
                    LocPhoneNo := Loc."Phone No.";
                end;

                Clear(CustName);
                Clear(CustAddress);
                Clear(CustAddress2);
                Clear(CustCity);
                Clear(CustPostCode);
                Clear(CustCounty);
                Clear(CustCountryRegionCode);
                Clear(CustGSTRegistrationNo);
                if Cust.Get("Transfer Header"."Customer No.") then begin
                    CustName := Cust.Name;
                    CustAddress := Cust.Address;
                    CustAddress2 := Cust."Address 2";
                    CustCity := Cust.City;
                    CustPostCode := Cust."Post Code";
                    CustCounty := Cust.County;
                    CustCountryRegionCode := Cust."Country/Region Code";
                    CustGSTRegistrationNo := Cust."GST Registration No.";
                end;
                Clear(ExecutionDate);
                Clear(ExecutionTime);
                ExecutionDate := Today;
                ExecutionTime := Time;

                Clear(GRNNo);
                TransferShipmentHeader.Reset();
                TransferShipmentHeader.SetRange("Transfer Order No.", "Transfer Header"."No.");
                if TransferShipmentHeader.FindFirst() then
                    GRNNo := TransferShipmentHeader."No.";
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
        SrNo: Integer;
        Loc: Record "Location";
        LocName: Text[100];
        LocAddress: Text[100];
        LocAddress2: Text[100];
        LocCity: Text[100];
        LocPostCode: Text[100];
        LocCounty: Text[100];
        LocCountryRegionCode: Text[100];
        LocPhoneNo: Text[30];
        Cust: Record Customer;
        CustName: Text[100];
        CustAddress: Text[100];
        CustAddress2: Text[100];
        CustCity: Text[100];
        CustPostCode: Text[100];
        CustCounty: Text[100];
        CustCountryRegionCode: Text[100];
        CustGSTRegistrationNo: Text[20];
        ExecutionDate: Date;
        ExecutionTime: Time;
        TransferShipmentHeader: Record "Transfer Shipment Header";
        GRNNo: Code[20];

}
