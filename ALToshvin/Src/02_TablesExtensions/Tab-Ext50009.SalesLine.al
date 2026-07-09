tableextension 50009 "SalesLine" extends "Sales Line"
{
    fields
    {
        field(50001; "Principal"; Code[20])
        {
            Caption = 'Principal';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50002; "L-Spares Quotation"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'L-Spares Quotation';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50003; "Item Instrument No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Instrument No.';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50004; "Reordering Policy"; Enum "Reordering Policy")
        {
            DataClassification = CustomerContent;
            Caption = 'Reordering Policy';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50005; "Lead Time Calculation"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Lead Time Calculation';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50006; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                TestStatusOpen();
                Rec.ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
                ATOLink.UpdateAsmDimFromSalesLine(Rec);
            end;
        }

        field(50007; "SGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'SGST %';

            trigger OnValidate()
            begin
                TestStatusOpen();
                Rec."SGST Amount" := (Rec."SGST Percentage" / 100) * (Rec."Line Amount" - Rec."Inv. Discount Amount");
                UpdateTotalGST
            end;
        }
        field(50008; "CGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'CGST %';

            trigger OnValidate()
            begin
                TestStatusOpen();
                Rec."CGST Amount" := (Rec."CGST Percentage" / 100) * (Rec."Line Amount" - Rec."Inv. Discount Amount");
                UpdateTotalGST
            end;
        }
        field(50009; "IGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'IGST %';

            trigger OnValidate()
            begin
                TestStatusOpen();
                Rec."IGST Amount" := (Rec."IGST Percentage" / 100) * (Rec."Line Amount" - Rec."Inv. Discount Amount");
                UpdateTotalGST
            end;
        }
        field(50010; "SGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'SGST Amount';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50011; "CGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'CGST Amount';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50012; "IGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'IGST Amount';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50013; "Invoice Discount %"; Decimal)
        {
            DataClassification = CustomerContent;

            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
            begin
                TestStatusOpen();
                if Rec."Invoice Discount %" <> 0 then
                    //Rec."Inv. Discount Amount" := (Rec."Line Amount" * Rec."Invoice Discount %") / 100;
            Rec.Validate("Inv. Discount Amount", (Rec."Line Amount" * Rec."Invoice Discount %") / 100);
            end;
        }
        field(50014; "Discount Amount"; Decimal)
        {
            DataClassification = CustomerContent;

            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
            begin
                TestStatusOpen();
                SalesHeader.Reset();
                SalesHeader.SetRange("Document Type", Rec."Document Type");
                SalesHeader.SetRange("No.", Rec."Document No.");
                SalesHeader.SetAutoCalcFields("Sales Order Amount");
                if SalesHeader.FindFirst() then
                    Rec.Validate(Rec."Invoice Discount %", (Rec."Discount Amount" / SalesHeader."Sales Order Amount") * 100);

            end;
        }

        field(50015; "Total Amount Excl. GST"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Amount Excl. GST';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50016; "Total Amount Incl. GST"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Amount Incl. GST';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50017; "Total GST Amount"; Decimal)
        {
            Caption = 'Total GST Amount';
            Editable = false;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50018; "Available Inventory"; Decimal)
        {
            Caption = 'Available Inventory';
            FieldClass = FlowField;

            CalcFormula = sum("Item Ledger Entry".Quantity where(
                "Item No." = field("No."),
                "Variant Code" = field("Variant Code"),
                "Drop Shipment" = const(false),
                 "Location Code" = field("Location Code")
            ));

            Editable = false;
        }
        field(50100; "Batch/Serial Number"; Code[50])
        {
            Caption = 'Batch/Serial Number';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50101; "CMC/AMC Start Date"; Date)
        {
            Caption = 'CMC/AMC Start Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50102; "CMC/AMC End Date"; Date)
        {
            Caption = 'CMC/AMC End Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50103; "Item by Toshvin"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50104; "Instrument"; Text[50])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50105; "RDC No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50106; "RDC Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50108; "Inst. Model"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50109; "Inst SR No."; Text[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50110; "Installation Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50111; Description2; Text[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50112; "MOQ"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'MOQ';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50019; "Non MOQ"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Non MOQ';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50020; "Gross Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Gross Value';
            Editable = false;
        }
        field(50021; "Qty. on Purch. Order"; Decimal)
        {


            CalcFormula = sum("Purchase Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                               Type = const(Item),
                                                                               "No." = field("No.")
                                                                               ));
            Caption = 'Qty. on Purch. Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50022; "Warehouse Receipt Quantity"; Decimal)
        {
            CalcFormula = sum("Warehouse Receipt Line"."Quantity" where("Item No." = field("No."), "Location Code" = field("Location Code")));
            Caption = 'Warehouse Receipt Qty';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50023; "MOQ Quantity"; Decimal)
        {
            Caption = 'MOQ';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }

        field(50024; "Total Reserved Quantity"; Decimal)
        {
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                               "Location Code" = field("Location Code"),
                                                                              "Reservation Status" = const(Reservation),
                                                                              Positive = const(true),
                                                                               "Source Type" = const(32),
                                                                               "Variant Code" = const('')
                                                                                  ));
            Caption = 'Total Reserved Qty';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50025; "Freight Charge"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Freight Charge';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50026; "Insurance Charge"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Insurance Charge';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50027; "Warranty/Service Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50030; "Negotiated Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50031; "CN Other Charges"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50032; "Commission Note Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        //TBC-823 --->
        field(50033; "Remark"; Text[1048])
        {
            DataClassification = CustomerContent;
            Caption = 'Remark';
        }
        //TBC-823 <---
    }



    local procedure UpdateTotalGST()
    begin
        "Total GST Amount" := "SGST Amount" + "CGST Amount" + "IGST Amount";
    end;

    var
        ATOLink: Record "Assemble-to-Order Link";
        UpdateInvDiscountQst: Label 'One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?';
        AmountWithDiscountAllowed: Decimal;
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        InvoiceDiscountAmount: Decimal;
        DocumentTotals: Codeunit "Document Totals";
        Currency: Record Currency;
        SalesLine: Page "Sales Order Subform";
}
