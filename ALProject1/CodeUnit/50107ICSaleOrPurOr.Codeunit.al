codeunit 50107 "SalesPurchaseIC"
{
    trigger OnRun()
    var
        So: Record "Sales Header";
        Po: Record "Purchase Header";
    begin
        So.SetRange("No.",So."No.");
    end;

    var
        myInt: Integer;
}