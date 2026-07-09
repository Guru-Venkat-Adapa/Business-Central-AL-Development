table 50001 "Integration Logs"
{
    Caption = 'Integration Logs';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "Web Service Name"; Text[100])
        {
            Caption = 'Web Service Name';
            DataClassification = CustomerContent;
        }
        field(3; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(4; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
            DataClassification = CustomerContent;
        }
        field(5; "User Id"; Code[50])
        {
            Caption = 'User Id';
            DataClassification = CustomerContent;
        }
        field(6; "Input Request"; Blob)
        {
            Caption = 'Input Request';
            DataClassification = CustomerContent;
        }
        field(7; "Output Request"; Text[2048])
        {
            Caption = 'Output Request';
            DataClassification = CustomerContent;
        }
        field(8; "Entry Type"; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    procedure InsertInputRequest(InputRequestValue: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Input Request");
        Rec."Input Request".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(InputRequestValue);
        Modify();
    end;

    procedure ViewInputRequest(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Input Request");
        "Input Request".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Input Request")));
    end;
}
