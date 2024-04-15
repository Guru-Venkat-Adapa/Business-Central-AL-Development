table 50110 "Country Table"
{
    DataClassification = ToBeClassified;
    Caption = 'Country Table';
    fields
    {
        field(1; CountryId; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Country Id';
        }
        field(2; CountryName; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Country Name';
        }
    }
    keys
    {
        key(Key1; CountryName)
        {
            Clustered = true;
        }
    }
}