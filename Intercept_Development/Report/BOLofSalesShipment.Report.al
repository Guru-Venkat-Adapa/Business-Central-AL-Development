report 50101 BOLofSalesShipment
{
    ApplicationArea = All;
    Caption = 'Shipment Bill of Lading';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'ShipmentBOL.rdlc';
    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            column(No_; "No.") { }
            column(Source_No_; "Order No.") { }
            column(SerialNo; SerialNo) { }
            column(CompanyHeading; CompanyHeading) { }
            column(CompanyAddress; CompanyAddress) { }
            column(companyAdress2; companyAdress2) { }
            column(CompanyAddress3; CompanyAddress3) { }
            column(Tdate; Tdate) { }
            column(Bill_to_Country_Region_Code; "Bill-to Country/Region Code") { }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {

                DataItemTableView = sorting("Document No.");
                DataItemLink = "Document No." = field("No.");
                column(Item_No_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }

                // dataitem("Posted Whse. Shipment Line"; "Posted Whse. Shipment Line")
                // {
                //     DataItemTableView = sorting("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                //     DataItemLinkReference = "Sales Shipment Header";
                //     DataItemLink = "Source No." = field("Order No.");
                //     column(WHNo_; "No.") { }
                //     column(WarehouseNo_; "Whse. Shipment No.") { }
                //     // column(WarehouseNo_; "No.") { }
                //     // trigger OnAfterGetRecord()
                //     // begin
                //     //     Message("No.");
                //     // end;
                // }

            }
            trigger OnPreDataItem()
            begin

                if (FromSo <> '') and (T0So <> '') then begin
                    "Sales Shipment Header".Reset();
                    "Sales Shipment Header".SetFilter("No.", '%1..%2', FromSo, T0So);
                end
                else
                    if (FromSo <> '') and (T0So = '') then begin
                        "Sales Shipment Header".Reset();
                        "Sales Shipment Header".SetFilter("No.", '%1..', FromSo);
                    end
                    else
                        if (FromSo = '') and (T0So <> '') then begin
                            "Sales Shipment Header".Reset();
                            "Sales Shipment Header".SetFilter("No.", '..%1', T0So);
                        end;

                CompanyInfo.get();
                CompanyHeading := CompanyInfo.Name;
                CompanyAddress := CompanyInfo.Address;
                companyAdress2 := CompanyInfo."Address 2";
                CompanyAddress3 := CompanyInfo.City + ',' + CompanyInfo.County + ',' + CompanyInfo."Post Code";


                Tdate := Format(Today, 0, '<Day,2>/<Month,2>/<Year4>');
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Sales Order")
                {
                    field(FromSalesHeader; FromSo)
                    {
                        ApplicationArea = All;
                        // TableRelation = "Sales Shipment Header"."No.";
                        Caption = 'From Sales Shipment';
                        ToolTip = 'Specifies from where the sales shipment Part No. has to be started';
                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            "Sales Shipment Header".FindSet();
                            "Sales Shipment Header".SetCurrentKey("No.");
                            "Sales Shipment Header".SetAscending("No.", true);
                            if Page.RunModal(Page::"Posted Sales Shipments", "Sales Shipment Header") = Action::LookupOK then
                                FromSo := "Sales Shipment Header"."No.";
                        end;
                    }
                    field(T0SalesHeader; T0So)
                    {
                        ApplicationArea = All;
                        // TableRelation = "Sales Shipment Header"."No.";
                        Caption = 'To Sales Shipment';
                        ToolTip = ' Specifies till the sales Shipment Part No.';
                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            "Sales Shipment Header".FindSet();
                            "Sales Shipment Header".SetCurrentKey("No.");
                            "Sales Shipment Header".SetAscending("No.", true);
                            "Sales Shipment Header".FindLast();
                            if Page.RunModal(Page::"Posted Sales Shipments", "Sales Shipment Header") = Action::LookupOK then
                                T0So := "Sales Shipment Header"."No.";
                        end;
                    }
                }

            }
        }
    }
    var
        CompanyInfo: Record "Company Information";
        FromSo: code[30];
        T0So: code[30];
        SerialNo: Integer;
        CompanyHeading: Text;
        CompanyAddress: Text;
        companyAdress2: Text;
        CompanyAddress3: Text;
        Tdate: Text;
}
