page 50123 PaymentJournalApiPage
{
    PageType = API;
    Caption = 'Payment Journal Api Page';
    APIPublisher = 'ShaligramInfotech';
    APIGroup = 'Guru';
    APIVersion = 'v1.0';
    EntityName = 'PaymnetJournal';
    EntitySetName = 'PaymnetJournal';
    SourceTable = "Gen. Journal Line";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("JournalTemplateName"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("JournalBatchName"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("LineNo"; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("JournalBatchId"; Rec."Journal Batch Id")
                {
                    ApplicationArea = All;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("DocumentType"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("DocumentNo"; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("AccountType"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("AccountNo"; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("PaymentMethodCode"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("AmountLCY"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("BalAccountType"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("BalAccountNo"; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                }
                field("AppliestoDocType"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = All;
                }
                field("AppliestoDocNo"; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}