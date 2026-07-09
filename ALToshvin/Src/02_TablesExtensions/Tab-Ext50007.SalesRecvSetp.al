tableextension 50007 SalesRecvSetp extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Spares Order Nos. Series"; Code[20])
        {
            Caption = 'Spares Order Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "Toshvin Expense Link"; Text[1048])
        {
            Caption = 'Toshvin Expense Link';
            DataClassification = CustomerContent;
        }
        field(50002; "Expense Voucher Email"; Boolean)
        {
            Caption = 'Expense Voucher Email Notification';
            DataClassification = ToBeClassified;
            InitValue = false;
        }
        field(50100; "ORC Order Nos. Series"; Code[20])
        {
            Caption = 'ORC Order Nos. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        //TBC-934 -->
        field(50003; "Old LUT No."; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(50004; "New LUT No."; Text[80])
        {
            DataClassification = CustomerContent;
        }
        //TBC-934 <--

    }
}
