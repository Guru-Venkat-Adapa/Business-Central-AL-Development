table 50104 "Deleted Doc No. Archive"
{
    DataClassification = ToBeClassified;
    Caption = 'Deleted Document No. Archive';
    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No.';
        }
        // field(2; "Document Type"; Enum)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption='Document Type';
        // }
        field(3; "Deleted Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Deleted Date';
        }
        field(4; "Deleted Time"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Deleted Time';
        }
        field(5; "Deleted By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Deleted By';
        }
        field(6; "Table ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Table ID';
        }

    }

    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
    var
        line: Enum "Sales Line Type";
}