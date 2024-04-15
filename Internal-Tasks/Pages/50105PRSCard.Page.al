page 50105 "PRS Card"
{
    PageType = Card;
    // ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "PRS Header";
    Caption = 'PRS Card';
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the value of the no. field';
                    Editable = true;
                }
                field("Shortcut Dim 1 Code"; Rec."Shortcut Dim 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 1 Code';
                    ToolTip = 'Specifies the value of shortcut dimension 1 code';
                    Editable = false;
                }
                field("Shortcut Dim 2 Code"; Rec."Shortcut Dim 2 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 2 Code';
                    ToolTip = 'Specifies the value of shortcut dimension 2 code';
                    Editable = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';
                    ToolTip = 'Specifies the value of the comment field';
                    Editable = true;
                }
                field("Project Ref. No."; Rec."Project Ref. No.")
                {
                    ApplicationArea = All;
                    Caption = 'Project Ref. No.';
                    ToolTip = 'Specifies the value of the project reference no. field';
                    Editable = true;
                }
                field("Project Stage Code"; Rec."Project Stage Code")
                {
                    ApplicationArea = All;
                    Caption = 'Project Stage Code';
                    ToolTip = 'Specifies the value of project stage code';
                    Editable = true;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    ToolTip = 'Specifies the value of document date field';
                    Editable = true;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the value of posting date field';
                    Editable = true;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    ToolTip = 'Specifies the value of status field';
                    Style = Strong;
                }
            }
            part("PRS Line"; "PRS SubForm")
            {
                ApplicationArea = All;
                SubPageLink = "Documnet No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Dimensions")
            {
                ApplicationArea = All;
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Category12;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Specifies the dimension type';
                trigger OnAction()
                begin

                end;
            }
            action("&Approval")
            {
                ApplicationArea = All;
                Caption = 'Approval';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Specfies to approve the document';
                trigger OnAction()
                begin

                end;
            }
            action("Send For Approval")
            {
                ApplicationArea = All;
                Caption = 'Send For Approval';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Approves the requested changes';
                trigger OnAction()
                begin
                    RequestStatus.OnSendRequestForApprovalPRS(rec);
                end;
            }
            action("Cancel For Approval")
            {
                ApplicationArea = All;
                Caption = 'Cancel For Approval';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the Request sent for approval';
                trigger OnAction()
                begin
                    RequestStatus.OnCancelRequestSentForApprovalPRS(Rec);
                end;
            }
            action("Get MRS Line")
            {
                ApplicationArea = All;
                Caption = 'Get MRS Line';
                Image = Line;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Feteches the data from MRS line';
                trigger OnAction()
                begin

                end;
            }
            action("Release")
            {
                ApplicationArea = All;
                Caption = 'Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Specifies to release the document';
                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Released;
                end;
            }
            action("Open")
            {
                ApplicationArea = All;
                Caption = 'Re-open';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Reopen the document to make changes';
                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Open;
                end;
            }
            action("Close Requisition")
            {
                ApplicationArea = All;
                Caption = 'Close Requisition';
                Image = CloseDocument;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Specifies to close the requisition document';
                trigger OnAction()
                begin

                end;
            }
            action("Print")
            {
                ApplicationArea = All;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category11;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Used to make an print out of the document';
                trigger OnAction()
                begin

                end;
            }
            action("Post")
            {
                ApplicationArea = All;
                Caption = 'Post...';
                Image = PostedOrder;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Create a Purchse Order from PRS Requisition document';
                trigger OnAction()
                var
                    code: Codeunit "MRS Actions";
                begin
                    code.CreatePObyPRS(Rec);
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalMgt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalMgt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalMgt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;

    trigger OnOpenPage()
    var
        MRSHeader: Record MRSHeader;
        MRSLine: Record MRSLine;
        PRSHeader: Record "PRS Header";
        PRSLine: Record "PRS Line";
        Item: Record Item;
    begin
        PRSHeader.SetRange("No.", Rec."No.");
        if PRSHeader.FindSet() then begin
            PRSLine.SetRange("Documnet No.", Rec."No.");
            if PRSLine.FindSet() then begin
                repeat
                    Item.SetRange(Item."No.", PRSLine."No.");
                    if Item.FindSet() then begin
                        Clear(PRSLine."Vendor No.");
                        PRSLine."Vendor No." := Item."Vendor No.";
                        PRSLine.Modify(true);
                    end;
                until PRSLine.Next() = 0;
            end;
        end;
    end;

    var
        RequestStatus: Codeunit "MRS Request Status";

        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistForCurrUser, OpenApprovalEntriesExist,
        CanCancelApprovalForRecord, CanRequestApprovalForFlow, CanCancelApprovalForFlow,
        gPageEditable : Boolean;
        DimMgt: Codeunit DimensionManagement;
}