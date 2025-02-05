table 50103 WeeklyReport
{
    Caption = 'WeeklyReport';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(2; "Document Type"; Text[30])
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(3; Day1; Decimal)
        {
            Caption = 'Day1';
            DataClassification = CustomerContent;
        }
        field(4; Day2; Decimal)
        {
            Caption = 'Day2';
            DataClassification = CustomerContent;
        }
        field(5; Day3; Decimal)
        {
            Caption = 'Day3';
            DataClassification = CustomerContent;
        }
        field(6; Day4; Decimal)
        {
            Caption = 'Day4';
            DataClassification = CustomerContent;
        }
        field(7; Day5; Decimal)
        {
            Caption = 'Day5';
            DataClassification = CustomerContent;
        }
        field(8; Day6; Decimal)
        {
            Caption = 'Day6';
            DataClassification = CustomerContent;
        }
        field(9; Day7; Decimal)
        {
            Caption = 'Day7';
            DataClassification = CustomerContent;
        }
        field(10; FirstDay; Date)
        {
            Caption = 'First Day';
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
