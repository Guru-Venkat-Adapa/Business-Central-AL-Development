table 50004 "Application Sub-Segment"
{
    Caption = 'Application Sub-Segment';
    DataClassification = ToBeClassified;
    LookupPageId = "Application Subsegement Master";
    DrillDownPageId = "Application Subsegement Master";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Application"; Text[100])
        {
            Caption = 'Application';
            DataClassification = CustomerContent;
            TableRelation = Application."Application Description";
        }
        field(3; "App Sub-Seg Description"; Text[100])
        {
            Caption = 'App Sub-Seg Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "App Sub-Seg Description")
        {

        }
    }
    fieldgroups
    {
        fieldgroup(Brick; "App Sub-Seg Description")
        {
        }
        fieldgroup(DropDown; "App Sub-Seg Description")
        {
        }
    }
}
