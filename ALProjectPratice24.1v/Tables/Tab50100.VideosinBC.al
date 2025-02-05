table 50100 "Videos in BC"
{
    Caption = 'Videos in BC';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; URL; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Last Modified Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Description")
        {
            Clustered = true;
        }
    }
    // trigger OnInsert()
    // begin
    //     if "No."="" then begin

    //     end;
    // end;
}
