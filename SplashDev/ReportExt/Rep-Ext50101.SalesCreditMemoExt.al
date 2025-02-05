reportextension 50101 "Sales - Credit Memo Ext" extends "Standard Sales - Credit Memo"
{
    // WordLayout = 'PostedSalesCreditMemoIntl.docx';
    RDLCLayout = 'PostedSalesCrMemoInternational.rdl';
    dataset
    {
        add(Header)
        {
            column(DueDateCustom; DueDate) { }
            column(DocumentdateCustom; Documentdate) { }
            column(ShipmentDateCustom; ShipmentDate) { }
            column(LineAmtCustom; LineAmt) { }
            column(CurrencyCodeCustom; CurrencyCode) { }
            column(ExchRateRon; format(ExchRateRon)) { }
        }
        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                salesline: Record "Sales Cr.Memo Line";
                CurrencyExchangeRate: Record "Currency Exchange Rate";
            begin
                DueDate := Format("Due Date", 0, '<Day,2>/<Month,2>/<Year4>');
                Documentdate := Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>');
                salesline.Reset();
                salesline.SetRange("Document No.", Header."No.");
                if salesline.FindSet() then begin
                    ShipmentDate := Format(salesline."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                    repeat
                        LineAmt += salesline."Line Amount";
                    until salesline.Next() = 0;
                end;
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
        ShipmentDate: Text;
        Documentdate: Text;
        LineAmt: Decimal;
        TotalAmt: Decimal;
        CurrencyCode: Text;
        ExchRateRon: Decimal;
}
