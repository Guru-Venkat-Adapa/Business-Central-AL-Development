table 50011 "No Series for Sales"
{
    Caption = 'No Series for Sales';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sales Order Type"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Posting No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(3; "Shipping No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "Sales Order Type")
        {
            Clustered = true;
        }
    }

}
