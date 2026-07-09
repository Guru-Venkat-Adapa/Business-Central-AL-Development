table 50023 "TripGain Voucher Header"
{
    Caption = 'TripGain Voucher Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "External Document No."; Code[35])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Currency Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Payment Method"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Input JSON"; Blob)
        {
            SubType = Memo;
            DataClassification = CustomerContent;
        }
        field(8; "Status"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(9; "BC Journal Completed"; Boolean)
        {
            Caption = 'Journal Completed';
        }
        field(10; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
        }
        field(11; "TripGain ID"; Code[1028])
        {
            Caption = 'TripGain ID';
            DataClassification = SystemMetadata;
        }
        field(12; "G/L Posted"; Boolean)
        {
            Caption = 'Posted';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
