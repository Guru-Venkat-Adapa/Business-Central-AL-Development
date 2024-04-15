table 50109 "Subscription Text"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Language Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Language Code';
            TableRelation = Language;
            NotBlank = true;
        }
        field(2; "Subscription Text"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Subscription Text';
        }
        field(3; "Format Region"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Format Region';
            // TableRelation=Language Section"."Language Tag";
        }
    }

    keys
    {
        key(PK; "Language Code")
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