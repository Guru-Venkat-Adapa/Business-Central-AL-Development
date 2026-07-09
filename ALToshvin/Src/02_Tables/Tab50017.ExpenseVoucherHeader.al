table 50017 "Expense Voucher Header"
{
    Caption = 'Expense Voucher Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Expense Creation Date"; Date)
        {
            Caption = 'Expense Creation Date';
        }
        field(3; "Employee Name"; Text[250])
        {
            Caption = 'Employee Name';
        }
        field(4; "Employee Designation"; Text[250])
        {
            Caption = 'Employee Designation';
        }
        field(5; Region; Text[50])
        {
            Caption = 'Region';
        }
        field(6; Department; Text[50])
        {
            Caption = 'Department';
        }

        field(7; "Expense Start Date"; Date)
        {
            Caption = 'Expense Start Date';
        }
        field(8; "Expense End Date"; Date)
        {
            Caption = 'Expense End Date';

        }
        field(9; Status; Enum "Voucher Status Toshvin App")
        {
            Caption = 'Status';

        }
        field(10; "Voucher Summary"; Text[2045])
        {
            Caption = 'Voucher Summary';

        }
        field(11; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
        }
        field(12; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(13; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
        }
        field(14; "General Voucher Created"; Boolean)
        {
            Caption = 'General Voucher Created';
        }
        field(15; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
        }
        field(16; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
        }
        field(17; "BC General Voucher No."; Code[20])
        {
            Caption = 'BC General Voucher No.';
        }
        field(18; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Expense Voucher Line".Amount where("Entry No." = field("Entry No.")));
        }
        field(19; "Raw JSON Input"; Blob)
        {
            Caption = 'Input Request';
            DataClassification = CustomerContent;
        }
        field(20; "Approver Id"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if Emp.Get(Rec."Approver Id") then begin
                    Rec."Approver Name" := Emp."First Name" + ' ' + Emp."Last Name";
                    Rec."Approver Email-Id" := Emp."E-Mail";
                    Rec."Approver Designation" := Emp."Job Title";
                end;
            end;
        }
        field(21; "Approver Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(22; "Approver Email-Id"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(23; "Approver Designation"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(24; "Draft Id"; Text[2048])
        {
            DataClassification = CustomerContent;
        }
        field(25; "Integer Status"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Reject Comments"; Text[1048])
        {
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(pk2; "Creation Date", "Creation Time")
        {

        }
    }
    procedure GetWebInputRequest(): Text
    var
        InStream: InStream;
        ResultText: Text;
    begin
        CalcFields("Raw JSON Input");

        if "Raw JSON Input".HasValue then begin
            "Raw JSON Input".CreateInStream(InStream, TEXTENCODING::UTF8);
            InStream.ReadText(ResultText);
            exit(ResultText);
        end;

        exit('');
    end;
}
