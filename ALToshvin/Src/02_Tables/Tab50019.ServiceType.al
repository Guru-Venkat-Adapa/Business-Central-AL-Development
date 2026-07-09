table 50020 ServiceType
{
    Caption = 'Service Type';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Service Type";
    LookupPageId = "Service Type";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Service Name"; Text[250])
        {
            Caption = 'Service Name';
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
        fieldgroup(Brick; Code, "Service Name")
        {
        }
        fieldgroup(DropDown; Code, "Service Name")
        {
        }
    }

}
