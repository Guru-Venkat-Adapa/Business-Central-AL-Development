table 50106 "Subscription Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "SCB Primary Key"; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Primary Key';
            Editable = false;
        }
        field(2; "SCB Posted Subscription Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
            Caption = 'Posted Subscription Nos.';
            trigger OnValidate()
            begin
                // NoSRelPostedSubNoSHandle(SalesSetup."Posted Invoice Nos.");
            end;
        }
        field(3; "SCB Calc End First Period"; Enum "SCB 790 ED FP CM")
        {
            DataClassification = CustomerContent;
            Caption = 'Calculated End First Period';
        }
        field(4; "SCB Sales Days per Month"; Enum "SCB 790 Sales Days per Month")
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Days per Month';

        }
        field(5; "Subscription No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Subscription Nos.';
            TableRelation = "No. Series".Code;
            trigger OnValidate()
            begin
                // NoSRelSubNoSHandle(SalesSetup."Blanket Order Nos.");
            end;
        }
        field(6; "Default Subscr Text Languages"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'SCB Subscriotion Text';
            // TableRelation="SCB Item Subscription Text";
        }

    }

    keys
    {
        key(PK; "SCB Primary Key")
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