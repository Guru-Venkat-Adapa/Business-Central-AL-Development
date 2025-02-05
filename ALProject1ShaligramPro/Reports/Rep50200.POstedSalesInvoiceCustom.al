report 50200 PostedSalesInvoiceCustom
{
    Caption = 'Custom Posted Sales Invoice';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    DefaultRenderingLayout = Test;
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer Name";
            column(No_; "No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Invoice Header";
                DataItemTableView = sorting("Document No.", "Line No.");
                column(Document_No_; "Document No.") { }
                column(SalesLine_No_; "No.") { }
                column(GST; GST) { }
                trigger OnAfterGetRecord()
                var
                    DocumentTotals: Codeunit "Document Totals";
                begin
                    DocumentTotals.CalculatePostedSalesInvoiceTotals("Sales Invoice Header", GST, "Sales Invoice Line");
                end;
            }
            // trigger OnAfterGetRecord()
            // var
            //     DocumentTotals: Codeunit "Document Totals";
            // begin
            //     "Sales Invoice Line".SetRange("Document No.", "Sales Invoice Header"."No.");
            //     if "Sales Invoice Line".FindSet() then
            //         DocumentTotals.CalculatePostedSalesInvoiceTotals("Sales Invoice Header", GST, "Sales Invoice Line");
            // end;
        }
    }
    requestpage
    { }
    rendering
    {
        layout(Test)
        {
            Type = RDLC;
            LayoutFile = 'SalesInvoiceReport.rdlc';
        }
    }
    var
        GST: Decimal;
}
