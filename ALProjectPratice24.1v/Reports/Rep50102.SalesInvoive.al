report 50102 SalesInvoive
{
    Caption = 'Sales Invoive Custom';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    // ProcessingOnly=true;
    RDLCLayout = 'SalesInvoiceCustom.rdlc';
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.", "Document Type") where("Document Type" = const("Invoice"));
            RequestFilterFields = Status;
            column(No_; "No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
