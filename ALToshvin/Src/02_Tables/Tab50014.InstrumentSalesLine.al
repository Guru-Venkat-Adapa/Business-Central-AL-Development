table 50014 "Instrument Sales Line"
{
    Caption = 'Instrument Sales Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = CustomerContent;
        }
        field(2; "CRM No."; Code[50])
        {
            Caption = 'CRM No.';
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(4; "Part Number"; Code[20])
        {
            Caption = 'Part Number';
            DataClassification = CustomerContent;


            trigger OnValidate()
            var
                Items: Record Item;
            begin
                if Items.Get(Rec."Part Number") then
                    Rec.Description := Items.Description;
            end;
        }
        field(5; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(6; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
        }
        field(7; "Discount"; Decimal)
        {
            Caption = 'Discount';
            DataClassification = CustomerContent;
        }
        field(8; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(9; "Type"; Enum "Sales Line Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(10; "SGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'SGST %';
        }
        field(11; "CGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'CGST %';
        }
        field(12; "IGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'IGST %';
        }
        field(13; "SGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'SGST Amount';
        }
        field(14; "CGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'CGST Amount';
        }
        field(15; "IGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'IGST Amount';
        }
        field(16; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
        }
        field(17; "FOC"; Boolean)
        {
            Caption = 'FOC';
            DataClassification = CustomerContent;
        }
        field(18; "Special Order"; Boolean)
        {
            Caption = 'Special Order';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "CRM No.", "Line No.") { Clustered = true; }
    }
}
