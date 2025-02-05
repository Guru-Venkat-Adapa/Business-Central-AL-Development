reportextension 50149 SalesInvoiceReport extends 1306
{
    RDLCLayout = 'SalesInvoiceExportedRON.rdl';
    dataset
    {
        // Add changes to dataitems and columns here
        add(Header)
        {
            // column(No_; "No.") { }
            column(ExchRateRon; format(ExchRateRon))
            { }

        }
        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                Rec: Record "Sales Header";
                CurrencyExchangeRate: Record "Currency Exchange Rate";
            begin
                if (Rec."Currency Code" = '') or (Rec."Currency Code" = 'RON') then begin
                    CurrencyExchangeRate.FindCurrency(Rec."Posting Date", 'EUR', 1);
                    ExchRateRon := CurrencyExchangeRate."Relational Exch. Rate Amount";
                end;
            end;

        }
    }

    requestpage
    {
        // Add changes to the requestpage here
    }
    var
        ExchRateRon: Decimal;
}