report 50103 " Custom Sales Order Status"
{
    Caption = 'Custom Sales Order Status';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'SalesOrderStatus.rdlc';
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.", "Document Type") where("Document Type" = const(order));
            // RequestFilterFields = Status;
            column(SalesOrderNo_; "No.") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Posting_Date; Format("Due Date", 0, '<Month,2>-<Day,2>-<Year4>')) { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Status; Status) { }
            column(FromDuedate; FromDuedate) { }
            column(ToDueDate; ToDueDate) { }
            column(TodayDate; TodayDate) { }
            column(TodayTime; TodayTime) { }
            column(Customer_PO_No; "External Document No.") { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where("Document Type" = const(order));
                DataItemLink = "Document No." = field("No."), "Document Type" = field("Document Type");
                column(ItemNo_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Qty__to_Ship; "Outstanding Quantity") { }
                dataitem(Integer; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(CompanyName; COMPANYPROPERTY.DisplayName())
                    {
                    }
                    column(CompanyInfoPicture; CompanyInfo.Picture) { }
                }
                // trigger OnAfterGetRecord()
                // begin
                //     If "Sales Line"."Document No." = XSalesOrderNo then
                //         SalesOrderNo := ''
                //     else begin
                //         XSalesOrderNo := "Sales Line"."Document No.";
                //         SalesOrderNo := "Sales Line"."Document No.";
                //     end;

                //     If "Sales Header"."Due Date" = xPostingDate then
                //         PostingDate := 0D
                //     else begin
                //         xPostingDate := "Sales Header"."Due Date";
                //         PostingDate := "Sales Header"."Due Date";
                //     end;
                // end;
            }
            trigger OnPreDataItem()
            begin
                "Sales Header".SetCurrentKey("Due Date");
                "Sales Header".SetAscending("Due Date", true);
                "Sales Header".SetRange("Ship-to Address", ShipToAddress);
                "Sales Header".SetRange(Status, OrderStatus);
                If (FromDuedate <> 0D) and (ToDueDate <> 0D) then
                    "Sales Header".SetFilter("Due Date", '%1..%2', FromDuedate, ToDueDate)
                else
                    if (FromDuedate <> 0D) and (ToDueDate = 0D) then
                        "Sales Header".SetFilter("Due Date", '%1..', FromDuedate)
                    else
                        if (ToDueDate <> 0D) and (FromDuedate = 0D) then
                            "Sales Header".SetFilter("Due Date", '..%1', ToDueDate);

                TodayDate := Format(Today, 0, '<Month,2>/<Day,2>/<Year4>');
                TodayTime := Format(System.Time);
            end;

            trigger OnAfterGetRecord()
            var
                salesline: Record "Sales Line";
            begin
                salesline.SetRange("Document No.", "Sales Header"."No.");
                salesline.SetRange("Document Type", "Sales Header"."Document Type");
                if salesline.IsEmpty then
                    CurrReport.Skip();
            end;

        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {

                group(SalesOrder)
                {
                    Caption = 'Sales Order';
                    field(ShipToAddress_; ShipToAddress)
                    {
                        ApplicationArea = All;
                        Caption = 'Ship-to Address';
                        ToolTip = 'Specifies the Address to be shipped';
                        ShowMandatory = true;
                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            "Sales Header".SetRange("Document Type", "Sales Header"."Document Type"::Order);
                            if "Sales Header".FindSet() then
                                if Page.RunModal(Page::"Sales Order List", "Sales Header") = Action::LookupOK then
                                    ShipToAddress := "Sales Header"."Ship-to Address";
                        end;

                    }
                    field(OrderStatus_; OrderStatus)
                    {
                        ApplicationArea = All;
                        Caption = 'Status';
                        ToolTip = 'Specifies the status of the sales order';
                        // Editable=false;
                    }
                    field(FromDuedate_; FromDuedate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Due Date';
                        ToolTip = 'Sets the End Date to be filtered';
                    }
                    field(ToDueDate_; ToDueDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Due Date';
                        ToolTip = 'Sets the End Date to be filtered';
                    }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        ShipToAddress: Text;
        OrderStatus: Enum "Sales Document Status";
        FromDuedate: Date;
        ToDueDate: Date;
        TodayDate: Text;
        TodayTime: Text;
}
