table 50121 "Custom Data"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
            AutoIncrement = true;
        }
        field(2; FileName; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'File Name';
            Editable = false;
        }
        field(3; FileExtension; Text[500])
        {
            Caption = 'File Extension';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; Attachmentdate; Date)
        {
            Caption = 'Attachment Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; avaliable; Boolean)
        {
            Caption = 'Avaliable';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; Content; Blob)
        {
            Caption = 'Content';
            DataClassification = CustomerContent;
        }
        field(7; "Series"; Code[20])
        {
            Caption = 'Series';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Series <> xRec.Series then begin
                    BonusSetup.Get();
                    BonusSetup.TestField("Bonus No.");
                    NoSeries.TestManual(BonusSetup."Bonus No.");
                end;
            end;
        }
    }

    keys
    {
        key(pk; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec.Validate(Attachmentdate, DT2Date(CurrentDateTime));
        if Series = '' then begin
            BonusSetup.Get();
            BonusSetup.TestField("Bonus No.");
            NoSeries.InitSeries(BonusSetup."Bonus No.", BonusSetup."Bonus No.", WorkDate(), Series, BonusSetup."Bonus No.");
        end;
    end;

    procedure GetData(TableData: Record "Custom Data")
    begin
        Rec.Validate(Attachmentdate, DT2Date(CurrentDateTime));
        if Series = '' then begin
            BonusSetup.Get();
            BonusSetup.TestField("Bonus No.");
            if NoSeries.SelectSeries(BonusSetup."Bonus No.", BonusSetup."Bonus No.", Series) then begin
                BonusSetup.Get();
                BonusSetup.TestField("Bonus No.");
                NoSeries.SetSeries(Series);
            end;
        end;
    end;

    var
        BonusSetup: Record "Bonus Setup";
        NoSeries: Codeunit NoSeriesManagement;
}