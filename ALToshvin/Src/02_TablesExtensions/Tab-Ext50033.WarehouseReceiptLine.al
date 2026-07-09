tableextension 50033 "Warehouse Receipt Line" extends "Warehouse Receipt Line"
{
    fields
    {
        field(50000; "Insurance Charges"; Decimal)
        {
            Caption = 'Insurance Charges';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if (Rec."Insurance Charges" <> 0) and (Rec."Amount INR" <> 0) then
                    Rec."Insurance Charges" := (Rec."Amount INR" * Rec."Insurance Charges") / 100
                else
                    Rec."Insurance Charges" := 0;
                UpdateGrossAmount
            end;
        }
        field(50001; "Freight Charges"; Decimal)
        {
            Caption = 'Freight Charges';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Res: Record "Reservation Entry";
            begin
                UpdateGrossAmount
            end;
        }
        field(50002; "Misc Charges"; Decimal)
        {
            Caption = 'Misc Charges';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Res: Record "Reservation Entry";
            begin

                UpdateGrossAmount
            end;
        }
        field(50003; "Per Unit Rate INR"; Decimal)
        {
            Caption = 'Per Unit Rate INR';
            DataClassification = CustomerContent;
        }
        field(50004; "Amount INR"; Decimal)
        {
            Caption = 'Amount INR';
            DataClassification = CustomerContent;
        }
        field(50005; "Total Assesable value"; Decimal)
        {
            Caption = 'Total Assesable value';
            DataClassification = CustomerContent;
        }
        field(50006; "Gross Amount"; Decimal)
        {
            Caption = 'Gross Amount';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateDutyCalculation();
            end;

        }
        field(50007; "Custom Duty Percentage"; Decimal)
        {
            Caption = 'Custom Duty %';
            DataClassification = CustomerContent;
        }
        field(50008; "Custom Duty Amount"; Decimal)
        {
            Caption = 'Custom Duty Amount';
            DataClassification = CustomerContent;
        }
        field(50009; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
            begin
                if Rec."Exchange Rate" <> 0 then begin
                    Rec."Per Unit Rate INR" := Rec."Direct Unit Cost" * Rec."Exchange Rate";
                    if Rec."Line Amount" <> 0 then
                        Rec."Amount INR" := Rec."Line Amount" * Rec."Exchange Rate";
                end else begin
                    Rec."Per Unit Rate INR" := 0;
                    Rec."Amount INR" := 0;
                end;
            end;
        }
        field(50010; "IGST Percentage"; Decimal)
        {
            Caption = 'IGST %';
            DataClassification = CustomerContent;
        }
        field(50011; "IGST Amount"; Decimal)
        {
            Caption = 'IGST Amount';
            DataClassification = CustomerContent;
        }
        field(50012; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Per Unit Rate FC';
            DataClassification = CustomerContent;
        }
        field(50013; "Line Amount"; Decimal)
        {
            Caption = 'Amount FC';
            DataClassification = CustomerContent;
        }
        field(50014; "Principle"; Code[50])
        {
            Caption = 'Principle';
            DataClassification = CustomerContent;
        }
        field(50015; "HSN/SAC Code"; Code[10])
        {
            Caption = 'HSN/SAC Code';
            DataClassification = CustomerContent;
            TableRelation = "HSN/SAC".Code;
        }
        field(50016; "GST Group Code"; Code[30])
        {
            Caption = 'GST Group Code';
            DataClassification = CustomerContent;
            ValidateTableRelation = true;
            TableRelation = "Custom Duty Setup".Group;

            trigger OnValidate()
            begin
                UpdateDutyCalculation();
            end;
        }
        field(50017; "Gross Total"; Decimal)
        {
            Caption = 'Gross Total';
            DataClassification = CustomerContent;
        }
        field(50018; MExpiryDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        //TBC-979 -->
        field(50019; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = ToBeClassified;
        }
        //TBC-979 <--
    }
    local procedure UpdateGrossAmount()
    begin
        Rec."Gross Amount" := Rec."Amount INR" +
            Rec."Insurance Charges" +
            Rec."Freight Charges" +
            Rec."Misc Charges";
    end;

    local procedure UpdateDutyCalculation()
    var
        CustomDutySetup: Record "Custom Duty Setup";
    begin
        // Reset values
        Rec."Custom Duty Percentage" := 0;
        Rec."Custom Duty Amount" := 0;
        Rec."IGST Percentage" := 0;
        Rec."IGST Amount" := 0;
        Rec."Total Assesable value" := Rec."Gross Amount";
        Rec."Gross Total" := 0;

        if (Rec."GST Group Code" = '') then
            exit;

        if not CustomDutySetup.Get(Rec."GST Group Code") then
            exit;

        // Custom Duty
        Rec."Custom Duty Percentage" :=
            CustomDutySetup."Custom Duty Sucharge Perc.";

        if Rec."Custom Duty Percentage" <> 0 then
            Rec."Custom Duty Amount" :=
                (Rec."Gross Amount" * Rec."Custom Duty Percentage") / 100;

        // Total Assessable Value
        Rec."Total Assesable value" :=
            Rec."Gross Amount" + Rec."Custom Duty Amount";

        // IGST
        Rec."IGST Percentage" :=
            CustomDutySetup."IGST Percentage";

        if Rec."IGST Percentage" <> 0 then
            Rec."IGST Amount" :=
                (Rec."Total Assesable value" * Rec."IGST Percentage") / 100;

        Rec."Gross Total" := Rec."Total Assesable value" + Rec."IGST Amount";
    end;
}
