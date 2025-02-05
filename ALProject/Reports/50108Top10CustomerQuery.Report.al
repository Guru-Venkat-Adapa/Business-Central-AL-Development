report 50108 "Top 10 Cus Query"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Top10QueryCustomers.rdl';
    Caption = 'Top 10 Customer By Query';
    dataset
    {
        dataitem(Integer; Integer)
        {
            column(CusNo; top10Customer.No_) { }
            column(CusName; top10Customer.Name) { }
            column(Location; top10Customer.Location_Code) { }
            column(Contact; top10Customer.Contact) { }
            column(Sales; top10Customer.Sales__LCY_) { }
            column(Balance; top10Customer.Balance__LCY_) { }
            column(Paymnet; top10Customer.Payments__LCY_) { }
            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, TotalLines);
                top10Customer.TopNumberOfRows(TotalLines);
                top10Customer.Open();
            end;

            trigger OnAfterGetRecord()
            begin
                if top10Customer.Read() then begin
                    // CusNo := top10Customer.No_;
                    // CusName := top10Customer.Name;
                    // Location := top10Customer.Location_Code;
                    // Contact := top10Customer.Contact;
                    // Sales := top10Customer.Sales__LCY_;
                    // Balance := top10Customer.Balance__LCY_;
                    // Payment := top10Customer.Payments__LCY_;
                end else
                    CurrReport.Skip();
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
                    Caption = 'Options';
                    field(TotalLines; TotalLines)
                    {
                        ApplicationArea = All;
                        Caption = 'Number Of Lines';
                        Editable = false;
                        // trigger OnValidate()
                        // begin
                        //     if TotalLines <= 0 then
                        //         Error('Number of lines must be greater then 0');
                        // end;
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        TotalLines := 10;
    end;

    var
        top10Customer: Query "Top 10 Customers";
        TotalLines: Integer;
        CusNo: Code[20];
        CusName: Text[100];
        Location: Code[10];
        Contact: Text[100];
        Balance: Decimal;
        Sales: Decimal;
        Payment: Decimal;

}