codeunit 50106 "Cust Ledgder Entry Dataflow"
{
    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', false, false)]
    local procedure SalesToGenJnlEntry(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Name Text" := SalesHeader."Name Text";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure GenJnlEntryToCusLedEntry(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry."Name Text" := GenJournalLine."Name Text";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure PurchaseToGenJnlEntry(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Temp Text" := PurchaseHeader."Temp Text";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure GenJnlToVendorLedEntry(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry."Temp Text" := GenJournalLine."Temp Text";
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterSalesOrder', '', false, false)]
    // local procedure ICSalesOrder()
    // var
    //     So: Record "Sales Header";
    //     Po: Record "Purchase Header";
    // begin
    //     Po.ICCompantText := So.ICCompantText;
    // end;
}