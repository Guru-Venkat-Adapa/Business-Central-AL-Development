namespace Toshvin.Toshvin;

using Microsoft.Sales.History;
using Microsoft.Inventory.Item;

tableextension 50012 "Sales Invoice Line" extends "Sales Invoice Line"
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
        field(50100; "Batch/Serial Number"; Code[50])
        {
            Caption = 'Batch/Serial Number';
            DataClassification = CustomerContent;
        }
        field(50101; "CMC/AMC Start Date"; Date)
        {
            Caption = 'CMC/AMC Start Date';
            DataClassification = CustomerContent;
        }
        field(50102; "CMC/AMC End Date"; Date)
        {
            Caption = 'CMC/AMC End Date';
            DataClassification = CustomerContent;
        }
        field(50103; "Item by Toshvin"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Instrument"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50105; "RDC No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50106; "RDC Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50108; "Inst. Model"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50109; "Inst SR No."; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50110; "Installation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50112; "MOQ"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'MOQ';
        }
        field(50113; "Non MOQ"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Non MOQ';
        }
        field(50023; "MOQ Quantity"; Decimal)
        {
            Caption = 'MOQ';
            DecimalPlaces = 0 : 5;
        }
        field(50027; "Warranty/Service Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50028; "Special Order Purchase No."; Code[20])
        {
            Caption = 'Special Order Purchase No.';
            DataClassification = CustomerContent;
        }
        field(50029; "Special Order Purch. Line No."; Integer)
        {
            Caption = 'Special Order Purch. Line No.';
            DataClassification = CustomerContent;
        }
        field(50030; "Negotiated Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50031; "CN Other Charges"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "Commission Note Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        //TBC-823 --->
        field(50033; "Remark"; Text[1048])
        {
            DataClassification = CustomerContent;
            Caption = 'Remark';
        }
        //TBC-823 <---
    }
}
