codeunit 50101 "MRS Workflow Event Handle Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunworkflowOnSendClaimForApprovalCode, Database::MRSHeader, MRSDocSendForApproval, 0, false);
        WorkflowEventHandling.AddEventTolibrary(RunWorkflowOnCancelClaimApprovalCode, Database::MRSHeader, MRSDocApprovalReqCanclled, 0, false);
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MRS Request Status", 'OnSendRequestForApproval', '', true, true)]
    procedure RunWorkflowOnSendRequestForApproval(var MRSHeader: Record MRSHeader)
    begin
        WorkflowMgt.HandleEvent(RunworkflowOnSendClaimForApprovalCode, MRSHeader);
    end;

    procedure RunWorkflowOnCancelClaimApprovalCode(): Code[128]
    begin
        exit('RUNWORKFLOWONCANCELSENTAPPROVALREQUEST');
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"MRS Request Status", 'OnCancelRequestSentForApproval', '', true, true)]
    procedure RunWorkflowOnCancelSentApprovalRequest(var MRSHeader: Record MRSHeader)
    begin
        WorkflowMgt.HandleEvent(RunWorkflowOnCancelClaimApprovalCode(), MRSHeader);
    end;

    //=============================================================================================FOR PRS REQUEST=======================================================
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventsToLibraryPRS()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunworkflowOnSendClaimForApprovalCodePRS, Database::"PRS Header", MRSDocSendForApprovalPRS, 0, false);
        WorkflowEventHandling.AddEventTolibrary(RunWorkflowOnCancelClaimApprovalCodePRS, Database::"PRS Header", MRSDocApprovalReqCanclledPRS, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibraryPRS(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelClaimApprovalCodePRS:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelClaimApprovalCodePRS, RunworkflowOnSendClaimForApprovalCodePRS);
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunworkflowOnSendClaimForApprovalCodePRS);
        end;
    end;

    procedure RunworkflowOnSendClaimForApprovalCodePRS(): Code[128]
    begin
        exit('RUNWORKFLOWONSENDFORAPPROVALPRS');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MRS Request Status", 'OnSendRequestForApprovalPRS', '', true, true)]
    procedure RunWorkflowOnSendRequestForApprovalPRS(var PRSHeader: Record "PRS Header")
    begin
        WorkflowMgt.HandleEvent(RunworkflowOnSendClaimForApprovalCodePRS, PRSHeader);
    end;

    procedure RunWorkflowOnCancelClaimApprovalCodePRS(): Code[128]
    begin
        exit('RUNWORKFLOWONCANCELSENTAPPROVALREQUESTPRS');
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"MRS Request Status", 'OnCancelRequestSentForApprovalPRS', '', true, true)]
    procedure RunWorkflowOnCancelSentApprovalRequestPRS(var PRSHeader: Record "PRS Header")
    begin
        WorkflowMgt.HandleEvent(RunWorkflowOnCancelClaimApprovalCodePRS, PRSHeader);
    end;

    var
        WorkflowMgt: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        MRSDocSendForApproval: TextConst ENU = 'Approval of a MRS document is requested';
        MRSDocApprovalReqCanclled: TextConst ENU = 'Approval of a MRS document is cancelled';
        MRSDocSendForApprovalPRS: TextConst ENU = 'Approval of a PRS document is requested';
        MRSDocApprovalReqCanclledPRS: TextConst ENU = 'Approval of a PRS document is cancelled';
}