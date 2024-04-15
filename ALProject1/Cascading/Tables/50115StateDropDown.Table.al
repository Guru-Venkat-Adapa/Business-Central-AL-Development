table 50115 "State Table"
{
    DataClassification = ToBeClassified;
    Caption = 'State';
    fields
    {
        field(1; StateId; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'State Id';
        }
        field(2; StateName; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'State Name';
        }
        field(3; Country; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Country';
            TableRelation = "Country Table";
        }
    }

    keys
    {
        key(Key1; StateName)
        {
            Clustered = true;
        }
    }
}