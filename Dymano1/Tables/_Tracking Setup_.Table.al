table 50100 "Tracking Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Guid)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Mainfrieght URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Mainfrieght API Key"; Text[250])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(4; "TNT URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "TNT API Key"; Text[250])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(6; "AusPost URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "AusPost API Key"; Text[250])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(8; "Send Delevery Update"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; PrimaryKey)
        {
            Clustered = true;
        }
    }
}
