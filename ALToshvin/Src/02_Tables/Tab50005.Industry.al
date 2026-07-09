table 50005 Industry
{
    Caption = 'Industry';
    DataClassification = ToBeClassified;
    LookupPageId = "Industry Master";
    DrillDownPageId = "Industry Master";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Industry Description"; Text[100])
        {
            Caption = 'Industry Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Industry Description")
        {
            Clustered = true;
        }
    }
}
