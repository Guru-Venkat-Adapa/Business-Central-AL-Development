codeunit 50100 "MRS Request Status"
{
    [IntegrationEvent(false, false)]
    procedure OnSendRequestForApproval(Var MrsHeader: Record MRSHeader)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelRequestSentForApproval(var MRSHeader: Record MRSHeader)
    begin
    end;
    //======================================================================================For PRS request==================================================================
    [IntegrationEvent(false, false)]
    procedure OnSendRequestForApprovalPRS(Var PRSHeader: Record "PRS Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelRequestSentForApprovalPRS(var PRSHeader: Record "PRS Header")
    begin
    end;
    //=========================================================================Approval and reject eventsubscriber========================================================
    [EventSubscriber(ObjectType::Table, DATABASE::"Approval Entry", 'OnAfterModifyEvent', '', true, true)]
    procedure GetFromApprovali(var Rec: Record "Approval Entry")
    var
        MRSHeader: Record MRSHeader;
        PRSHeader: Record "PRS Header";
    begin
        MRSHeader.SetRange("SIT_MRS No.", Rec."Document No.");
        if MRSHeader.FindSet() then begin
            if Rec.Status = Rec.Status::Approved then begin
                MRSHeader.SIT_Status := MrsHeader.SIT_Status::Released;
                MRSHeader.Modify(true);
            end
            else
                if Rec.Status = Rec.Status::Rejected then begin
                    MRSHeader.SIT_Status := MRSHeader.SIT_Status::Rejected;
                    MRSHeader.Modify(true);
                end;
        end;
        PRSHeader.SetRange("No.", Rec."Document No.");
        if PRSHeader.FindSet() then begin
            if Rec.Status = Rec.Status::Approved then begin
                PRSHeader.Status := PRSHeader.Status::Released;
                PRSHeader.Modify(true);
            end
            else
                if Rec.Status = Rec.Status::Rejected then begin
                    PRSHeader.Status := PRSHeader.Status::Rejected;
                    PRSHeader.Modify(true);
                end;
        end;
    end;
}