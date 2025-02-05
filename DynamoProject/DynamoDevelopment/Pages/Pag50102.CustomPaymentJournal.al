page 50102 "Custom Payment Journal"
{
    ApplicationArea = All;
    Caption = 'Custom Payment Journal';
    PageType = List;
    SourceTable = "Custom Payment Journal";
    UsageCategory = Administration;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(PostingDate; Rec.PostingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                }
                // field(DocumentTypePayment; Rec.DocumentTypePayment)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Payment Type';
                // }
                // field("Document No. Series"; Rec."Document No. Series")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Document No.';
                // }
                // field("Account Type"; Rec."Account Type")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Account Type';
                // }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'Account No.';
                    ShowMandatory = true;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                // field("Bal. Account Type"; Rec."Bal. Account Type")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Balance Account Type';
                // }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'Payment  Account No.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Order No.';
                    ToolTip = 'To get sales Order No.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                ApplicationArea = All;
                Caption = 'Submit';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    GenLine: Record "Gen. Journal Line";
                    Custom: Record "Custom Payment Journal";
                    LineNo: Integer;
                begin

                    GenLine.SetFilter("Journal Template Name", '%1', 'PAYMENT');
                    GenLine.SetFilter("Journal Batch Name", '%1', 'STOREPMT');
                    GenLine.SetFilter("Source Code", '%1', 'PAYMENTJNL');
                    If GenLine.FindLast() then begin
                        LineNo := GenLine."Line No.";
                        Custom.Reset();
                        IF Custom.FindSet() then
                            repeat
                                GenLine.Init();
                                GenLine."Line No." := LineNo + 10000;
                                GenLine.Validate("Posting Date", Custom.PostingDate);
                                GenLine.Validate("Document Type", GenLine."Document Type"::Payment);
                                GenLine.Validate("Document No.", Custom."Document No. Series");
                                GenLine.Validate("Account Type", GenLine."Account Type"::Customer);
                                Custom.TestField("Account No.");
                                GenLine."Sales Order No." := Custom."Sales Order No.";
                                GenLine.Validate("Account No.", Custom."Account No.");
                                GenLine.Validate(Description, Custom.Description);
                                GenLine.Validate("Bal. Account Type", GenLine."Bal. Account Type"::"Bank Account");
                                GenLine.Validate("Bal. Account No.", Custom."Bal. Account No.");
                                GenLine.Validate(Amount, Custom.Amount);
                                LineNo := GenLine."Line No.";
                                GenLine.Insert(true);
                                Custom.Delete();
                            until Custom.Next() = 0;
                    end else begin
                        LineNo := 0;
                        Custom.Reset();
                        IF Custom.FindSet() then
                            repeat
                                GenLine.Init();
                                GenLine.Validate("Journal Template Name", 'PAYMENT');
                                GenLine.Validate("Journal Batch Name", 'STOREPMT');
                                GenLine.Validate("Source Code", 'PAYMENTJNL');
                                GenLine."Line No." := LineNo + 10000;
                                GenLine.Validate("Posting Date", Custom.PostingDate);
                                GenLine.Validate("Document Type", GenLine."Document Type"::Payment);
                                GenLine.Validate("Document No.", Custom."Document No. Series");
                                GenLine.Validate("Account Type", GenLine."Account Type"::Customer);
                                Custom.TestField("Account No.");
                                GenLine."Sales Order No." := Custom."Sales Order No.";
                                GenLine.Validate("Account No.", Custom."Account No.");
                                GenLine.Validate(Description, Custom.Description);
                                GenLine.Validate("Bal. Account Type", GenLine."Bal. Account Type"::"Bank Account");
                                GenLine.Validate("Bal. Account No.", Custom."Bal. Account No.");
                                GenLine.Validate(Amount, Custom.Amount);
                                LineNo := GenLine."Line No.";
                                GenLine.Insert(true);
                                Custom.Delete();
                            until Custom.Next() = 0;
                    end;


                end;
            }
        }
    }
}
