codeunit 50101 "CustomFieldLineTransfer"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Drop Shpt.", 'OnCodeOnBeforeModify', '', false, false)]
    local procedure TransferCustomFieldFromSalesToPurchOrder(var PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    begin
        PurchaseHeader."Vendor Order No." := SalesHeader."External Document No.";
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Totals", 'OnAfterCalculateSalesSubPageTotals', '', false, false)]
    // local procedure OnAfterCalculateSalesSubPageTotals(var TotalSalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLine2: Record "Sales Line"; var InvoiceDiscountAmount: Decimal; var InvoiceDiscountPct: Decimal; var VATAmount: Decimal)
    // begin
    //     // Message('%1\%2\%3\%4\%5\%6', TotalSalesHeader."Document Type", TotalSalesHeader."No.", TotalSalesLine."No.", TotalSalesLine."Document Type", TotalSalesLine2."No.", TotalSalesLine2."Document Type");
    //     TotalSalesLine.SetFilter("Document Type", Format(TotalSalesHeader."Document Type"));
    //     TotalSalesLine.SetFilter("Document No.", TotalSalesHeader."No.");
    //     If TotalSalesLine.FindSet() then
    //         repeat
    //             If TotalSalesLine.Type = TotalSalesLine.Type::Item then
    //                 InvoiceDiscountAmount += TotalSalesLine."Unit Price";

    //         until TotalSalesLine.Next() = 0;
    // end;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Totals", 'OnBeforeCalculateSalesSubPageTotals', '', false, false)]
    // local procedure OnBeforeCalculateSalesSubPageTotals(var TotalSalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var InvoiceDiscountAmount: Decimal)
    // begin
    //     TotalSalesLine.SetFilter("Document Type", Format(TotalSalesHeader."Document Type"));
    //     TotalSalesLine.SetFilter("Document No.", TotalSalesHeader."No.");
    //     If TotalSalesLine.FindSet() then
    //         repeat
    //             If TotalSalesLine.Type = TotalSalesLine.Type::Item then
    //                 InvoiceDiscountAmount += TotalSalesLine."Unit Price";

    //         until TotalSalesLine.Next() = 0;
    // end;
    [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnAfterQuantityOnAfterValidate(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetFilter("Document Type", Format(Rec."Document Type"));
        SalesHeader.SetFilter("No.", Format(Rec."Document No."));
        if SalesHeader.FindFirst() then begin
            SalesHeader."Invoice Discount Value" -= Rec."Unit Price";
            SalesHeader.Modify(false);
        end;
    end;
}

