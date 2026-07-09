pageextension 50046 "Transfer Orders Ext" extends "Transfer Orders"
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
