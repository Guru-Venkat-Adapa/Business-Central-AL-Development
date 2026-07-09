table 50008 "Freight Term"
{
    Caption = 'Freight Term';
    DataClassification = ToBeClassified;
    LookupPageId = "Freight Term Lists";
    DrillDownPageId = "Freight Term Lists";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "Name"; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Freight Term';
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
