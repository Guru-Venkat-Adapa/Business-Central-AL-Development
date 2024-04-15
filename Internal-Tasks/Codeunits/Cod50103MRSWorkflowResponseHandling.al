codeunit 50103 "MRS Workflow Response Handling"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    procedure OnOpenDocument(RecRef: RecordRef; Var Handled: Boolean)
    var
        MRSHeader: Record MRSHeader;
    begin
        CASE RecRef.NUMBER OF
            DATABASE::MRSHeader:
                begin
                    RecRef.SetTable(MRSHeader);
                    MRSHeader.SIT_Status := MRSHeader.SIT_Status::Open;
                    MRSHeader.Modify;
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]

    procedure OnReleaseDocument(RecRef: RecordRef; Var Handled: Boolean)
    var
        MRSHeader: Record MRSHeader;
    begin
        CASE RecRef.NUMBER OF
            DATABASE::MRSHeader:
                begin
                    RecRef.SetTable(MRSHeader);
                    MRSHeader.SIT_Status := MRSHeader.SIT_Status::Released;
                    MRSHeader.Modify;
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    procedure OnSetStatusToPendingApproval(RecRef: RecordRef; Var Variant: Variant; Var IsHandled: Boolean)
    var
        MRSHeader: Record MRSHeader;
    begin
        CASE RecRef.NUMBER OF
            DATABASE::MRSHeader:
                begin

                    RecRef.SetTable(MRSHeader);
                    MRSHeader.SIT_Status := MRSHeader.SIT_Status::"Request Pending";
                    MRSHeader.Modify;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit 1521;
        WorkflowEventHandlingCust: Codeunit "MRS Workflow Event Handle Ext";
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode,
                WorkflowEventHandlingCust.RunworkflowOnSendClaimForApprovalCode);
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingCust.RunWorkflowOnSendClaimForApprovalCode);
            WorkflowResponseHandling.CancelAllApprovalRequestsCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode,
        WorkflowEventHandlingCust.RunWorkflowOnCancelClaimApprovalCode);
            WorkflowResponseHandling.OpenDocumentCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode,
        WorkflowEventHandlingCust.RunWorkflowOnCancelClaimApprovalCode);
        end;
    end;

    //========================================================================================For PRS REQUEST APPROVAL====================================================
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    procedure OnOpenDocumentPRS(RecRef: RecordRef; Var Handled: Boolean)
    var
        PRSHeader: Record "PRS Header";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"PRS Header":
                begin
                    RecRef.SetTable(PRSHeader);
                    PRSHeader.Status := PRSHeader.Status::Open;
                    PRSHeader.Modify;
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]

    procedure OnReleaseDocumentPRS(RecRef: RecordRef; Var Handled: Boolean)
    var
        PRSHeader: Record "PRS Header";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"PRS Header":
                begin
                    RecRef.SetTable(PRSHeader);
                    PRSHeader.Status := PRSHeader.Status::Released;
                    PRSHeader.Modify;
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    procedure OnSetStatusToPendingApprovalPRS(RecRef: RecordRef; Var Variant: Variant; Var IsHandled: Boolean)
    var
        PRSHeader: Record "PRS Header";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"PRS Header":
                begin
                    RecRef.SetTable(PRSHeader);
                    PRSHeader.Status := PRSHeader.Status::"Request Pending";
                    PRSHeader.Modify;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowResponsePredecessorsToLibraryPRS(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit 1521;
        WorkflowEventHandlingCust: Codeunit "MRS Workflow Event Handle Ext";
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode,
                WorkflowEventHandlingCust.RunworkflowOnSendClaimForApprovalCodePRS);
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingCust.RunworkflowOnSendClaimForApprovalCodePRS);
            WorkflowResponseHandling.CancelAllApprovalRequestsCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode,
        WorkflowEventHandlingCust.RunWorkflowOnCancelClaimApprovalCodePRS);
            WorkflowResponseHandling.OpenDocumentCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode,
        WorkflowEventHandlingCust.RunWorkflowOnCancelClaimApprovalCodePRS);
        end;
    end;
}