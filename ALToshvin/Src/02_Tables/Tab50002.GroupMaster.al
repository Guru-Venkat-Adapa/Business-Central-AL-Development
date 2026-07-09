table 50002 "Group Master"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Group Master Lists";
    LookupPageId = "Group Master Lists";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Group Code"; Code[30])
        {
            Caption = 'Group Code';
            DataClassification = CustomerContent;
        }
        field(3; "Group Description"; Text[100])
        {
            Caption = 'Group Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Group Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; "Group Code", "Group Description")
        {
        }
        fieldgroup(DropDown; "Group Code", "Group Description")
        {
        }
    }
}
//NavSoft HG 11/04/2025 <---------
