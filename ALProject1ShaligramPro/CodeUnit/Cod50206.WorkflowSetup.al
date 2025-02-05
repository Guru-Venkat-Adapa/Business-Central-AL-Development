codeunit 50206 " Custom Workflow Setup"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesTolibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(ClaimWorkflowCategoryTxt, ClaimWorkflowCategoryDescTxt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', true, true)]

    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record 454;
    begin
        WorkflowSetup.InsertTableRelation(DATABASE::TestApproval, 0, DATABASE::"Approval Entry", ApprovalEntry.FIELDNO("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', true, true)]

    local procedure OnInsertWorkflowTemplates()
    begin
        InsertClaimApprovalWorkflowTemplate();
    end;

    local procedure InsertClaimApprovalWorkflowTemplate()
    var
        Workflow: Record 1501;
    Begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, ClaimApprWorkflowCodeTxt, ClaimApprWorkflowDescTxt, ClaimWorkflowCategoryTxt);
        InsertClaimApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    End;

    local procedure InsertClaimApprovalWorkflowDetails(var Workflow: Record 1501)
    var
        WorkflowStepArgument: Record 1523;
        BlankDateFormula: DateFormula;
        WorkflowEventHandlingCust: Codeunit "MRS Workflow Event Handle Ext";
        WorkflowResponseHandling: Codeunit 1521;
        MRSHeader: Record TestApproval;
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, TRUE);
        WorkflowSetup.InsertDocApprovalWorkflowSteps(
        Workflow,
        BuildClaimTypeConditions(MRSHeader.Status::Open),
        WorkflowEventHandlingCust.RunWorkflowOnSendClaimforApprovalCode,
        BuildClaimTypeConditions(MRSHeader.Status::"Request Pending"),
        WorkflowEventHandlingCust.RunWorkflowOnCancelClaimApprovalCode,
        WorkflowStepArgument,
        TRUE);
    end;

    local procedure BuildClaimTypeConditions(Status: Integer): Text
    var
        MRSHeader: Record TestApproval;
    begin
        MRSHeader.SetRange(Status, Status);
        EXIT(STRSUBSTNO(ClaimTypeCondnTxt, WorkflowSetup.Encode(MRSHeader.GETVIEW(FALSE))));
    end;
    //=============================================================================================FOR PRS REQUEST APPROVAL============================================
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    // local procedure OnAddWorkflowCategoriesTolibraryPRS()
    // begin
    //     WorkflowSetup.InsertWorkflowCategory(ClaimWorkflowCategoryTxtPRS, ClaimWorkflowCategoryDescTxtPRS);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', true, true)]

    // local procedure OnAfterInsertApprovalsTableRelationsPRS()
    // var
    //     ApprovalEntry: Record 454;
    // begin
    //     WorkflowSetup.InsertTableRelation(DATABASE::"PRS Header", 0, DATABASE::"Approval Entry", ApprovalEntry.FIELDNO("Record ID to Approve"));
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', true, true)]
    // local procedure OnInsertWorkflowTemplatesPRS()
    // begin
    //     InsertClaimApprovalWorkflowTemplatePRS();
    // end;

    // local procedure InsertClaimApprovalWorkflowTemplatePRS()
    // var
    //     Workflow: Record 1501;
    // Begin
    //     WorkflowSetup.InsertWorkflowTemplate(Workflow, ClaimApprWorkflowCodeTxtPRS, ClaimApprWorkflowDescTxtPRS, ClaimWorkflowCategoryTxtPRS);
    //     InsertClaimApprovalWorkflowDetailsPRS(Workflow);
    //     WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    // End;

    // local procedure InsertClaimApprovalWorkflowDetailsPRS(var Workflow: Record 1501)
    // var
    //     WorkflowStepArgument: Record 1523;
    //     BlankDateFormula: DateFormula;
    //     WorkflowEventHandlingCust: Codeunit "MRS Workflow Event Handle Ext";
    //     WorkflowResponseHandling: Codeunit 1521;
    //     PRSHeader: Record "PRS Header";
    // begin
    //     WorkflowSetup.PopulateWorkflowStepArgument(WorkflowStepArgument,
    //     WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, TRUE);
    //     WorkflowSetup.InsertDocApprovalWorkflowSteps(
    //     Workflow,
    //     BuildClaimTypeConditionsPRS(PRSHeader.Status::Open),
    //     WorkflowEventHandlingCust.RunWorkflowOnSendClaimforApprovalCodePRS,
    //     BuildClaimTypeConditionsPRS(PRSHeader.Status::"Request Pending"),
    //     WorkflowEventHandlingCust.RunWorkflowOnCancelClaimApprovalCodePRS,
    //     WorkflowStepArgument,
    //     TRUE);
    // end;

    // local procedure BuildClaimTypeConditionsPRS(Status: Integer): Text
    // var
    //     PRSHeader: Record "PRS Header";
    // begin
    //     PRSHeader.SetRange(PRSHeader.Status, Status);
    //     EXIT(STRSUBSTNO(ClaimTypeCondnTxtPRS, WorkflowSetup.Encode(PRSHeader.GETVIEW(FALSE))));
    // end;

    var
        WorkflowSetup: Codeunit 1502;
        ClaimWorkflowCategoryTxt: TextConst ENU = 'CDW';
        // ClaimWorkflowCategoryTxtPRS: TextConst ENU = 'CDW1';
        ClaimWorkflowCategoryDescTxt: TextConst ENU = 'MRSHeader Document';
        // ClaimWorkflowCategoryDescTxtPRS: TextConst ENU = 'PRSHeader Document';
        ClaimApprWorkflowCodeTxt: TextConst ENU = 'CAPW';
        // ClaimApprWorkflowCodeTxtPRS: TextConst ENU = 'CAPW1';
        ClaimApprWorkflowDescTxt: TextConst ENU = 'Claim Approval Workflow';
        // ClaimApprWorkflowDescTxtPRS: TextConst ENU = 'Claim Approval Workflow for PRS';

        ClaimTypeCondnTxt: TextConst ENU = '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="ECN">%1</DataItem>MRS</DataItems></ReportParameters>';

    // ClaimTypeCondnTxtPRS: TextConst ENU = '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="ECN">%1</DataItem>PRS</DataItems></ReportParameters>';

}

