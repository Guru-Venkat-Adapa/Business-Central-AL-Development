table 50101 "bonus Header"
{
    DataClassification = ToBeClassified;
    Caption = 'Bonus';
    // DrillDownPageId="Bonus List";
    // LookupPageId="Bonus List";
    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
            trigger OnValidate()
            var
                BonusSetup: Record "Bonus Setup";
                NoSeriesManagement: Codeunit NoSeriesManagement;
            begin
                if "No." <> xRec."No." then begin
                    BonusSetup.Get();
                    BonusSetup.TestField("Bonus No.");
                    NoSeriesManagement.TestManual(BonusSetup."Bonus No.");
                end;
            end;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(3; "Sarting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Starting Date';
        }
        field(4; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Ending Date';
        }
        field(5; "Status"; Enum "Bonus Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
    }
    keys
    {
        key(Pk; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        BonusSetup: Record "Bonus Setup";
        NoseriesManagement: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then begin
            BonusSetup.Get();
            BonusSetup.TestField("Bonus No.");
            NoseriesManagement.InitSeries(BonusSetup."Bonus No.", BonusSetup."Bonus No.", WorkDate(), "No.", BonusSetup."Bonus No.");
        end;
    end;
}