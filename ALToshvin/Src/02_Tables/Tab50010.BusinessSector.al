table 50010 "Business Sector"
{
    Caption = 'Business Sector';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Description")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; Description)
        {

        }
        fieldgroup(DropDown; Description)
        {

        }
    }
}
