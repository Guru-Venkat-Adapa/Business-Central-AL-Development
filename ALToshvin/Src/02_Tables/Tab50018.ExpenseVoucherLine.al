table 50018 "Expense Voucher Line"
{
    Caption = 'Expense Voucher Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Expense Type"; Text[20])
        {
            Caption = 'Expense Type';
        }
        field(4; "Date of Expense"; Date)
        {
            Caption = 'Date of Expense';
        }
        field(5; "Account Name"; Text[100])
        {
            Caption = 'Account Name';
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
        }

        field(7; Comments; Text[1045])
        {
            Caption = 'Narration';
        }
        field(8; "From Place"; Text[250])
        {
            Caption = 'From Place';
        }
        field(9; "To Place"; Text[250])
        {
            Caption = 'To Place';
        }
        field(10; "No. of Days"; Integer)
        {
            Caption = 'No. of Days';
        }
        field(11; "Dist. in Kms"; Decimal)
        {
            Caption = 'Dist. in Kms';
        }
        field(12; "Per Km Rate"; Decimal)
        {
            Caption = 'Per Km Rate';
            TableRelation = "Rate Per KM";
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';

            trigger OnValidate()
            var
                ChartOfAcc: Record "G/L Account";
            begin
                if ChartOfAcc.Get(Rec."Account No.") then
                    Rec."Account Name" := ChartOfAcc.Name;
            end;
        }
        field(14; "Status"; Text[50])
        {
            Caption = 'Status';
        }
        field(15; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
        }
        field(16; "BC General Voucher Voucher No."; Code[20])
        {
            Caption = 'BC General Voucher Voucher No.';
        }
        field(20; "Departure Date"; Date)
        {
            Caption = 'Departure Date';
        }
        field(21; "Arrival Date"; Date)
        {
            Caption = 'Arrival Date';
        }
        field(22; "Mode/Class Jrn"; Text[100])
        {
            Caption = 'Mode/Class Jrn';
            TableRelation = "Mode/Class Jrn".Name;
        }
        field(23; "Per Rate Km Name"; Code[30])
        {
            Caption = 'Per Rate Km Name';
        }
        field(24; "Approver Comment"; Text[1048])
        {
            Caption = 'Approver Comment';
        }
        field(25; "Distance"; Integer)
        {
            Caption = 'Distance';
        }
        field(26; "Departure Date Time"; DateTime)
        {
            Caption = 'Departure Date Time';
        }
        field(27; "Arrival Date Time"; DateTime)
        {
            Caption = 'Arrival Date Time';
        }
        field(28; "Departure DateTime"; Text[30])
        {
            Caption = 'Departure Date Time';
        }
        field(29; "Arrival DateTime"; Text[30])
        {
            Caption = 'Arrival Date Time';
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
