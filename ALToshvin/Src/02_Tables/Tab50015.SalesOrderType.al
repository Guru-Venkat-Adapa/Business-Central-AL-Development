table 50015 "Sales Order Type"
{
    Caption = 'Sales Order Type';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }

        field(2; "Sales Order Type"; Text[100])
        {
            Caption = 'Sales Order Type';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
