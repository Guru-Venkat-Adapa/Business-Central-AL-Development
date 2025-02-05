table 50123 "Car Model"
{
    DataClassification = CustomerContent;
    Caption = 'Car Model';
    fields
    {
        field(1; name; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(2; description; text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; brandid; Guid)
        {
            TableRelation = "Car Brand".SystemId;
            Caption = 'Brand Id';
            DataClassification = CustomerContent;
        }
        field(4; power; Integer)
        {
            Caption = 'Power (cc)';
            DataClassification = CustomerContent;
        }
        field(5; fueltype; Enum "Fuel Type")
        {
            Caption = 'Fuel Type';
        }
    }
    keys
    {
        key(Pk; name, brandid)
        {
            Clustered = true;
        }
    }
}