tableextension 50043 "Ext Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        //TBC-1072 --->
        field(50000; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';
            ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
            Editable = false;
        }
        //TBC-1072 <---

        //TBC-1042 --->
        field(50108; "Service_Type_"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = ServiceType;
        }
        field(50091; "Service Description"; Text[250])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = false;
            TableRelation = "Service Description".Description;
        }
        field(50103; "No. of Visit"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50095; "Visit Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50096; "Invoice Term"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Executive Master"; Text[100])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if Emp.Get(Rec."Executive Master") then begin
                    Rec."Employee No." := Emp."No.";
                    Rec."Executive Master" := Emp."First Name" + ' ' + Emp."Last Name";
                end;
            end;

        }
        field(50092; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50093; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Employee No."; code[20])
        {
            Caption = 'Handling';
        }
        //TBC-1042 <---
        //TBC-1034 ---->
        field(50139; "Credit Note Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Credit Note Type';
            OptionMembers = " ",Internal,External;
            Editable = false;
        }
        //TBC-1034 <----

        //TBC-1069 --->
        field(50040; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Teams Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        //TBC1069 <---


    }
}
