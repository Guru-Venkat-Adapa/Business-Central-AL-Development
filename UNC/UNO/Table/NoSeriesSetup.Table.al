table 50100 NoSeriesSetup
{
    DataClassification = ToBeClassified;
    Caption = 'No. Series Setup for UNC';
    fields
    {
        field(1; "Primary key"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key';
        }
        field(2; "Fund No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(4; "Fund Transfer Line No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(5; "Send Email On IC Gen Journal"; Boolean)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Send email on successful post of IC General Journal';
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

