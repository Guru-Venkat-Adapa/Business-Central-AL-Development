table 50021 "Service Description"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Service Description";
    LookupPageId = "Service Description";
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; Code, Description)
        {
        }
        fieldgroup(DropDown; Code, Description)
        {
        }
    }
}
