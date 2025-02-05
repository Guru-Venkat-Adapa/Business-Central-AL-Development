table 50104 SalesOpenDocuments
{
    Caption = 'SalesOpenDocuments';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
        }
        field(2; "Sales Quote"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Sales Quote';
            CalcFormula = count("Sales Header" where("Document Type" = const(Quote), Status = const(Open)));
            //Editable = false;
        }
        field(3; "Sales Order"; Integer)
        {
            Caption = 'Sales Order';
            FieldClass = FlowField;
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = count("Sales Header" where("Document Type" = const(Order), Status = const(Open)));
            //Editable = false;
        }
        field(4; "Sales Invoice"; Integer)
        {
            Caption = 'Sales Invoice';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Invoice), Status = const(Open)));
        }
        field(5; "Sales Quote Released"; Integer)
        {
            Caption = 'Sales Quote Released';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Quote), Status = const(Released)));
            //Editable = false;
        }
        field(6; "Sales Order Released"; Integer)
        {
            Caption = 'Sales Order Released';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Order), Status = const(Released)));
            // Editable = false;
        }
        field(7; "Sales Invoice Released"; Integer)
        {
            Caption = 'Sales Quote Released';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Invoice), Status = const(Released)));
            // Editable = false;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
