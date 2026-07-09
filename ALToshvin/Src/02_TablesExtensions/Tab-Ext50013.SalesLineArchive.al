namespace Toshvin.Toshvin;

using Microsoft.Sales.Archive;
using Microsoft.Inventory.Item;

tableextension 50013 "Sales Line Archive" extends "Sales Line Archive"
{
    fields
    {
        field(50001; "Principal"; Code[20])
        {
            Caption = 'Principal';
            DataClassification = ToBeClassified;
        }
        field(50002; "L-Spares Quotation"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'L-Spares Quotation';
        }
        field(50003; "Item Instrument No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Instrument No.';
        }
        field(50004; "Reordering Policy"; Enum "Reordering Policy")
        {
            DataClassification = CustomerContent;
            Caption = 'Reordering Policy';
        }
        field(50005; "Lead Time Calculation"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Lead Time Calculation';
        }
        field(50007; "SGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'SGST %';
        }
        field(50008; "CGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'CGST %';
        }
        field(50009; "IGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'IGST %';
        }
        field(50010; "SGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'SGST Amount';
        }
        field(50011; "CGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'CGST Amount';
        }
        field(50012; "IGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'IGST Amount';
        }
    }
}
