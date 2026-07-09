tableextension 50022 "Transfer Header Ext" extends "Transfer Header"
{
    fields
    {
        //TBC-506 --->
        field(50002; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Teams Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
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
            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                If Cust.Get(Rec.Customer_Name) then begin
                    Rec."Customer No." := Cust."No.";
                    Rec.Customer_Name := Cust.Name;
                    Rec."Contact Name" := Cust.Contact;
                end;
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

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if Emp.Get(Rec."Custom Assigned User ID") then
                    Rec."Custom Assigned User ID" := Emp."First Name" + ' ' + Emp."Last Name";
            end;
        }
        field(50107; "Master Sales Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No.";
            ValidateTableRelation = true;
        }
        field(50108; Note; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50109; "Value Declaration"; Text[250])
        {
            DataClassification = ToBeClassified;
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
