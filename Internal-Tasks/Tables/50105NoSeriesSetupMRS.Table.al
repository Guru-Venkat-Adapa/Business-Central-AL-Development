table 50105 "No. Series Setup MRS Header"
{
    DataClassification = ToBeClassified;
    Caption = 'No. Series Setup for MRS Header';
    fields
    {
        field(1; "Primary key"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key';
        }
        field(2; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';
            TableRelation = "No. Series".Code;
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