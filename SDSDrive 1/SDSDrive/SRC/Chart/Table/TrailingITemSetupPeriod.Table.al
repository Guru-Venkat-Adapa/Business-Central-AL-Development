table 60145 "Trailing item Setup Period"
{
    Caption = 'Trailing Job Setup';

    fields
    {
        field(1; "User ID"; Text[132])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(2; "Period Length"; Option)
        {
            Caption = 'Period Length';
            OptionCaption = 'Day,Week,Month,Quarter,Year';
            OptionMembers = Day,Week,Month,Quarter,Year;
        }
        field(3; "Company Name"; Text[132])
        {

        }
        field(5; "Value to Calculate"; Option)
        {
            Caption = 'Value to Calculate';
            OptionCaption = 'Amount Excl. VAT,No. of Orders';
            OptionMembers = "Amount Excl. VAT","No. of Orders";
        }
        field(6; "Chart Type"; enum "Business Chart Type")
        {
            Caption = 'Chart Type';

        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(7; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(8; filtertype; Text[100])
        {

        }
    }

    keys
    {
        key(Key1; "User ID", "Company Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure SetPeriodLength(PeriodLength: Option)
    begin
        "Period Length" := PeriodLength;
        Modify();
    end;

    procedure SetValueToCalcuate(ValueToCalc: Integer)
    begin
        "Value to Calculate" := ValueToCalc;
        Modify();
    end;

    procedure SetChartType(ChartType: Enum "Business Chart Type")
    begin
        Rec.SetRange("User ID", Database.UserId);
        Rec.SetRange("Company Name", Database.CompanyName);
        if Rec.FindSet() then begin
            Rec."Chart Type" := ChartType;
            Rec.Modify(true);
        end;

    end;

    procedure SetfilterType(Type: Text)
    begin
        Rec.SetRange("User ID", Database.UserId);
        Rec.SetRange("Company Name", Database.CompanyName);
        if Rec.FindSet() then begin
            Rec.filtertype := Format(Type);
            Rec.Modify(true);
        end;
    end;
}

