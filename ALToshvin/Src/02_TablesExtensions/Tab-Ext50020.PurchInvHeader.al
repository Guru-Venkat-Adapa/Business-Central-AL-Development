namespace Toshvin.Toshvin;

using Microsoft.Purchases.History;

tableextension 50020 "Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(50002; "Purchase Order Type"; Text[100])
        {
            Caption = 'Purchase Order Type';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Sales Type"; Text[10])
        {
            Caption = 'Sales Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50005; "Folio No."; Code[100])
        {
            Caption = 'Folio No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50007; "Delivery Terms"; Text[50])
        {
            Caption = 'Delivery Terms';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50008; "Supplier Quote No."; Text[50])
        {
            Caption = 'Supplier Quote No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50009; "Supplier Quote Date"; Date)
        {
            Caption = 'Supplier Quote Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50010; Warranty; Text[100])
        {
            Caption = 'Warranty';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50011; "Payment Term Details"; Text[1048])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Term Details';
        }
        field(50012; "Purchase Type"; Option)
        {
            Caption = 'Purchase Type';
            DataClassification = CustomerContent;
            OptionMembers = ,Domestic,Import,"Expense Order";
            Editable = false;
        }
        field(50013; "Inco Terms"; Text[100])
        {
            Caption = 'Inco Terms';
            DataClassification = CustomerContent;
        }
        field(50014; "Invoice Discount Perc"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Discount %';
        }
        field(50015; "Custom Freight Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Custom Freight Amount';
        }
        field(50016; "Custom Insurance Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Custom Insurance Amount';
        }
        field(50017; "Custom Assigned User ID"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assigned User ID';
        }
        field(50019; "Port Code (Imports)"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Port Code (Imports)';
        }
        field(50020; "Reference Date (Import)"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Reference Date (Import)';
        }
        //TBC-1060 --->
        field(50021; "Vendor Invoice Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        //TBC-1060 <----

        //TBC-1062 --->
        field(50022; "Custom Freight Amount INR"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Custom Freight Amount INR';
        }
        field(50023; "Custom Insurance Amount INR"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Custom Insurance Amount INR';
        }
        //TBC-1062 <---
    }
    var

}
