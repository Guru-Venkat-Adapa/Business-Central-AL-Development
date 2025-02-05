codeunit 50101 SalesOrder
{
    [EventSubscriber(ObjectType::Table, Database::"Sales invoice Header", OnBeforeInsertEvent, '', false, false)]
    procedure GetLCY(var Rec: Record "Sales invoice Header")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CurrencyExch: Record "Currency Exchange Rate";
        GeneralLedEnt: Record "General Ledger Setup";
        AmountLCY: Decimal;
        GetExchange: Decimal;
        AmountLnclVat: Decimal;
    begin
        Rec.CalcFields(Amount);
        SalesLine.SetRange(SalesLine."Document No.", Rec."Order No.");
        if SalesLine.FindSet() then begin
            repeat
                AmountLnclVat := SalesLine."Amount Including VAT" / SalesLine.Quantity;
                AmountLCY += AmountLnclVat * SalesLine."Qty. to Invoice";
            until SalesLine.Next() = 0;
            if Rec."Currency Code" <> 'GBP' then begin
                CurrencyExch.SetRange(CurrencyExch."Currency Code", Rec."Currency Code");
                if CurrencyExch.FindSet() then begin
                    GetExchange := CurrencyExch."Relational Exch. Rate Amount" / CurrencyExch."Exchange Rate Amount";
                    Rec."Custom Amount (LCY)" := AmountLCY * GetExchange;
                end;
            end else begin
                Rec."Custom Amount (LCY)" := AmountLCY;
            end;
        end;
    end;
}