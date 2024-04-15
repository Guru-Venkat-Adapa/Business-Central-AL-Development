table 50108 "SCB Item Subscription Text"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            TableRelation = Item;
            NotBlank = true;
        }
        field(2; "Language Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Language Code';
            TableRelation = Language;
            NotBlank = true;
        }
        field(3; "Subscription Text"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Subscription Text';
        }
        field(4; "Format Region"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Format Region';
            // TableRelation="Language Selection"."Language Tag";
        }
    }

    keys
    {
        key(PK; "Item No.", "Language Code")
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