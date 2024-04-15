report 50109 "Top N Customers"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'TopNQueryCustomer.rdl';
    Caption = 'Top N Customer Using Query';

    dataset
    {
        dataitem(Integer; Integer)
        {
            column(CusNo; CusNo) { }
            column(CusName; CusName) { }
            column(Location; Location) { }
            column(Contact; Contact) { }
            column(Balance; Balance) { }
            column(Sales; Sales) { }
            column(Payment; Payment) { }
            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, TotalLines);
                TopNCus.TopNumberOfRows(TotalLines);
                TopNCus.Open();
            end;

            trigger OnAfterGetRecord()
            begin
                if TopNCus.Read() then begin
                    CusNo := TopNCus.No_;
                    CusName := TopNCus.Name;
                    Location := TopNCus.Location_Code;
                    Contact := TopNCus.Contact;
                    Sales := TopNCus.Sales__LCY_;
                    Balance := TopNCus.Balance__LCY_;
                    Payment := TopNCus.Payments__LCY_;
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
                group(Option)
                {
                    Caption = 'Options';
                    field(TotalLines; TotalLines)
                    {
                        ApplicationArea = All;
                        Caption = 'Number Of Lines';
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        TotalLines := 5;
    end;

    var
        TopNCus: Query "top N Customers";
        TotalLines: Integer;
        CusNo: Code[20];
        CusName: Text[100];
        Location: Code[10];
        Contact: Text[100];
        Balance: Decimal;
        Sales: Decimal;
        Payment: Decimal;
}