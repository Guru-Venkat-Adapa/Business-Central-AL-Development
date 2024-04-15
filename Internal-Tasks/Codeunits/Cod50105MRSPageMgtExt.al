codeunit 50105 "MRS Page Mgt Ext"
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
            DATABASE::MRSHeader:
                exit(Page::"MRS Card Page");
        end;
    end;
    //===========================================================================FOR PRS REQUEST APPROVAL=================================================================

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', true, true)]
    local procedure OnAfterGetPageIDPRS(RecordRef: RecordRef; var PageId: Integer)
    begin
        IF PageId = 0 then
            PageId := GetConditionalCardPageIDPRS(RecordRef);
    end;

    local procedure GetConditionalCardPageIDPRS(RecordRef: RecordRef): Integer
    begin
        CASE RecordRef.NUMBER OF
            DATABASE::"PRS Header":
                exit(Page::"PRS Card");
        end;
    end;
}