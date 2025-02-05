/// <summary>
/// TableExtension SCB 790 Sales Header (ID 50000) extends Record Sales Header //36.
/// </summary>
tableextension 50000 "SCB 790 Sales Header" extends "Sales Header" //36
{
    fields
    {
        field(6082664; "SCB Invoicing Frequency"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoicing Frequency';
            ObsoleteState = Pending;
            ObsoleteReason = 'Replaced with "SCB Invoicing Frequency DF" DateFormula field';
        }
        field(6082665; "SCB Next Invoicing Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Next Invoicing Date';
        }
        field(6082666; "SCB Old Next Invoicing Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Old Next Invoicing Date';
        }
        field(6082667; "SCB Sales Amount per Year"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."SCB Sales Amount per Year" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "SCB Ending Date" = FIELD(FILTER("SCB Date Filter 2")), "SCB Starting date" = FIELD(FILTER("SCB Date Filter 1"))));
            Editable = false;
            Caption = 'Sales Amount per Year';
        }
        field(6082668; "SCB Cost Amount per Year"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."SCB Cost Amount per Year" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "SCB Ending Date" = FIELD(FILTER("SCB Date Filter 2")), "SCB Starting date" = FIELD(FILTER("SCB Date Filter 1"))));
            Editable = false;
            Caption = 'Cost Amount per Year';

        }
        field(6082669; "SCB Profit Amount per Year"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."SCB Profit Amount per Year" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "SCB Ending Date" = FIELD(FILTER("SCB Date Filter 2")), "SCB Starting date" = FIELD(FILTER("SCB Date Filter 1"))));
            Editable = false;
            Caption = 'Profit Amount per Year';
        }
        field(6082670; "SCB Date Filter 1"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter 1';
        }
        field(6082671; "SCB Date Filter 2"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter 2';
        }
        field(6082672; "SCB Invoiced Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Cust. Ledger Entry"."Amount (LCY)" WHERE("External Document No." = FIELD("No.")));
            Editable = false;
            Caption = 'Invoiced Amount';

        }
        field(6082673; "SCB Next Action Date"; Date)
        {
            FieldClass = Flowfield;
            CalcFormula = min("Sales Line"."SCB Next Invoicing Date" where("Document Type" = field("Document Type"), "Document No." = field("No."), "SCB Next Invoicing Date" = filter(<> 0D)));
            Editable = false;
            Caption = 'Next Action Date';
        }
        field(6082790; "SCB Invoicing Frequency DF"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoicing Frequency';
        }
        field(6083562; "SCB Blanket Order Type"; enum "SCB 790 Blanket Order Type")
        {
            Editable = true;
            Caption = 'Blanket Order Type';
            DataClassification = CustomerContent;
        }
    }
}