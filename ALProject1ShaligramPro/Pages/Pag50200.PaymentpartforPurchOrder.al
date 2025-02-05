page 50200 "Payment part for Purch Order"
{
    // ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Payment part for Purch Order';
    PageType = ListPart;
    SourceTable = "Purch oRder Payment Details";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    Caption = 'Payment type';
                }
                field("Amount AUD"; Rec."Amount AUD")
                {
                    ApplicationArea = All;
                    Caption = 'Amount AUD';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Date';
                }
                field(PaymentComments; Rec.PaymentComments)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                }
                field("Recounclie Date"; Rec."Recounclie Date")
                {
                    ApplicationArea = All;
                    Caption = 'Recounclie Date';
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = All;
                    Caption = 'Batch No';
                }

            }
        }
    }
    // trigger OnNewRecord(BelowxRec: Boolean)
    // begin
    //     if (rec."Document No." = '') then begin
    //         rec."Document No." := xRec."Document No.";
    //         rec.Modify(true);
    //     end;
    // end;
}
