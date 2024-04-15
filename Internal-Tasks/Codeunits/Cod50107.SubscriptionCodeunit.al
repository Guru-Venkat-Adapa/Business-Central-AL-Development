codeunit 50107 SubscriptionCodeunit
{
    procedure CreateSalInvoiceBySubOrder(var Rec: Record "Sales Header")
    var
        RecLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := Rec."Document Type"::Invoice;
        SalesHeader.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
        SalesHeader.Insert(true);
        RecLine.SetRange("Document No.", Rec."No.");
        if RecLine.FindSet() then begin
            repeat
                SalesLine.Init();
                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine.Type := RecLine.Type;
                SalesLine."Line No." := RecLine."Line No.";
                SalesLine.Validate("No.", RecLine."No.");
                SalesLine.Validate("Sell-to Customer No.", RecLine."Sell-to Customer No.");
                SalesLine.Quantity := RecLine.Quantity;
                SalesLine.Insert(true);
            until RecLine.Next() = 0;
        end;
        RecLine."SCB Next Invoicing Date" := CALCDATE('<+30D>', Recline."SCB End date first period");
        RecLine.Modify(true);
    end;
}
