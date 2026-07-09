table 50003 Application
{
    Caption = 'Application';
    DataClassification = ToBeClassified;
    LookupPageId = "Application Master";
    DrillDownPageId = "Application Master";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Application Description"; Text[100])
        {
            Caption = 'Application Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.", "Application Description")
        {
            Clustered = true;
        }
        key(Key1; "Application Description")
        {
            Clustered = false;
        }

    }
    fieldgroups
    {
        fieldgroup(Brick; "Application Description")
        {
        }
        fieldgroup(DropDown; "Application Description")
        {
        }
    }
}
