codeunit 50200 "Update Item Posting Date"
{
    [EventSubscriber(ObjectType::Page, page::"Item Card", OnOpenPageEvent, '', false, false)]
    local procedure UpdatePostingDate(var Rec: Record Item)
    var
        ItemLedgerEntries: Record "Item Ledger Entry";
    begin
        ItemLedgerEntries.SetRange("Item No.", Rec."No.");
        ItemLedgerEntries.SetCurrentKey("Item No.", "Posting Date");
        ItemLedgerEntries.SetRange("Item No.", Rec."No.");
        ItemLedgerEntries.Ascending(false);
        if ItemLedgerEntries.FindFirst() then begin
            Rec.Validate("Last Trans Posting date", ItemLedgerEntries."Posting Date");
            Rec.Modify(false);
        end else begin
            Message('No Item Ledger Entry found for Item %1.', Rec."No.");
        end;
    end;

}
