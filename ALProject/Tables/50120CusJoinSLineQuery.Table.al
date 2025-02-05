table 50120 "Cus Sale Line Join"
{
    DataClassification = CustomerContent;
    Caption = 'Customer Join Sales Line Table';
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
        field(3; "Sales (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales (LCY)';
        }
        field(4; Qty; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

}