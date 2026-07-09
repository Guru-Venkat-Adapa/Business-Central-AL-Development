table 50024 "TripGain Voucher Line"
{
    Caption = 'TripGain Voucher Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }

        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }

        field(3; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }

        field(4; Description; Text[150])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(5; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(6; "Comments"; Text[250])
        {
            Caption = 'Comments';
            DataClassification = CustomerContent;
        }
        field(7; "BC Journal Created"; Boolean)
        {
            Caption = 'Journal Created';
        }
        field(8; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
        }
        field(9; "TripGain ID"; Code[1028])
        {
            Caption = 'TripGain ID';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {

        key(PK; "Entry No.", "Line No.")
        {
            Clustered = true;
        }


    }
}
