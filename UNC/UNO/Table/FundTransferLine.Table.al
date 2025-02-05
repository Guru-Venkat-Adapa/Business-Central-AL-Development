table 50102 "Fund Transfer Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(14; "Document Type"; Enum "Fund Transfer Doc Type")
        {
            //reference fundtransfer header no.
            Caption = 'Document Type';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(7; "Document No."; Code[20])
        {
            //reference fundtransfer header no.
            Caption = 'Document No';
            Editable = false;
            DataClassification = ToBeClassified;
            TableRelation = "Fund Transfer Header";
        }
        field(9; "No."; Code[20])
        {
            //Pk OF the fundtransfer line
            DataClassification = ToBeClassified;
        }
        field(3; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            // Editable = false;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = "Bank Account";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                FundTransHeader: Record "Fund Transfer Header";
            begin
                TestStatusOpen();
                Rec."Journal Template Name" := 'INTERCOMP';
                Rec."Journal Batch Name" := 'DEFAULT';
                Rec."Payment Type" := "Payment Type"::Payment;
                Rec."Account Type" := "Account Type"::"Bank Account";
                Rec."IC Account Type" := "IC Account Type"::"Bank Account";
                Rec.Status := Rec.Status::Open;
                Rec."Document Type" := Rec."Document Type"::Order;
                FundTransHeader.SetRange(No, Rec."Document No.");
                If FundTransHeader.FindFirst() then
                    Rec.Project := FundTransHeader.Project;
            end;
        }
        field(6; "Payment Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            // Editable = false;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }

        field(8; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }

        field(10; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = "IC Bank Account";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(11; "IC Account Type"; Enum "IC Journal Account Type")
        {
            DataClassification = ToBeClassified;
            // Editable = false;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(12; "IC Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = "IC Bank Account";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }

        field(13; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            // DecimalPlaces = 4;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        // field(14; FundTranFundNo; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(15; "Fund Tras No"; Code[20])
        // {
        //     TableRelation = "Fund Transfer Header";
        //     DataClassification = ToBeClassified;
        // }
        field(16; Project; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(17; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));

        }
        field(63; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(18; Status; Enum "Fund Status")
        {
            // Editable = false;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "No.", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        FundSetup: Record NoSeriesSetup;
        NoSeries: Record "No. Series";
        NoSeriesMag: Codeunit "No. Series";
    begin
        if Rec."No." = '' then begin
            if FundSetup.get() then
                FundSetup.TestField("Fund Transfer Line No.");
            if NoSeries.Get(FundSetup."Fund Transfer Line No.") then
                Rec."No." := NoSeriesMag.GetNextNo(NoSeries.Code);
        end;
    end;

    procedure TestStatusOpen()
    var
        Fund: Record "Fund Transfer Header";
    begin
        Fund.SetRange(No, Rec."No.");
        if Fund.FindFirst() then
            Fund.TestField(Status, Fund.Status::Open);
    end;
}