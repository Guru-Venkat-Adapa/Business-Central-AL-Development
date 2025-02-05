table 50119 "Top 10 Cus Query"
{
    DataClassification = CustomerContent;
    Caption = 'Top 10 Customer By Query';
    TableType = Temporary;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(3; "Location Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Code';
        }
        field(4; Contact; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact';
        }
        field(5; "Balance (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Balance (LCY)';
        }
        field(6; "Sales (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales (LCY)';
        }
        field(7; "Payments (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Payments (LCY)';
        }
    }

    keys
    {
        key(Pk; "No.")
        {
            Clustered = true;
        }
    }

}