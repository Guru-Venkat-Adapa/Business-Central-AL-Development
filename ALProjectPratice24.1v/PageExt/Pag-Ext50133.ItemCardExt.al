pageextension 50133 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter(ItemPicture)
        {
            part(BarCode; "Bar Code for Item Card")
            {
                ApplicationArea = All;
                Caption = 'Bar Code';
                SubPageLink = "No." = field("No.");
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(GetBarCode)
            {
                ApplicationArea = All;
                Caption = 'Get BarCode';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = New;

                trigger OnAction()
                var
                    Code: Codeunit BarCode;
                begin
                    if not Rec."Bar Code".HasValue then begin
                        Code.GetBarCodeForItem(Rec."No.", '', 'Jpg');
                    end;
                end;
            }
        }
    }
}

//  field(50204; ScheduleInventoryOfBlanket; Decimal)
//         {
//             AccessByPermission = TableData "Sales Shipment Header" = R;
//             Caption = 'Schedule Blanket qty. to Receive';
//             FieldClass = FlowField;
//             DecimalPlaces = 0 : 5;
//             Editable = false;
//             CalcFormula = sum("Purchase Line"."Custom Quantity" where("Document Type" = const("Blanket Order"),
//                                                                                Type = const(Item),
//                                                                                "No." = field("No."),
//                                                                                "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
//                                                                                "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
//                                                                                "Location Code" = field("Location Filter"),
//                                                                                "Drop Shipment" = field("Drop Shipment Filter"),
//                                                                                "Variant Code" = field("Variant Filter"),
//                                                                                "Expected Receipt Date" = field("Date Filter"),
//                                                                                "Unit of Measure Code" = field("Unit of Measure Filter")));
//         }
