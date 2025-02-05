table 50100 "Weekly Worksheet"
{
    Caption = 'Weekly Worksheet';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(2; Day1; Integer)
        {
            Caption = 'Day1';
            DataClassification = CustomerContent;
        }
        field(3; Day2; Integer)
        {
            Caption = 'Day2';
            DataClassification = CustomerContent;
        }
        field(4; Day3; Integer)
        {
            Caption = 'Day3';
            DataClassification = CustomerContent;
        }
        field(5; Day4; Integer)
        {
            Caption = 'Day4';
            DataClassification = CustomerContent;
        }
        field(6; Day5; Integer)
        {
            Caption = 'Day5';
            DataClassification = CustomerContent;
        }
        field(7; Day6; Integer)
        {
            Caption = 'Day6';
            DataClassification = CustomerContent;
        }
        field(8; Day7; Integer)
        {
            Caption = 'Day7';
            DataClassification = CustomerContent;
        }
        field(9; "Text Content"; Text[250])
        {
            Caption = 'Text Content';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}
