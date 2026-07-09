table 50012 "No Series for Purchase"
{
    Caption = 'No Series for Purchase';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item Category Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Category";

        }
        field(2; "Ven Gen Bus Pos Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group";
        }
        field(3; "Purchase Order No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(4; "Posting No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(5; "Receiving No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Item Category Code", "Ven Gen Bus Pos Group")
        {
            Clustered = true;
        }
    }

}
