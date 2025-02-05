codeunit 50105 "Fund Transfer"
{
    /**********************************                  Changing the status of Fund Transfer Line              ****************************/
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnAfterPostGenJnlLine', '', false, false)]
    // local procedure MyProcedure(var GenJournalLine: Record "Gen. Journal Line")
    // var
    //     FundTraLine: Record "Fund Transfer Line";
    //     CompanyInfo: Record "Company Information";
    // // EmailSend: Codeunit "Custom Send Email";
    // begin
    //     FundTraLine.SetRange("No.", GenJournalLine.FundTranLineNo);
    //     If FundTraLine.FindFirst() then
    //         FundTraLine.Status := FundTraLine.Status::Released;
    //     FundTraLine.Modify(false);
    // end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnAfterPostGenJnlLine', '', false, false)]
    local procedure MyProcedure(var GenJournalLine: Record "Gen. Journal Line")
    var
        FundTraLine: Record "Fund Transfer Line";
    // FundHeader: Record "Fund Transfer Header";
    // EmailSend: Codeunit "Custom Send Email";
    begin
        FundTraLine.SetRange("No.", GenJournalLine.FundTranLineNo);
        If FundTraLine.FindFirst() then begin
            FundTraLine.Status := FundTraLine.Status::Released;
            FundTraLine.Modify(false);
        end;
        // FundHeader.SetRange(No, FundTraLine."Fund No.");
        // If FundHeader.FindFirst() then
        //     EmailSend.ConformingEmail(FundHeader,FundTraLine);
    end;
    /*     Sales order to Pucrchase order in intercompany         */
    // OnBeforeOutboxSalesHdrToInbox
    // OnBeforeUpdatePurchaseHeader
    /******************************          sending data from IC genjournal  Company1 to Company2                 *************************************/
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnCreateOutboxJnlTransactionOnBeforeOutboxJnlTransactionInsert', '', false, false)]
    local procedure OnCreateOutboxJnlTransactionOnBeforeOutboxJnlTransactionInsert(var OutboxJnlTransaction: Record "IC Outbox Transaction"; var TempGenJnlLine: Record "Gen. Journal Line" temporary)
    begin
        OutboxJnlTransaction.Project := TempGenJnlLine.Project;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnBeforeICInboxTransInsert', '', false, false)]
    local procedure OnBeforeICInboxTransInsert(var ICInboxTransaction: Record "IC Inbox Transaction"; ICOutboxTransaction: Record "IC Outbox Transaction")
    begin
        ICInboxTransaction.Project := ICOutboxTransaction.Project;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnBeforeInsertGenJnlLine', '', false, false)]
    local procedure OnBeforeCreateJournalLines(ICInboxJnlLine: Record "IC Inbox Jnl. Line"; var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine.Project := ICInboxJnlLine.Project;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnInsertOutboxJnlLineOnBeforeICOutboxJnlLineInsert', '', false, false)]
    local procedure OnInsertOutboxJnlLineOnBeforeICOutboxJnlLineInsert(TempGenJournalLine: Record "Gen. Journal Line" temporary; var ICOutboxJnlLine: Record "IC Outbox Jnl. Line")
    begin
        ICOutboxJnlLine.Project := TempGenJournalLine.Project
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnOutboxJnlLineToInboxOnBeforeICInboxJnlLineInsert', '', false, false)]
    local procedure OnOutboxJnlLineToInboxOnBeforeICInboxJnlLineInsert(var ICInboxJnlLine: Record "IC Inbox Jnl. Line"; var ICOutboxJnlLine: Record "IC Outbox Jnl. Line")
    begin
        ICInboxJnlLine.Project := ICOutboxJnlLine.Project;
    end;
}