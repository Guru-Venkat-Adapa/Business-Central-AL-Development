table 50200 "Purch Order Payment Details"
{
    Caption = 'Purch oRder Payment Details';
    DataClassification = ToBeClassified;

    fields
    {
        // field(1; "Document Type"; Enum "Purchase Document Type")
        // {
        //     Caption = 'Document Type';
        // }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            // TableRelation = "Purchase Header"."No." where("Document Type" = field("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Payment Type"; Code[20])
        {
            Caption = 'Payment Type';
            TableRelation = "Payment Method";
            DataClassification = CustomerContent;
        }
        field(6; "Amount AUD"; Decimal)
        {
            Caption = 'Amount AUD';
            DataClassification = CustomerContent;
        }
        field(7; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(8; PaymentComments; Text[500])
        {
            Caption = 'Comments';
            DataClassification = CustomerContent;
        }
        field(9; "Recounclie Date"; Date)
        {
            Caption = 'Recounclie Date';
            DataClassification = CustomerContent;
        }
        field(10; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
