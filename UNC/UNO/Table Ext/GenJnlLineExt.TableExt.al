tableextension 50115 "Gen. Jnl. Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50100; Project; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            var
                Projects: Record Job;
                FundTranfer: Record "Fund Transfer Header";
            begin
                // FundTranfer.SetRange(No, Rec."Fund No.");
                If FundTranfer.FindFirst() then begin
                    FundTranfer.TestField(ToCompany);
                    Projects.ChangeCompany(FundTranfer.ToCompany);
                    Projects.Reset();
                    Projects.FindSet();
                    if Page.RunModal(Page::"Job List", Projects) = Action::LookupOK then
                        Rec.Project := Projects."No.";
                end;
            end;
        }
        field(50102; FundTranLineNo; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}