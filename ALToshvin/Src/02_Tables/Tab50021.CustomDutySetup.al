table 50022 "Custom Duty Setup"
{
    Caption = 'Custom Duty Setup';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Custom Duty Setup";
    LookupPageId = "Custom Duty Setup";
    fields
    {
        field(1; "Group"; code[30])
        {
            Caption = 'Group';
            DataClassification = CustomerContent;
        }
        field(2; "Custom Duty Sucharge Perc."; Decimal)
        {
            Caption = 'Custom Duty+Sucharge %';
            DataClassification = CustomerContent;
        }
        field(3; "IGST Percentage"; Decimal)
        {
            Caption = 'IGST %';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Group")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; Group, "Custom Duty Sucharge Perc.", "IGST Percentage")
        {
        }
        fieldgroup(DropDown; Group, "Custom Duty Sucharge Perc.", "IGST Percentage")
        {
        }
    }
}
