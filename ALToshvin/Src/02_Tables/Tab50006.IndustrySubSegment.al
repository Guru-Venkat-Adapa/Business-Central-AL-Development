table 50006 "Industry Sub-Segment"
{
    Caption = 'Industry Sub-Segment';
    DataClassification = ToBeClassified;
    LookupPageId = "Industry SubSegment";
    DrillDownPageId = "Industry SubSegment";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Indu Sub-Seg Description"; Text[100])
        {
            Caption = 'Industry Sub-Seg Description';
            DataClassification = CustomerContent;
        }
        field(3; Industry; Text[50])
        {
            Caption = 'Industry';
            DataClassification = CustomerContent;
            TableRelation = Industry;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "Indu Sub-Seg Description")
        {

        }
    }
    fieldgroups
    {
        fieldgroup(Brick; "Indu Sub-Seg Description")
        {
        }
        fieldgroup(DropDown; "Indu Sub-Seg Description")
        {
        }
    }
}
