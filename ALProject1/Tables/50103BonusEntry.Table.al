table 50103 "Bonus Entry"
{
    DataClassification = ToBeClassified;
    Caption='Bonus Entry';
    fields{
        field(1;"Entry No.";Integer)
        {
            DataClassification=CustomerContent;
            Caption='Entry No.';
            Editable=false;
        }
        field(2;"Bonus No.";Code[20])
        {
            DataClassification=CustomerContent;
            Caption='Bonus No.';
            TableRelation="bonus Header";
            Editable=false;
        }
        field(3;"Documnet No.";Code[20])
        {
            DataClassification=CustomerContent;
            Caption='Document No.';
            TableRelation="Sales Invoice Header";
            Editable=false;
        }
        field(4;"Item No.";Code[20])
        {
            DataClassification=CustomerContent;
            Caption='Item No.';
            TableRelation=Item;
            Editable=false;
        }
        field(5;"Posting Date";Date)
        {
            DataClassification=CustomerContent;
            Caption='Posting date';
            Editable=false;
        }
        field(6;"Bonus Amount";Decimal)
        {
            DataClassification=CustomerContent;
            Caption='Bonus Amount';
            Editable=false;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    // var
    //     myInt: Integer;

    // trigger OnInsert()
    // begin

    // end;
    // trigger OnModify()
    // begin

    // end;
    // trigger OnDelete()
    // begin

    // end;
    // trigger OnRename()
    // begin

    // end;
}
