table 50122 "Car Brand"
{
    DataClassification = CustomerContent;
    Caption = 'Car Brand';

    fields
    {
        field(1; Name; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; country; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Country';
        }
    }

    keys
    {
        key(Pk; Name)
        {
            Clustered = true;
        }
    }
}