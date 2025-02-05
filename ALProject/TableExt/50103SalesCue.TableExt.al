tableextension 50103 "Demo Sales Cue Table Ext" extends "Sales Cue"
{
    fields
    {
        field(50100; "Demo Sales order Open"; Integer)
        {
            // AccessByPermission = tabledata "Sales Shipment Header" =R;
            Caption = 'Demo Sales Order open';
            Editable = false;
            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                        Status = filter(Open)));
            FieldClass = FlowField;
        }
        field(50101; "Demo Customer"; Integer)
        {
            Caption = 'Demo Customer Location';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count(Customer where("Location Code" = const('Yellow'),
                                                "Sales (LCY)" = const(0),
                                                "Balance (LCY)" = const(0),
                                                Bonuses = const(0)));
        }
        field(50102; "Demo Vendor"; Integer)
        {
            Caption = 'Demo Vendor';
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = count(Vendor where("Balance (LCY)" = filter(0 .. 100000)));
        }
    }
}