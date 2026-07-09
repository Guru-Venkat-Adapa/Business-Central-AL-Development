table 50009 "Gst Rate Percentage"
{
    Caption = 'Gst Rate %';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "GST Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'GST Group Code';
            TableRelation = "GST Group".Code;
            ValidateTableRelation = true;
        }
        field(3; "HSN/SAC"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "HSN/SAC".Code;
            Caption = 'HSN/SAC';
            ValidateTableRelation = true;
        }
        field(4; "From State"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = State.Code;
            ValidateTableRelation = true;
            Caption = 'From State';
        }
        field(5; "Location State Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = State.Code;
            ValidateTableRelation = true;
            Caption = 'Location State Code';
        }
        field(6; "Date From"; Date)
        {
            Caption = 'Date From';
            DataClassification = CustomerContent;
        }
        field(7; "SGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'SGST %';
        }
        field(8; "CGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'CGST %';
        }
        field(9; "IGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'IGST %';
        }
        field(10; "KFloodCess Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'KFloodCess %';
        }
        field(11; "Date To"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date To';
        }
        field(12; "POS Out Of India"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'POS Out Of India';
        }
        field(13; "POS as Vendor State"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'POS as Vendor State';
        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
