table 50100 "IP Address Data"
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
        field(8; "Start"; Boolean)
        {


        }
    }
    keys
    {
        key(PK; "User ID", LineNo)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        Users: Record User;
    begin
        if Rec."User ID" <> '' then begin
            Users.SetRange("User Name", Rec."User ID");
            IF Users.FindFirst() then
                Rec."User Security ID" := Users."User Security ID";
        end;
    end;
}
