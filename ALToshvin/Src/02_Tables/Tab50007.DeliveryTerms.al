table 50007 "Delivery Terms"
{
    Caption = 'Delivery Terms';
    DataClassification = ToBeClassified;
    LookupPageId = "Delivery Terms Lists";
    DrillDownPageId = "Delivery Terms Lists";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Name"; Text[200])
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; Name)
        {
        }
        fieldgroup(DropDown; Name)
        {
        }
    }
}
