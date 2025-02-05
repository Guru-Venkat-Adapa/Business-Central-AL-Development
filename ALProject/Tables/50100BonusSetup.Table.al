table 50100 "Bonus Setup"
{
    DataClassification = ToBeClassified;
    Caption='Bonus Setup';
    fields
    {
        field(1;"Primary key"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption='Primary Key';
        }
        field(2;"Bonus No.";Code[20])
        {
            DataClassification=CustomerContent;
            Caption='Bonus No.';
            TableRelation= "No. Series";
        }
    }

    keys
    {
        key(Pk; "Primary key")
        {
            Clustered = true;
        }
    }

}