codeunit 50203 "MRS Workflow Event Handle Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunworkflowOnSendClaimForApprovalCode, Database::TestApproval, MRSDocSendForApproval, 0, false);
        WorkflowEventHandling.AddEventTolibrary(RunWorkflowOnCancelClaimApprovalCode, Database::TestApproval, MRSDocApprovalReqCanclled, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelClaimApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelClaimApprovalCode, RunworkflowOnSendClaimForApprovalCode);
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunworkflowOnSendClaimForApprovalCode);
        end;
    end;

    procedure RunworkflowOnSendClaimForApprovalCode(): Code[128]
    begin
        exit('RUNWORKFLOWONSENDFORAPPROVAL');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WorkFlow Request Status", 'OnSendRequestForApproval', '', true, true)]
    procedure RunWorkflowOnSendRequestForApproval(var MRSHeader: Record TestApproval)
    begin
        WorkflowMgt.HandleEvent(RunworkflowOnSendClaimForApprovalCode, MRSHeader);
    end;

    procedure RunWorkflowOnCancelClaimApprovalCode(): Code[128]
    begin
        exit('RUNWORKFLOWONCANCELSENTAPPROVALREQUEST');
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"WorkFlow Request Status", 'OnCancelRequestSentForApproval', '', true, true)]
    procedure RunWorkflowOnCancelSentApprovalRequest(var MRSHeader: Record TestApproval)
    begin
        WorkflowMgt.HandleEvent(RunWorkflowOnCancelClaimApprovalCode(), MRSHeader);
    end;

    var
        WorkflowMgt: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        MRSDocSendForApproval: TextConst ENU = 'Approval of a MRS document is requested';
        MRSDocApprovalReqCanclled: TextConst ENU = 'Approval of a MRS document is cancelled';
    // MRSDocSendForApprovalPRS: TextConst ENU = 'Approval of a PRS document is requested';
    // MRSDocApprovalReqCanclledPRS: TextConst ENU = 'Approval of a PRS document is cancelled';
}