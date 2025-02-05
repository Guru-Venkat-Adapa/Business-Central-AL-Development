table 50116 "City table"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; CityId; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'City Id';
        }
        field(2; CityName; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'City Name';
        }
        field(3; state; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'State';
            TableRelation = "State Table";
        }
    }

    keys
    {
        key(Key1; CityName)
        {
            Clustered = true;
        }
    }
}