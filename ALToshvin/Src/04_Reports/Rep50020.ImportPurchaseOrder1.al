report 50020 "Import Purchase Order1"
{
    ApplicationArea = All;
    Caption = 'Import Purchase Order';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\04_Reports\Layouts\ImportPurchaseOrder1.rdlc';
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Purchase - Order';
            column(PuchOrderNo_; "No.") { }
            column(PuchOrdPostDt; PostingDateFormat) { }
            column(PuchOrdPayment_Terms_Code; "Payment Term Details") { } //TBC-1045
            column(Pay_to_Name; "Pay-to Name") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(Pay_to_Address_2; "Pay-to Address 2") { }
            column(Inco_Terms; "Inco Terms") { } //TBC-1045
            trigger OnAfterGetRecord()
            begin
                PostingDateFormat := Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
            end;
        }
    }
    var
        PostingDateFormat: Text;

}
