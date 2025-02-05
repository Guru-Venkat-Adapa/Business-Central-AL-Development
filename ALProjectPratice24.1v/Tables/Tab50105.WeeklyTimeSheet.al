table 50105 WeeklyTimeSheet
{
    Caption = 'WeeklyTimeSheet';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; WeekStartDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; WeekEndDate; Date)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "code")
        {
            Clustered = true;
        }
    }
}
