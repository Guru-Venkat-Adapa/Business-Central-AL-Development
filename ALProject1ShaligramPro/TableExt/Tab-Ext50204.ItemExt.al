tableextension 50204 "Item Ext" extends Item
{
    fields
    {
        field(50200; "Qty. to Recive Bl Puch Order"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Qty. to Receive on Blanket Purchase Order';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
            Editable = false;
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("Document Type" = const("Blanket Order"),
                                                                               Type = const(Item),
                                                                               "No." = field("No."),
                                                                               "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                               "Location Code" = field("Location Filter"),
                                                                               "Drop Shipment" = field("Drop Shipment Filter"),
                                                                               "Variant Code" = field("Variant Filter"),
                                                                               "Expected Receipt Date" = field("Date Filter"),
                                                                               "Unit of Measure Code" = field("Unit of Measure Filter")));
        }
        field(50201; ScheduleInventoryOfBlanket; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Schedule Blanket qty. to Receive';
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
            Editable = false;
            CalcFormula = sum("Purchase Line"."Custom Quantity" where("Document Type" = const("Blanket Order"),
                                                                               Type = const(Item),
                                                                               "No." = field("No."),
                                                                               "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                               "Location Code" = field("Location Filter"),
                                                                               "Drop Shipment" = field("Drop Shipment Filter"),
                                                                               "Variant Code" = field("Variant Filter"),
                                                                               "Expected Receipt Date" = field("Date Filter"),
                                                                               "Unit of Measure Code" = field("Unit of Measure Filter")));
        }
    }
}
