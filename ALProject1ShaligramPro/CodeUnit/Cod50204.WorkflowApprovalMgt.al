codeunit 50204 "Workflow Approval Mgt"
{
    procedure CheckClaimApprovalsWorkflowEnable(var MRSHeader: Record TestApproval): Boolean
    begin
        IF NOT IsClaimDocApprovalsWorkflowEnable(MRSHeader) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure IsClaimDocApprovalsWorkflowEnable(var MRSHeader: Record TestApproval): Boolean
    begin
        IF MRSHeader.Status <> MRSHeader.Status::Open then
            EXIT(false);
        EXIT(WorkflowManagement.CanExecuteWorkflow(MRSHeader, WorkflowEventHandlingCust.RunworkflowOnSendClaimForApprovalCode));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        MRSHeader: Record TestApproval;
    begin
        CASE RecRef.NUMBER OF
            DATABASE::TestApproval:
                begin
                    RecRef.SetTable(MRSHeader);
                    ApprovalEntryArgument."Document No." := MRSHeader.Document;
                end;
        end;
    end;

    var
        WorkflowManagement: codeunit "Workflow Management";
        WorkflowEventHandlingCust: Codeunit "MRS Workflow Event Handle Ext";
        NoWorkflowEnabledErr: TextConst ENU = 'No approval workflow for this record type is enabled.';

}
