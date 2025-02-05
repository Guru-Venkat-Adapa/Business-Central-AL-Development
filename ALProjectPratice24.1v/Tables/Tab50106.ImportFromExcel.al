table 50106 "Import From Excel"
{
    Caption = 'Import From Excel';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(3; Address; Text[250])
        {
            Caption = 'Address';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
