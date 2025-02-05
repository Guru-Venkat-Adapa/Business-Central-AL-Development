codeunit 50202 "WorkFlow Request Status"
{
    /***********************************                Sending and cancelling Request                   **************************/
    [IntegrationEvent(false, false)]
    procedure OnSendRequestForApproval(Var MrsHeader: Record TestApproval)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelRequestSentForApproval(var MRSHeader: Record TestApproval)
    begin
    end;

    /************************************                     Approval Flow                    ********************************************/
    [EventSubscriber(ObjectType::Table, DATABASE::"Approval Entry", 'OnAfterModifyEvent', '', true, true)]
    procedure GetFromApprovali(var Rec: Record "Approval Entry")
    var
        MRSHeader: Record TestApproval;
    // PRSHeader: Record "PRS Header";
    begin
        MRSHeader.SetRange(Document, Rec."Document No.");
        if MRSHeader.FindSet() then begin
            if Rec.Status = Rec.Status::Approved then begin
                MRSHeader.Status := MrsHeader.Status::Released;
                MRSHeader.Modify(true);
            end
            else
                if Rec.Status = Rec.Status::Rejected then begin
                    MRSHeader.Status := MRSHeader.Status::Rejected;
                    MRSHeader.Modify(true);
                end;
        end;
        // PRSHeader.SetRange("No.", Rec."Document No.");
        // if PRSHeader.FindSet() then begin
        //     if Rec.Status = Rec.Status::Approved then begin
        //         PRSHeader.Status := PRSHeader.Status::Released;
        //         PRSHeader.Modify(true);
        //     end
        //     else
        //         if Rec.Status = Rec.Status::Rejected then begin
        //             PRSHeader.Status := PRSHeader.Status::Rejected;
        //             PRSHeader.Modify(true);
        //         end;
        // end;
    end;
}
