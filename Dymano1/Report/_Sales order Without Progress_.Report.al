report 50104 "Sales order Without Progress"
{
    Caption = 'Sales order Without Progress';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.", "Document Type");
            RequestFilterFields = "Document Type", "No.";
            RequestFilterHeading = 'Sales Orders';

            column(ReportTitlelbl; ReportTitlelbl)
            {
            }
            column(Pagelbl; Pagelbl)
            {
            }
            column(EmailLbl; EmailLbl)
            {
            }
            column(Phonelbl; Phonelbl)
            {
            }
            column(Homelbl; Homelbl)
            {
            }
            column(ComapnyImage; Company.Picture)
            {
            }
            column(CompanyName; Company.Name)
            {
            }
            column(CompanyEmail; Company."E-Mail")
            {
            }
            column(CompanyPhone; Company."Phone No.")
            {
            }
            column(CompanyHome; Company."Home Page")
            {
            }
            column(No_; "No.")
            {
            }
            column(NoCaption; FieldCaption("No."))
            {
            }
            column(Document_TypeCaption; FieldCaption("Document Type"))
            {
            }
            column(Posting_DateCaption; FieldCaption("Posting Date"))
            {
            }
            column(CustomerNameCaption; FieldCaption("Sell-to Customer Name"))
            {
            }
            column(Document_Type; "Document Type")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Document_Date; Format(Today, 0, 4))
            {
            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
            }
            column(ItemNoCaption; ItemNolbl)
            {
            }
            column(DescriptionCaption; DescriptionCaption)
            {
            }
            column(Quantitylbl; Quantitylbl)
            {
            }
            column(QtyInvoiced; QtyInvoiced)
            {
            }
            column(QtyShippeed; QtyShippeed)
            {
            }
            column(QtytoInvoicelbl; QtytoInvoicelbl)
            {
            }
            column(QtytoShiplbl; QtytoShiplbl)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No."=field("No.");
                DataItemTableView = sorting("Document No.", Type, "No.");

                column(ItemNo_; "No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Quantity_Shipped; "Quantity Shipped")
                {
                }
                column(Quantity_Invoiced; "Quantity Invoiced")
                {
                }
                column(Qty__to_Invoice; "Qty. to Invoice")
                {
                }
                column(Qty__to_Ship; "Qty. to Ship")
                {
                }
            }
            trigger OnAfterGetRecord()
            var
                shipment: Codeunit "Sales-Get Shipment";
                salesinvoice: Record "Sales Invoice Header" temporary;
            begin
                IF NOT PrintRecords("Sales Header"."No.")then CurrReport.Skip();
            end;
            trigger OnPreDataItem()
            begin
                SetFilter("Posting Date", '<%1', AgingDate);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(AgeingInterval; AgeingInterval)
                    {
                        ApplicationArea = All;
                        Caption = 'Ageing Interval';
                    }
                }
            }
        }
    }
    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'SalesOrderInfo.rdl';
        }
    }
    trigger OnInitReport()
    begin
        AgeingInterval:=30;
        Company.Get();
        Company.CalcFields(Picture)end;
    trigger OnPreReport()
    begin
        dateformula:='<-' + Format(AgeingInterval) + 'D>';
        AgingDate:=CalcDate(dateformula, Today);
    end;
    var dateformula: Text;
    AgeingInterval: Integer;
    AgingDate: Date;
    Company: Record "Company Information";
    Pagelbl: Label 'Page';
    ItemNolbl: Label 'Item No.';
    ReportTitlelbl: Label 'Orders/Invoices Information';
    Phonelbl: Label 'Phone No.';
    EmailLbl: Label ' E-Mail';
    Homelbl: Label 'HomePage';
    DescriptionCaption: Label 'Description';
    Quantitylbl: Label 'Quantity';
    QtytoShiplbl: Label 'Qty. to Ship';
    QtytoInvoicelbl: Label 'Qty. to Invoice';
    QtyShippeed: Label 'Qty. Shipped';
    QtyInvoiced: Label ' Qty. Invoiced';
    local procedure PrintRecords(OrderNo: Code[20]): Boolean var
        shipment: Codeunit "Sales-Get Shipment";
        salesinvoice: Record "Sales Invoice Header" temporary;
        SalesShipment: Record "Sales Shipment Header";
        SalesHdr: Record "Sales Header";
    begin
        SalesHdr.Reset();
        SalesHdr.SetRange(SalesHdr."Document Type", SalesHdr."Document Type"::Quote);
        SalesHdr.SetRange("No.", OrderNo);
        SalesHdr.SetFilter("Posting Date", '<%1', AgingDate);
        IF SalesHdr.FindFirst()then exit(true);
        shipment.GetSalesOrderInvoices(salesinvoice, OrderNo);
        salesinvoice.SetFilter("Posting Date", '<%1', AgingDate);
        SalesShipment.Reset();
        SalesShipment.SetRange(SalesShipment."Order No.", OrderNo);
        SalesShipment.SetFilter("Posting Date", '<%1', AgingDate);
        IF(NOT salesinvoice.FindFirst()) AND (NOT SalesShipment.FindFirst())then exit(true)
        else
            exit(false);
    end;
}
