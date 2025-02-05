table 50201 TestApproval
{
    Caption = 'TestApproval';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Document; Code[20])
        {
            Caption = 'Document';
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; Status; Enum "Document Status")
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Document)
        {
            Clustered = true;
        }
    }
}
