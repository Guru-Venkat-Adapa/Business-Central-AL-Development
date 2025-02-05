reportextension 50102 SalesQuoteExt extends "Standard Sales - Quote"
{
    RDLCLayout = 'SalesQuoteInternational.rdl';
    dataset
    {
        add(Header)
        {
            column(DueDateCustom; DueDate) { }
            column(DocumentDateCustom; DocumentDate) { }
            column(CurrencyCodeCustom; CurrencyCode) { }
            column(ExchRateRon; format(ExchRateRon)) { }
        }
        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                Rec: Record "Sales Header";
                CurrencyExchangeRate: Record "Currency Exchange Rate";
            begin
                DueDate := Format("Due Date", 0, '<Day,2>/<Month,2>/<Year4>');
                DocumentDate := Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>');
                Header.SetRange("No.", Header."No.");
                if Header.FindSet() then begin
                    CurrencyCode := Header."Currency Code";
                    if (CurrencyCode = '') or (CurrencyCode = 'RON') or (CurrencyCode = 'EUR') then begin
                        CurrencyExchangeRate.FindCurrency(Header."Posting Date", 'EUR', 1);
                        ExchRateRon := CurrencyExchangeRate."Relational Exch. Rate Amount";
                    end else if CurrencyCode <> '' then begin
                        CurrencyExchangeRate.FindCurrency(Header."Posting Date", CurrencyCode, 1);
                        ExchRateRon := CurrencyExchangeRate."Exchange Rate Amount";
                    end;
                end;
            end;
        }
    }
    var
        DueDate: Text;
        DocumentDate: Text;
        CurrencyCode: Text;
        ExchRateRon: Decimal;
}
