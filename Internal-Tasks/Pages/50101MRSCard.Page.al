page 50101 "MRS Card Page"
{
    PageType = Card;
    // ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = MRSHeader;
    Caption = 'MRS Card Page';
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("MRS No."; Rec."SIT_MRS No.")
                {
                    ApplicationArea = basic;
                    Caption = 'MRS No.';
                    ToolTip = 'Specifies the value of the MRS No. field';
                }
                field("Manual MRS No."; Rec."SIT_Manual MRS No.")
                {
                    ApplicationArea = basic;
                    Caption = 'Manual MRS No.';
                    ToolTip = 'specifies the value of the Manual MRS No. field';
                }
                field("Shortcut Dimension 1 Code"; Rec."SIT_Requistion Division")
                {
                    ApplicationArea = basic;
                    Caption = 'Requisition Division';
                    ToolTip = 'Specifies the value of the Requisition Division field';
                }
                field("Shortcut Dimension 2 Code"; Rec."SIT_Requistion Department")
                {
                    ApplicationArea = basic;
                    Caption = 'Requisition Department';
                    ToolTip = 'Specifies the value of the Requisition Department field';
                }
                field(Comment; Rec.SIT_Comment)
                {
                    ApplicationArea = basic;
                    Caption = 'Comment';
                    ToolTip = 'Specifies the value of the Comment field';
                }
                field(Status; Rec.SIT_Status)
                {
                    Style = Strong;
                    ApplicationArea = basic;
                    Caption = 'Status';
                    ToolTip = 'Specifies the value of the Status field';
                }
                field("Document Date"; Rec."SIT_Document Date")
                {
                    ApplicationArea = basic;
                    Caption = 'Document Date';
                    ToolTip = 'Specifies the value of the Document Date field';
                }
                field("Expected Delivery Date"; Rec."SIT_Expected Delivery Date")
                {
                    ApplicationArea = basic;
                    Caption = 'Expected Delivery Date';
                    ToolTip = 'Specifies the value of the Expected Delivery Date field';
                }
                field("Location Code"; Rec."SIT_Location Code")
                {
                    ApplicationArea = basic;
                    Caption = 'Location Code';
                    ToolTip = 'Specifies the value of the Location Code field';
                }

               
            }
            part(MRSLine; "MRS Subform")
            {
                ApplicationArea = All;
                SubPageLink = "SIT_Document No." = field("SIT_MRS No.");
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group("Rquisition Group")
            {
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category12;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortcutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = basic;
                    Caption = '&Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the &Approvals action';
                    // Visible = false;
                    trigger OnAction()
                    begin

                    end;
                }
            }
            group("Approval Group")
            {
                action("Send For Approval")
                {
                    ApplicationArea = All;
                    Caption = 'Send For Approval';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approves the requested changes';
                    trigger OnAction()
                    begin
                        RequestStatus.OnSendRequestForApproval(Rec);
                    end;
                }
                action("Cancel For Approval")
                {
                    ApplicationArea = All;
                    Caption = 'Cancel For Approval';
                    Image = Reject;
                    Promoted = true;
                    Visible = Rec.SIT_Status = (Rec.SIT_Status::"Request Pending");
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancels the requested request';
                    trigger OnAction()
                    begin
                        RequestStatus.OnCancelRequestSentForApproval(Rec);
                    end;
                }
            }
            group("Function Group")
            {
                action("Cal Qty On Purchase")
                {
                    ApplicationArea = basic;
                    Caption = 'Calculate Qty On Purchase';
                    ToolTip = 'Executes to calcuate Quantity on purchase action';
                    Visible = false;
                    trigger OnAction()
                    begin

                    end;
                }
                action("Review MRS")
                {
                    ApplicationArea = basic;
                    Caption = 'Review &MRS';
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Review &MRS action';
                    Visible = false;
                    trigger OnAction()
                    begin

                    end;
                }
                action("Release")
                {
                    ApplicationArea = basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortcutKey = 'Ctrl+F9';
                    ToolTip = 'Executes the Re&lease action';
                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "MRS Actions";
                    begin
                        // ReleaseSalesDoc.PerformManualRelease(Rec);
                        Rec.SIT_Status := Rec.SIT_Status::Released;
                    end;
                }
                action("Reopen")
                {
                    ApplicationArea = basic;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Re&open action';
                    trigger OnAction()
                    begin
                        Rec.SIT_Status := Rec.SIT_Status::Open;
                    end;
                }
                action("Cancel MRS")
                {
                    ApplicationArea = basic;
                    Caption = 'Cancel MRS';
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Cancelling the MRS Document action';
                    trigger OnAction()
                    begin
                        Rec.SIT_Status := Rec.SIT_Status::Cancelled;
                    end;
                }
            }
            action(CreatePRS)
            {
                ApplicationArea = basic;
                Caption = 'Post...';
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = PostOrder;
                ToolTip = 'Creates a PRS document for the respective MRS document';
                trigger OnAction()
                var
                    code: Codeunit "MRS Actions";
                begin
                    code.CreatePRSbyMRS(Rec);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalMgt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalMgt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalMgt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanCancelApprovalForFlow, CanCancelApprovalForFlow);
    end;

    trigger OnOpenPage()
    var
        PRSHeader: Record "PRS Header";
        PRSLine: Record "PRS Line";
        MRSHeader: Record MRSHeader;
        MRSLine: Record MRSLine;
        Purchase: Record "Purchase Header";
        Temp: Integer;
    begin
        MRSLine.SetRange("SIT_Document No.", Rec."SIT_MRS No.");
        if MRSLine.FindSet() then begin
            PRSHeader.SetRange("Project Ref. No.", Rec."SIT_MRS No.");
            if PRSHeader.FindSet() then begin
                PRSLine.SetRange("Documnet No.", PRSHeader."No.");
                if PRSLine.FindSet() then begin
                    repeat
                        Temp := PRSLine."Qty to Order" + MRSLine."SIT_Available Stock";
                        if PRSLine."Qty to Order" <> Temp then begin
                            MRSLine.SIT_Quantity := PRSLine."Qty to Order" + MRSLine."SIT_Available Stock";
                            MRSLine.Modify(true);
                        end;
                    until PRSLine.Next() = 0;
                end;
            end;
        end;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeShowDocDim(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        OldDimSetID := Rec."SIT_Dimension Setup ID";
        Rec."SIT_Dimension Setup ID" :=
          DimMgt.EditDimensionSet(
            Rec."SIT_Dimension Setup ID", StrSubstNo('%1 %2', Rec."SIT_Document Type", Rec."SIT_MRS No."),
            Rec."SIT_Requistion Division", Rec."SIT_Requistion Department");
        OnShowDocDimOnBeforeUpdateMRSLines(Rec, xRec);
        if OldDimSetID <> Rec."SIT_Dimension Setup ID" then begin
            Rec.Modify(true);
            if MRSLinesExist(Rec) then
                UpdateAllLineDim(Rec."SIT_Dimension Setup ID", OldDimSetID, Rec);
        end;
    end;

    procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer; var MRSHeader: Record "MRSHeader")
    var
        ATOLink: Record "Assemble-to-Order Link";
        NewDimSetID: Integer;
        // ShippedReceivedItemLineDimChangeConfirmed: Boolean;
        MRSLine: Record "MRSLine";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        // OnBeforeUpdateAllLineDim(Rec, NewParentDimSetID, OldParentDimSetID, IsHandled, xRec);
        if IsHandled then
            exit;

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not GetHideValidationDialog and GuiAllowed then
            if not ConfirmUpdateAllLineDim(NewParentDimSetID, OldParentDimSetID) then
                exit;

        MRSLine.Reset();
        // SalesLine.SetRange("Document Type", "Document Type");
        MRSLine.SetRange("SIT_Document No.", MrsHeader."SIT_MRS No.");
        MRSLine.LockTable();
        if MRSLine.Find('-') then
            repeat
                // OnUpdateAllLineDimOnBeforeGetSalesLineNewDimsetID(SalesLine, NewParentDimSetID, OldParentDimSetID);
                NewDimSetID := DimMgt.GetDeltaDimSetID(MRSLine."SIT_Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if MRSLine."SIT_Dimension Set ID" <> NewDimSetID then begin
                    MRSLine."SIT_Dimension Set ID" := NewDimSetID;

                    // if not GetHideValidationDialog and GuiAllowed then
                    //     VerifyShippedReceivedItemLineDimChange(ShippedReceivedItemLineDimChangeConfirmed);

                    DimMgt.UpdateGlobalDimFromDimSetID(
                      MRSLine."SIT_Dimension Set ID", MRSLine."SIT_Shortcut Dimension 1 Code", MRSLine."SIT_Shortcut Dimension 2 Code");

                    // OnUpdateAllLineDimOnBeforeSalesLineModify(SalesLine);
                    MRSLine.Modify();
                    // ATOLink.UpdateAsmDimFromSalesLine(SalesLine);
                end;
            until MRSLine.Next = 0;
    end;

    procedure GetHideValidationDialog(): Boolean
    var
        EnvInfoProxy: Codeunit "Env. Info Proxy";
    begin
        exit(HideValidationDialog);
    end;

    procedure MRSLinesExist(var Rec: Record "MRSHeader"): Boolean
    var
        MrsLine: Record "MRSLine";
    begin
        MrsLine.Reset();
        // SalesLine.SetRange("Document Type", "Document Type");
        MrsLine.SetRange("SIT_Document No.", Rec."SIT_MRS No.");
        exit(not MrsLine.IsEmpty);
    end;

    local procedure ConfirmUpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer) Confirmed: Boolean;
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        // OnBeforeConfirmUpdateAllLineDim(Rec, xRec, NewParentDimSetID, OldParentDimSetID, Confirmed, IsHandled);
        if not IsHandled then
            Confirmed := Confirm(Text064);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]; var MRSHeader: Record MRSHeader)
    var
        OldDimSetID: Integer;
    begin
        // OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);

        OldDimSetID := Rec."SIT_Dimension Setup ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, Rec."SIT_Dimension Setup ID");
        if Rec."SIT_MRS No." <> '' then
            Rec.Modify;

        if OldDimSetID <> Rec."SIT_Dimension Setup ID" then begin
            Rec.Modify;
            if MRSLinesExist(MrsHeader) then
                UpdateAllLineDim(Rec."SIT_Dimension Setup ID", OldDimSetID, MrsHeader);
        end;

        // OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowDocDim(var SalesHeader: Record MRSHeader; xSalesHeader: Record MRSHeader; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnShowDocDimOnBeforeUpdateMRSLines(var SalesHeader: Record MRSHeader; xSalesHeader: Record MRSHeader)
    begin
    end;

    var
        RequestStatus: Codeunit "MRS Request Status";

        tempblob : Record  TempBlob;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistForCurrUser, OpenApprovalEntriesExist,
        CanCancelApprovalForRecord, CanRequestApprovalForFlow, CanCancelApprovalForFlow,
        gPageEditable : Boolean;
        DimMgt: Codeunit DimensionManagement;
        MRSLine: Record MRSLine;
        Text064: Label 'You may have changed a dimension.\\Do you want to update the lines?';

    protected var
        HideValidationDialog: Boolean;

}