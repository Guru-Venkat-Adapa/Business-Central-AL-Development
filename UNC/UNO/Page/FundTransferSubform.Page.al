page 50110 "Fund Transfer Subform"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Fund Transfer Subform';
    PageType = ListPart;
    SourceTable = "Fund Transfer Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    Caption = 'Posting Date';
                    trigger OnValidate()
                    begin
                        StatusStyleTxt := GetStatusStyleText();
                    end;
                }
                field("Document Type"; Rec."Payment Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                    Caption = 'Document Type';

                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    Caption = 'FundTransfer No.';
                    Editable = false;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                    Caption = 'Send Account Type';

                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    Caption = 'Send Account No.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Caption = 'Description';
                }
                field("IC Account Type"; Rec."IC Account Type")
                {
                    ApplicationArea = All;
                    Caption = 'Receive Account Type';
                    ToolTip = 'Specifies Receive Account Type';

                }
                field("IC Account No."; Rec."IC Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'Receive Account No.';
                    ToolTip = 'Specifies Receive Account No.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Project; Rec.Project)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Project';

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                    Caption = 'Status';
                    StyleExpr = StatusStyleTxt;
                    ToolTip = 'Specifies Status';
                    //  Style= AttentionAccent
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(ApplyEntries)
            {
                Caption = 'Apply Entry';
                Image = ApplyEntries;

                action(ApplyEntry)
                {
                    Caption = 'Apply Entries';
                    Image = ApplyEntries;
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Apply Entries';

                    trigger OnAction()
                    var
                        GenJouLine: Record "Gen. Journal Line";
                        BankAccount: Record "Bank Account";
                        "IC Partner": Record "IC Partner";
                        FundSubform: Record "Fund Transfer Line";
                        LineNo: Integer;
                        DocNo: Code[20];
                    begin
                        FundSubform.SetRange("document No.", Rec."Document No.");
                        FundSubform.SetRange(Status, FundSubform.Status::Open);
                        if FundSubform.FindSet() then begin
                            repeat
                                GenJouLine.SetFilter("Journal Template Name", 'INTERCOMP');
                                GenJouLine.SetFilter("Journal Batch Name", 'DEFAULT');
                                if GenJouLine.FindLast() then
                                    // DocNo := IncStr(GenJouLine."Document No.");
                                    LineNo := GenJouLine."Line No." + 10000
                                else
                                    LineNo := 10000;
                                //comment on document no
                                // DocNo := FundSubform."No.";
                                // end;
                                DocNo := FundSubform."Document No." + '_' + FundSubform."No.";
                                "IC Partner".FindFirst();
                                Clear(GenJouLine);

                                GenJouLine.Init();
                                if FundSubform.Description = '' then begin
                                    BankAccount.Get(FundSubform."Account No.");
                                    GenJouLine.Description := BankAccount.Name;
                                end else
                                    GenJouLine.Description := FundSubform.Description;
                                GenJouLine.Validate("Journal Template Name", FundSubform."Journal Template Name");
                                GenJouLine.Validate("Journal Batch Name", FundSubform."Journal Batch Name");
                                GenJouLine.Validate("Line No.", LineNo);
                                GenJouLine.Validate("Account Type", FundSubform."Account Type");
                                GenJouLine.Validate("Account No.", FundSubform."Account No.");
                                GenJouLine.Validate("Posting Date", FundSubform."Posting Date");
                                GenJouLine.Validate("Document Type", FundSubform."Payment Type");
                                GenJouLine.Validate("Document No.", DocNo);
                                GenJouLine.Validate(Amount, -(FundSubform.Amount));
                                GenJouLine.Validate("Bal. Account Type", GenJouLine."Bal. Account Type"::"IC Partner");
                                GenJouLine.Validate("Bal. Account No.", "IC Partner".Code);
                                GenJouLine.Validate("IC Account Type", FundSubform."IC Account Type");
                                GenJouLine.Validate("IC Account No.", FundSubform."IC Account No.");
                                GenJouLine.Validate(Project, FundSubform.Project);
                                GenJouLine.FundTranLineNo := FundSubform."No.";
                                LineNo += 10000;
                                GenJouLine.Insert(true);
                                FundSubform.Status := FundSubform.Status::InProgress;
                                FundSubform.Modify(false);
                            until FundSubform.Next() = 0;
                            StatusStyleTxt := GetStatusStyleText();
                            // CurrPage.Update();
                            Page.Run(Page::"IC General Journal", GenJouLine);
                        end;
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        StatusStyleTxt := GetStatusStyleText();
        CurrPage.Update(false);
    end;

    procedure GetStatusStyleText() StatusStyleText: Text
    begin
        case Rec.Status of
            Rec.Status::Open:
                StatusStyleText := 'Favorable';
            Rec.Status::InProgress:
                StatusStyleText := 'Unfavorable';
            Rec.Status::Released:
                StatusStyleText := 'Strong';
            Rec.Status::"Fund Transfered":
                StatusStyleText := 'Favorable';
        end;
    end;

    var
        reporttest: Report "Inventory - Availability Plan";
        StatusStyleTxt: Text;
}
