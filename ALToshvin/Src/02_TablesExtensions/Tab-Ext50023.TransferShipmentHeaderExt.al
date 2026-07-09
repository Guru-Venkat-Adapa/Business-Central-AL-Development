tableextension 50023 "Transfer Shipment Header Ext" extends "Transfer Shipment Header"
{
    fields
    {

        //TBC-506 --->
        field(50002; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        //TBC-506 <---
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
        field(50104; Customer_Name; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            ValidateTableRelation = true;
            Editable = false;
            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                If Cust.get(Rec.Customer_Name) then
                    Rec.Customer_Name := Cust.Name;
            end;
        }
        field(50105; "Service Persion ID"; Text[100])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = Employee."No.";
            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if Emp.Get(Rec."Service Persion ID") then begin
                    Rec."Service Persion ID" := Emp."First Name" + ' ' + Emp."Last Name";
                end
            end;
        }
        field(50106; "Custom Assigned User ID"; Text[100])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = Employee."No.";
            Caption = 'Assigned User ID';
        }
        field(50108; Note; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50109; "Value Declaration"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        //TBC-1016 ---->
        field(50110; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50111; "Contact Name"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        //TBC-1016 <----
    }
}
