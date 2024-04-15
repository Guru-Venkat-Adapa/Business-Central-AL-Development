table 50107 "Subscription Config Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Primary Key';
        }
        field(2; "Posted Subscription Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Posted Subscription Nos.';
            TableRelation = "No. Series".Code;
        }
        field(3; "Subscription Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Subscription Nos.';
            TableRelation = "No. Series".Code;
        }
        field(4; "End Date First Period Method"; Enum "SCB 790 ED FP CM")
        {
            DataClassification = CustomerContent;
            Caption = 'End Date First Period Calcuation Method';
        }
        field(5; "Sales Days per Month"; Enum "SCB 790 Sales Days per Month")
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Days per Month';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}