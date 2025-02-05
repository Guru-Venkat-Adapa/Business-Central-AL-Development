codeunit 50207 "Page Management Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', true, true)]
    local procedure OnAfterGetPageID(RecordRef: RecordRef; var PageId: Integer)
    begin
        IF PageId = 0 then
            PageId := GetConditionalCardPageID(RecordRef);
    end;

    local procedure GetConditionalCardPageID(RecordRef: RecordRef): Integer
    begin
        CASE RecordRef.NUMBER OF
            DATABASE::TestApproval:
                exit(Page::"Test Card Page");
        end;
    end;
}