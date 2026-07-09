tableextension 50028 "Posted Whse Receipt Header Ext" extends "Posted Whse. Receipt Header"
{
    fields
    {
        field(50100; "Sales Type"; Enum "Transfer Order Sales Type")
        {
            Caption = 'Sales Type';
            DataClassification = ToBeClassified;
        }
        field(50101; "Requisition Purpose"; Text[100])
        {
            Caption = 'Requisition Purpose';
            DataClassification = CustomerContent;
        }
        field(50102; "Part Requisition Form"; Text[100])
        {
            Caption = 'Part Requisition Form';
            DataClassification = CustomerContent;
        }
        field(50103; "Expected RDC Return Date"; Date)
        {
            Caption = 'Expected RDC Return Date';
            DataClassification = CustomerContent;
        }
        field(50104; "Carriage Name"; Text[100])
        {
            Caption = 'Carriage Name';
            DataClassification = CustomerContent;
        }
        field(50105; "Mode Of Shipment"; Text[100])
        {
            Caption = 'Mode Of Shipment';
            DataClassification = CustomerContent;
        }
        field(50106; "Pre carriage By"; Text[100])
        {
            Caption = 'Pre carriage By';
            DataClassification = CustomerContent;
        }
        field(50107; "Follo Number Master"; Text[20])
        {
            Caption = 'Follo Number Master';
            DataClassification = CustomerContent;
        }
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
        field(50110; "Bill of Entry No."; Code[20])
        {
            Caption = 'Bill of Entry No.';
            DataClassification = CustomerContent;
        }
        field(50111; "Bill of Entry Date"; Date)
        {
            Caption = 'Bill of Entry Date';
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
        field(50114; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DataClassification = CustomerContent;
        }
        field(50115; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = CustomerContent;
        }
        field(50116; "Port Code"; Code[20])
        {
            Caption = 'Port Code';
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
