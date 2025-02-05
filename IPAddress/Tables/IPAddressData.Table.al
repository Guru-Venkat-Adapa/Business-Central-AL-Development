table 50200 "IP Address Data"
{
    Caption = 'IP Address Data';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Text[20])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(2; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            DataClassification = CustomerContent;
        }
        field(3; "IP Address"; Text[20])
        {
            Caption = 'IP Address';
            DataClassification = CustomerContent;
        }
        field(4; "Device Name"; Text[50])
        {
            Caption = 'Device Name';
            DataClassification = CustomerContent;
        }
        field(5; "Created Date & Time"; DateTime)
        {
            Caption = 'Created Date & Time';
            DataClassification = CustomerContent;
        }
        field(6; LineNo; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "User ID", "User Security ID", LineNo)
        {
            Clustered = true;
        }
    }
    // trigger OnInsert()
    // begin
    //     // if Rec."IP Address"='' then
    // end;
}
