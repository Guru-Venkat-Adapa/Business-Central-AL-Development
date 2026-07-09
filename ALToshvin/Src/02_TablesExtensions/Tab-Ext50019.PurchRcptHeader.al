namespace Toshvin.Toshvin;

using Microsoft.Purchases.History;

tableextension 50019 "Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
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
        field(50012; "Purchase Type"; Option)
        {
            Caption = 'Purchase Type';
            DataClassification = CustomerContent;
            OptionMembers = ,Domestic,Import,"Expense Order";
            Editable = false;
        }
        //TBC-499 -->
        field(50013; "Inco Terms"; Text[100])
        {
            Caption = 'Inco Terms';
            DataClassification = CustomerContent;
        }
        //TBC-499 <--
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



        // Warehouse Fields
        field(50108; "AWB No."; Code[20])
        {
            Caption = 'AWB No.';
            DataClassification = CustomerContent;
        }
        field(50109; "AWB Date"; Date)
        {
            Caption = 'AWB Date';
            DataClassification = CustomerContent;
        }
        field(50112; "Vendor Bill No."; Code[20])
        {
            Caption = 'Vendor Bill No.';
            DataClassification = CustomerContent;
        }
        field(50113; "Vendor Bill Date"; Date)
        {
            Caption = 'Vendor Bill Date';
            DataClassification = CustomerContent;
        }
        field(50122; "BL No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50123; "BL Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }
}
