tableextension 50025 "Warehouse Shipment Header Ext" extends "Warehouse Shipment Header"
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
        field(50104; Customer_Name; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            ValidateTableRelation = true;
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
        field(50108; Note; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50109; "Value Declaration"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        //TBC-973 -->
        field(50110; "Party PO Received Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        //TBC-973 <--
    }
}
