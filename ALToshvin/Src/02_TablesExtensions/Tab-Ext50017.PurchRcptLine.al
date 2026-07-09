namespace Toshvin.Toshvin;

using Microsoft.Purchases.History;

tableextension 50017 "Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50000; "SGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'SGST %';


        }
        field(50001; "CGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'CGST %';


        }
        field(50002; "IGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'IGST %';


        }
        field(50003; "SGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'SGST Amount';
        }
        field(50004; "CGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'CGST Amount';
        }
        field(50005; "IGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'IGST Amount';
        }
        field(50006; "Total GST Amount"; Decimal)
        {
            Caption = 'Total GST Amount';
            Editable = false;
        }
        field(50007; "Total Amount Excl. GST"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Amount Excl. GST';
        }
        field(50008; "Posted Warehouse Rec No"; Code[20])
        {
            Caption = 'Posted Warehouse Rec No';
            DataClassification = CustomerContent;
        }
        field(50018; MExpiryDate; Date)
        {
            DataClassification = ToBeClassified;
        }

    }
}
