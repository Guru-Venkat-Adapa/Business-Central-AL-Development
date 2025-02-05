page 50201 "Test List Page"
{
    ApplicationArea = All;
    Caption = 'Test List Page';
    PageType = List;
    SourceTable = TestApproval;
    CardPageId = "Test Card Page";
    UsageCategory = Lists;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Document; Rec.Document)
                {
                    ToolTip = 'Specifies the value of the Document field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
            }
        }
    }
}
page 50202 "Test Card Page"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = TestApproval;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Document; Rec.Document)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("Approval Group")
            {
                action("Send For Approval")
                {
                    ApplicationArea = All;
                    Caption = 'Send For Approval';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
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
                    // Visible = Rec.Status = (Rec.Status::"Request Pending");
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Enabled = Rec.Status = Rec.Status::"Request Pending";
                    ToolTip = 'Cancels the requested request';
                    trigger OnAction()
                    begin
                        RequestStatus.OnCancelRequestSentForApproval(Rec);
                    end;
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Status := Rec.Status::Open;
    end;

    var
        RequestStatus: Codeunit "WorkFlow Request Status";
        genjouline: Record "Gen. Journal Line";
        VenledEntr: Record "Vendor Ledger Entry";
}
