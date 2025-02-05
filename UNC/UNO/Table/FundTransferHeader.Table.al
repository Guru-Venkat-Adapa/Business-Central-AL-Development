table 50101 "Fund Transfer Header"
{
    // DataClassification = ToBeClassified;
    DataCaptionFields = No, FromCompany, ToCompany;
    Caption = 'Fund Transfer';
    DrillDownPageId = "Fund Transfer";


    fields
    {
        field(1; "Document Type"; Enum "Fund Transfer Doc Type")
        {
            DataClassification = ToBeClassified;
        }
        field(2; No; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; FromCompany; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'From Company';
            TableRelation = Company.Name;
            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                // CheckStatus();
                CompanyInfo.ChangeCompany(Rec.FromCompany);
                If CompanyInfo.FindFirst() then begin
                    Rec.Validate(FromCompAdd, CompanyInfo.Address);
                    Rec.Validate(FromCompAdd2, CompanyInfo."Address 2");
                    Rec.Validate(FromCompCity, CompanyInfo.City);
                    Rec.Validate(FromCompPostCode, CompanyInfo."Post Code");
                    Rec.Validate(FromCompCount, CompanyInfo."Country/Region Code");
                    Rec.Validate(FromCompPhNo, CompanyInfo."Phone No.");
                    Rec.Validate(FromCompEmail, CompanyInfo."E-Mail");

                end;
            end;
        }
        field(4; ToCompany; text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'To Company';
            TableRelation = Company.Name;
            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                // CheckStatus();
                CompanyInfo.ChangeCompany(ToCompany);
                If CompanyInfo.FindFirst() then begin
                    Rec.Validate(ToCompAdd, CompanyInfo.Address);
                    Rec.Validate(ToCompAdd2, CompanyInfo."Address 2");
                    Rec.Validate(ToCompCity, CompanyInfo.City);
                    Rec.Validate(ToCompPostCode, CompanyInfo."Post Code");
                    Rec.Validate(ToCompCount, CompanyInfo."Country/Region Code");
                    Rec.Validate(ToCompPhNo, CompanyInfo."Phone No.");
                    Rec.Validate(ToCompEmail, CompanyInfo."E-Mail");

                end;
            end;
        }
        field(5; Currency; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Code';
            TableRelation = Currency;
        }

        field(7; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Status; enum "Fund Document Status")
        {
            DataClassification = ToBeClassified;
        }
        field(13; Description; text[250])
        {
            DataClassification = ToBeClassified;
            // trigger OnValidate()
            // begin
            //     IF Rec.No <> '' then
            //         CheckStatus();
            // end;
        }
        field(14; TotalFunds; Decimal)
        {
            Editable = false;
            CalcFormula = sum("Fund Transfer Line".Amount where("Document No." = field(No)));
            FieldClass = FlowField;
            //AutoFormatExpression = Rec."Currency Code";
            // AutoFormatType = 1;

        }
        field(15; Project; Code[20])
        {
            DataClassification = ToBeClassified;
            // trigger OnValidate()
            // begin
            //     CheckStatus();
            // end;
        }
        field(16; FromCompAdd; Text[100]) { }
        field(17; FromCompAdd2; Text[50]) { }
        field(18; FromCompCity; Text[50]) { }
        field(19; FromCompPostCode; Code[30]) { }
        field(20; FromCompCount; Code[20]) { }
        field(21; FromCompPhNo; Text[30]) { }
        field(22; FromCompEmail; Text[80]) { }
        field(23; ToCompAdd; Text[100]) { }
        field(24; ToCompAdd2; Text[50]) { }
        field(25; ToCompCity; Text[50]) { }
        field(26; ToCompPostCode; Code[30]) { }
        field(27; ToCompCount; Code[20]) { }
        field(28; ToCompPhNo; Text[30]) { }
        field(29; ToCompEmail; Text[80]) { }
        field(30; Note; Blob)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }

    // fieldgroups
    // {
    //     fieldgroup(DropDown; No, TotalFunds)
    //     {

    //     }

    //     fieldgroup(bricks; No, TotalFunds)
    //     {

    //     }

    // }
    procedure SetWorkDescription(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Note);
        Note.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify();
    end;

    procedure GetWorkDescription() WorkDescription: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields(Note);
        Note.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName(Note)));
    end;

    trigger OnInsert()
    var
        SalesSetup: Record NoSeriesSetup;
        NoSeries: Record "No. Series";
        NoSeriesMag: Codeunit "No. Series";
    begin
        if Rec.No = '' then begin
            if SalesSetup.get() then
                SalesSetup.TestField("Fund No.");
            if NoSeries.Get(SalesSetup."Fund No.") then
                Rec.No := NoSeriesMag.GetNextNo(NoSeries.Code);
        end;
        Rec.Status := Rec.Status::Open;
        Rec."Document Date" := Today();
    end;

    // procedure CheckStatus()
    // begin
    //     TestField(Status, Status::Open);
    // end;
}