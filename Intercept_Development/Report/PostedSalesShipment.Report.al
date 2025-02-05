report 50102 PostedSalesShipment
{
    // ApplicationArea = All;
    Caption = 'Posted Sales Shipment Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'PostedSalesShipment.rdlc';
    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(SalesShipNo; "No.")
            {
            }
            column(Shipment_Date; Format("Shipment Date", 0, 9))
            {
            }
            column(External_Document_No_; "External Document No.") { }
            column(Order_No_; "Order No.") { }
            column(CustomrNo; "Bill-to Customer No.") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_County; "Ship-to County") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            dataitem(Integer; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(CompanyName; COMPANYPROPERTY.DisplayName())
                {
                }
                column(CompanyInfoPicture; CompanyInfo.Picture) { }
                dataitem("Sales Shipment Line"; "Sales Shipment Line")
                {
                    DataItemLink = "Document No." = field("No.");
                    DataItemLinkReference = "Sales Shipment Header";
                    DataItemTableView = sorting("Document No.", "Line No.");
                    column(ItemNo_; "No.") { }
                    column(Document_No_; "Document No.") { }
                    column(ItemDescription; Description) { }
                    column(UomCode_; "Unit of Measure Code") { }
                    column(Item_Qty; Quantity) { }
                    trigger OnAfterGetRecord()
                    begin
                        GetLocation("Location Code");
                    end;
                }
            }
            trigger OnAfterGetRecord()
            begin
                GetLocation("Location Code");
                if "Sales Shipment Header"."No." <> '' then
                    SalesShipNo += 1;
            end;

            trigger OnPostDataItem()
            begin
                If SalesShipNo > 1 then
                    Error('The Sales Shipment Number cannot be blank.');
            end;
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init()
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    var
        CompanyInfo: Record "Company Information";
        Location: Record Location;
        SalesShipNo: Integer;
}
