codeunit 50102 "MRS Approval Mgt"
{
    procedure CheckClaimApprovalsWorkflowEnable(var MRSHeader: Record MRSHeader): Boolean
    begin
        IF NOT IsClaimDocApprovalsWorkflowEnable(MRSHeader) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure IsClaimDocApprovalsWorkflowEnable(var MRSHeader: Record MRSHeader): Boolean
    begin
        IF MRSHeader.SIT_Status <> MRSHeader.SIT_Status::Open then
            EXIT(false);
        EXIT(WorkflowManagement.CanExecuteWorkflow(MRSHeader, WorkflowEventHandlingCust.RunworkflowOnSendClaimForApprovalCode));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        MRSHeader: Record MRSHeader;
    begin
        CASE RecRef.NUMBER OF
            DATABASE::MRSHeader:
                begin
                    RecRef.SetTable(MRSHeader);
                    ApprovalEntryArgument."Document No." := MRSHeader."SIT_MRS No.";
                end;
        end;
    end;
    //==========================================================================================For PRS REQUEST===========================================================
    procedure CheckClaimApprovalsWorkflowEnablePRS(var PRSHeader: Record "PRS Header"): Boolean
    begin
        IF NOT IsClaimDocApprovalsWorkflowEnablePRS(PRSHeader) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure IsClaimDocApprovalsWorkflowEnablePRS(var PRSHeader: Record "PRS Header"): Boolean
    begin
        IF PRSHeader.Status <> PRSHeader.Status::Open then
            EXIT(false);
        EXIT(WorkflowManagement.CanExecuteWorkflow(PRSHeader, WorkflowEventHandlingCust.RunworkflowOnSendClaimForApprovalCodePRS));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgumentPRS(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        PRSHeader: Record "PRS Header";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"PRS Header":
                begin
                    RecRef.SetTable(PRSHeader);
                    ApprovalEntryArgument."Document No." := PRSHeader."No.";
                end;
        end;
    end;

    var
        WorkflowManagement: codeunit "Workflow Management";
        WorkflowEventHandlingCust: Codeunit "MRS Workflow Event Handle Ext";
        NoWorkflowEnabledErr: TextConst ENU = 'No approval workflow for this record type is enabled.';

}