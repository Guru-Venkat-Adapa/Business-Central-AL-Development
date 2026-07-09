table 50019 "Mode/Class Jrn"
{
    Caption = 'Mode/Class Jrn';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
}
