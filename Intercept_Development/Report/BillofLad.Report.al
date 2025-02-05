report 50100 "Bill of Lad"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'BOLReport.rdlc';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            column(No_; "No.")
            {

            }
            column(SerialNo; SerialNo)
            {

            }
            column(CompanyHeading; CompanyHeading)
            {

            }
            column(CompanyAddress; CompanyAddress)
            {

            }
            column(companyAdress2; companyAdress2)
            {

            }
            column(CompanyAddress3; CompanyAddress3)
            {

            }
            column(Tdate; Tdate)
            {

            }
            column(Bill_to_Country_Region_Code; "Bill-to Country/Region Code")
            {

            }
            dataitem("Sales Line"; "Sales Line")
            {

                DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
                DataItemLink = "Document No." = field("No."), "Document Type" = field("Document Type");

                dataitem("Warehouse Shipment Line"; "Warehouse Shipment Line")
                {
                    DataItemTableView = sorting("No.", "Source Document", "Source No.") where("Source Document" = const("Sales Order"));
                    DataItemLinkReference = "Sales Line";
                    DataItemLink = "Source No." = field("Document No."), "Source Line No." = field("Line No.");


                    column(WHNo_; "No.")
                    {

                    }
                    column(Item_No_; "Item No.")
                    {

                    }
                    column(Description; Description)
                    {

                    }
                    column(Source_No_; "Source No.")
                    {

                    }
                    column(Quantity; Quantity)
                    {

                    }
                    column(WarehouseNo_; "No.")
                    {

                    }
                }

            }
            trigger OnPreDataItem()
            begin

                if (FromSo <> '') and (T0So <> '') then begin
                    "Sales Header".Reset();
                    "Sales Header".SetFilter("No.", '%1..%2', FromSo, T0So);
                end;


                CompanyInfo.get();
                CompanyHeading := CompanyInfo.Name;
                CompanyAddress := CompanyInfo.Address;
                companyAdress2 := CompanyInfo."Address 2";
                CompanyAddress3 := CompanyInfo.City + ',' + CompanyInfo.County + ',' + CompanyInfo."Post Code";



                Tdate := Format(Today, 0, '<Day,2>/<Month,2>/<Year4>');
            end;

            trigger OnAfterGetRecord()
            begin
                SerialNo += 1;


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
                        TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
                        ToolTip = 'Specifies from which sales order the report has to start.';
                        Caption = 'From Sales Order';


                    }
                    field(T0SalesHeader; T0So)
                    {
                        ApplicationArea = All;
                        Caption = 'To Sales Shipment';
                        TableRelation = "Sales Header"."No." where("Document Type" = filter(Order));
                        ToolTip = 'Specifies to the sales Shipment has to printed';

                    }
                }

            }
        }

        // actions
        // {
        //     area(processing)
        //     {
        //         action(LayoutName)
        //         {
        //             ApplicationArea = All;

        //         }
        //     }
        // }
    }



    var

        CompanyInfo: Record "Company Information";
        FromSo: code[30];
        T0So: code[30];
        // FromWH: code[30];
        // ToWH: code[30];
        SerialNo: Integer;
        CompanyHeading: Text;
        CompanyAddress: Text;
        companyAdress2: Text;
        CompanyAddress3: Text;

        Tdate: Text;
}