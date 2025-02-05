table 50109 "Demo Vendors"
{
    DataClassification = ToBeClassified;
    Caption = 'Demo Vendor';
    fields
    {
        field(1; "Id"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Id';
        }
        field(2; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
        }
        field(3; "Vendor Name"; Code[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Name';
        }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }
}