page 50103 "Assisted Setup Gen Led Setup"
{
    PageType = NavigatePage;
    SourceTable = "General Ledger Setup";
    SourceTableTemporary = true;
    Caption = 'Assisted Setup Gen Led Setup';

    layout
    {
        area(content)
        {
            group(Step1)
            {
                Visible = Step1Visible;

                group("Welcome")
                {
                    Caption = 'Welcome to the general ledger setup assisted setup';
                    group(group11)
                    {
                        Caption = '';
                        InstructionalText = 'Use this guide to setup your General Ledger setup from here';
                    }
                }
                group("Let's go")
                {
                    group(group12)
                    {
                        Caption = '';
                        InstructionalText = 'Select Next to get started.';
                    }
                }
            }
            group(Step2)
            {
                Caption = 'Enter information realted to General Setup';
                Visible = Step2Visible;
                field("Allow Posting From"; Rec."Allow Posting From")
                {
                    ApplicationArea = All;
                }
                field("Allow Posting To"; Rec."Allow Posting To")
                {
                    ApplicationArea = All;
                }
                field("LCY Code"; Rec."LCY Code")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field("Local Currency Symbol"; Rec."Local Currency Symbol")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field("Local Currency Description"; Rec."Local Currency Description")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ShowMandatory = true;
                }
            }
            group(Step3)
            {
                Caption = 'Enter information related to Dimension Setup';
                Visible = Step3Visible;
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Back)
            {
                ApplicationArea = All;
                InFooterBar = true;
                Enabled = BackEnable;
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action(Next)
            {
                ApplicationArea = All;
                Enabled = NextEnable;
                InFooterBar = true;
                Image = NextRecord;

                trigger OnAction()
                begin
                    NextStep(False);
                end;
            }
            action(Finish)
            {
                ApplicationArea = All;
                InFooterBar = true;
                Enabled = FinishEnable;
                Image = Approve;

                trigger OnAction()
                begin
                    Finished();
                end;
            }
        }
    }
    trigger OnInit()
    var
    begin
        EnableControls();
    end;

    trigger OnOpenPage()
    begin
        GenLedSetup.Get();
        GenLedSetup.Init;
        Rec := GenLedSetup;
        CurrPage.Update();
    end;

    var
        BackEnable: Boolean;
        NextEnable: Boolean;
        FinishEnable: Boolean;
        Step1Visible: Boolean;
        Step2Visible: Boolean;
        Step3Visible: Boolean;
        Step: Option Start,Fill,Finish;
        TopBannerVisible: Boolean;
        FinishActionEnabled: Boolean;
        GenLedSetup: Record "General Ledger Setup";

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
            Step := Step - 1
        else
            Step := Step + 1;
        EnableControls();
    end;

    local procedure Finished()
    begin
        if (Rec."Shortcut Dimension 3 Code" <> '') and (Rec."Shortcut Dimension 4 Code" <> '') then begin
            StoreRecordVar();
            CurrPage.Close();
        end else begin
            Error('Please enter mandatory field values');
        end;
    end;

    local procedure EnableControls()
    begin
        ResetControls();
        case Step of
            Step::Start:
                ShowStep1();
            Step::Fill:
                ShowStep2();
            Step::Finish:
                ShowStep3();
        end;
    end;

    local procedure ShowStep1()
    begin
        Step1Visible := true;
        BackEnable := false;
        NextEnable := true;
        FinishEnable := false;
    end;

    local procedure ShowStep2()
    begin
        Step2Visible := true;
        BackEnable := true;
        NextEnable := true;
        FinishEnable := false;
        GenLedSetup.SetRange("Primary Key", Rec."Primary Key");
        if GenLedSetup.FindSet() then begin
            Rec."Allow Posting From" := GenLedSetup."Allow Posting From";
            Rec."Allow Posting To" := GenLedSetup."Allow Posting To";
            Rec."LCY Code" := GenLedSetup."LCY Code";
            Rec."Local Currency Symbol" := GenLedSetup."Local Currency Symbol";
            Rec."Local Currency Description" := GenLedSetup."Local Currency Description";
        end;
    end;

    local procedure ShowStep3()
    begin
        if (Rec."LCY Code" <> '') and (Rec."Local Currency Symbol" <> '') and (Rec."Local Currency Description" <> '') then begin
            Step3Visible := true;
            BackEnable := true;
            NextEnable := false;
            FinishEnable := true;
            FinishActionEnabled := true;
            GenLedSetup.SetRange("Primary Key", Rec."Primary Key");
            if GenLedSetup.FindSet() then begin
                Rec."Shortcut Dimension 2 Code" := GenLedSetup."Shortcut Dimension 2 Code";
                Rec."Shortcut Dimension 3 Code" := GenLedSetup."Shortcut Dimension 3 Code";
                Rec."Shortcut Dimension 4 Code" := GenLedSetup."Shortcut Dimension 4 Code";
                Rec."Shortcut Dimension 5 Code" := GenLedSetup."Shortcut Dimension 5 Code";
                Rec."Shortcut Dimension 6 Code" := GenLedSetup."Shortcut Dimension 6 Code";
                Rec."Shortcut Dimension 7 Code" := GenLedSetup."Shortcut Dimension 7 Code";
                Rec."Shortcut Dimension 8 Code" := GenLedSetup."Shortcut Dimension 8 Code";
            end;
        end else begin
            Step := Step - 1;
            Step2Visible := true;
            Error('Please enter manditory field values');
        end;
    end;

    local procedure ResetControls();
    begin
        FinishEnable := false;
        BackEnable := true;
        NextEnable := true;
        Step1Visible := false;
        Step2Visible := false;
        Step3Visible := false;
    end;

    local procedure StoreRecordVar();
    begin
        GenLedSetup.TransferFields(Rec, true);
        GenLedSetup.Modify(true);
    end;
}

