page 50124 POstPayJouApi
{
    PageType = API;
    Caption = 'POst Payment Journal Api Page';
    APIPublisher = 'ShaligramInfotech';
    APIGroup = 'Guru';
    APIVersion = 'v1.0';
    EntityName = 'PostPaymnetJournal';
    EntitySetName = 'PostPaymnetJournal';
    SourceTable = "Gen. Journal Line";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
            }
        }

    }
    trigger OnOpenPage()
    var
        payjou: Record "Gen. Journal Line";
    begin
        payjou.SetRange("Document Type", payjou."Document Type"::Payment);
        payjou.SetFilter("Journal Batch Name", 'BANK');
        if payjou.FindSet() then begin
            repeat
                if (payjou."Account No." <> '') and (payjou.Amount <> 0) then begin
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", payjou);
                end;
            until payjou.Next() = 0;
        end;
    end;
}