pageextension 50047 "Posted Transfer Shipments Ext" extends "Posted Transfer Shipments"
{
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."Location Code" <> '' then
                Rec.SetRange("Transfer-from Code", UserSetup."Location Code");
        end;
    end;
}
