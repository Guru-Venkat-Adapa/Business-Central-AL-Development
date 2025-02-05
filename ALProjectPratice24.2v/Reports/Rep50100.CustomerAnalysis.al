report 50100 "Customer Analysis"
{
    ApplicationArea = All;
    Caption = 'Customer Analysis';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'CustomerAnalysis.rdlc';

    dataset
    {
        dataitem(CustomerR; Customer)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            column(CustomerNo; CustomerNo) { }
            column(CustomerName; CustomerName) { }
            column(SlNo; SlNo) { }
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemLink = "Bill-to Customer No." = field("No.");
                DataItemTableView = sorting("No.") where("Document Type" = const(order));
                column(SalesOrderNo; "No.") { }
                column(Bill_to_Name; "Bill-to Name") { }
                trigger onaftergetrecord()
                begin
                    if CustomerR."No." = "Sales Header"."Bill-to Customer No." then
                        if CustomerR."No." = PreviousCustomerNo then begin
                            CustomerNo := '';
                            SlNo += 1;
                        end else begin
                            SlNo := 1;
                            PreviousCustomerNo := CustomerR."No.";
                            CustomerNo := CustomerR."No.";
                            CustomerName := CustomerR.Name;
                        end;
                end;
            }
        }
    }
    var
        PreviousCustomerNo: Code[20];
        CustomerNo: Code[20];
        CustomerName: Text;
        SlNo: Integer;
        test: Report 1316;
}
