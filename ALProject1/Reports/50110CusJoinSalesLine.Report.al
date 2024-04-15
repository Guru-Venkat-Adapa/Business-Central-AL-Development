report 50110 "Cus Join SaleLine Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'CustomerJoinSalesLine.rdl';
    Caption = 'Customer Joins Sales Lines';
    dataset
    {
        dataitem(Integer; Integer)
        {
            column(CusNo; CustomerTop.No_) { }
            column(CusName; CustomerTop.Name) { }
            column(Sales; CustomerTop.Sales__LCY_) { }
            column(Qty; CustomerTop.Quantity) { }

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, TotalLines);
                CustomerTop.TopNumberOfRows(TotalLines);
                CustomerTop.Open();
            end;

            trigger OnAfterGetRecord()
            begin
                if CustomerTop.Read() then begin
                    // CusNo := CustomerTop.No_;
                    // CusName := CustomerTop.Name;
                    // Sales := CustomerTop.Sales__LCY_;
                    //Qty := CustomerTop.Quantity;
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
                    field(TotalLines; TotalLines)
                    {
                        ApplicationArea = All;
                        Caption = 'Number Of Customers';
                        trigger OnValidate()
                        begin
                            if TotalLines <= 0 then
                                Error('Please insert value greater than 0');
                        end;
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
        CustomerTop: Query "Customer Join Sales Line";
        TotalLines: Integer;
        CusNo: Code[20];
        CusName: Text[100];
        Sales: Decimal;
        Qty: Decimal;
}