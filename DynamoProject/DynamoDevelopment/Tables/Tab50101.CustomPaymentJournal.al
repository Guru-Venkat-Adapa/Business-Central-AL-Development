table 50101 "Custom Payment Journal"
{
    Caption = 'Custom Payment Journal';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; PostingDate; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Date';
            trigger OnValidate()
            var

                Custom: Record "Custom Payment Journal";
                GenLine: Record "Gen. Journal Line";
            begin

                Rec.DocumentTypePayment := 'Payment';
                Rec."Account Type" := 'Customer';
                Rec."Bal. Account Type" := 'Bank Account';

                GenLine.Reset();
                GenLine.SetFilter("Journal Template Name", '%1', 'PAYMENT');
                GenLine.SetFilter("Journal Batch Name", '%1', 'STOREPMT');
                GenLine.SetFilter("Source Code", '%1', 'PAYMENTJNL');
                If GenLine.FindLast() then begin
                    LastNo := GenLine."Document No.";
                    Rec."Document No. Series" := IncStr(LastNo);
                    If (GenLine."Document No." <> '') and (Rec.Count <> 0) then begin
                        Custom.Reset();
                        Custom.FindLast();
                        LastNo := Custom."Document No. Series";
                        Rec."Document No. Series" := IncStr(LastNo);
                    end;
                end else if (Rec.Count <> 0) then begin
                    Custom.Reset();
                    Custom.FindLast();
                    LastNo := Custom."Document No. Series";
                    Rec."Document No. Series" := IncStr(LastNo);
                end
                else begin
                    GenJouTemp.Reset();
                    GenJouTemp.SetFilter("Journal Template Name", '%1', 'PAYMENT');
                    GenJouTemp.SetFilter(Name, '%1', 'STOREPMT');
                    if GenJouTemp.FindFirst() then begin
                        NoSeries.Get(GenJouTemp."No. Series");
                        LastNo := NoSeriesMgt.GetLastNoUsed(GenJouTemp."No. Series");
                        Rec."Document No. Series" := IncStr(LastNo);
                    end;
                end;
            end;
        }
        field(4; DocumentTypePayment; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document Type';
        }
        field(5; "Document No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No. Series';
        }
        field(6; "Account Type"; text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Account Type';
        }
        field(7; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
                Rec_Customer: Record Customer;
            begin
                if Rec_Customer.Get(Rec."Account No.") then
                    Rec.Description := Rec_Customer.Name
                else
                    Rec.Description := '';
            end;
        }
        field(8; Description; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
        field(9; "Bal. Account Type"; Text[20])
        {
            Caption = 'Bal. Account Type';
        }
        field(10; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = "Bank Account"."No.";
        }
        field(11; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                If Rec.Amount <> 0 then
                    Rec.Amount := Round(-(Rec.Amount));
            end;
        }
        field(51; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(12; "Sales Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order), "Sell-to Customer No." = field("Account No."));

        }
    }
    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";
        GenJouTemp: Record "Gen. Journal Batch";
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        LastNo: Code[20];
        Salesorder: Record "Sales Header";

}
// Custom.Reset();
// IF Custom.FindLast() then begin
//     LastNo := Custom."Document No. Series";
//     Rec."Document No. Series" := IncStr(LastNo);
// end
// else
//     if Custom."Document No. Series" = '' then begin
//         GenLine.Reset();
//         GenLine.SetFilter("Journal Template Name", '%1', 'PAYMENT');
//         GenLine.SetFilter("Journal Batch Name", '%1', 'STOREPMT');
//         GenLine.SetFilter("Source Code", '%1', 'PAYMENTJNL');
//         If GenLine.FindLast() then begin
//             LastNo := GenLine."Document No.";
//             Rec."Document No. Series" := IncStr(LastNo);
//         end else begin
//             GenJouTemp.Reset();
//             GenJouTemp.SetFilter("Journal Template Name", '%1', 'PAYMENT');
//             GenJouTemp.SetFilter(Name, '%1', 'STOREPMT');
//             if GenJouTemp.FindFirst() then begin
//                 NoSeries.Get(GenJouTemp."No. Series");
//                 LastNo := NoSeriesMgt.GetLastNoUsed(GenJouTemp."No. Series");
//                 Rec."Document No. Series" := IncStr(LastNo);
//             END;
//         end
//     end;
