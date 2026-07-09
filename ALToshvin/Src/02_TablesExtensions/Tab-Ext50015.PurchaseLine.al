namespace Toshvin.Toshvin;

using Microsoft.Purchases.Document;
using Microsoft.Inventory.Ledger;

tableextension 50015 "Purchase Line" extends "Purchase Line"
{
    fields
    {

        field(50000; "SGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'SGST %';

            trigger OnValidate()
            begin
                TestStatusOpen();
                Rec."SGST Amount" := (Rec."SGST Percentage" / 100) * Rec."Line Amount";
                UpdateTotalGST();
            end;
        }
        field(50001; "CGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'CGST %';

            trigger OnValidate()
            begin
                TestStatusOpen();
                Rec."CGST Amount" := (Rec."CGST Percentage" / 100) * Rec."Line Amount";
                UpdateTotalGST();
            end;
        }
        field(50002; "IGST Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'IGST %';

            trigger OnValidate()
            var
                GSTRate: Record "Gst Rate Percentage";
                PurchaseHeader: Record "Purchase Header";
                KlFloogPer: Decimal;
                CUstomDuty: Decimal;
            begin
                Clear(KlFloogPer);
                Clear(CUstomDuty);
                if not PurchaseHeader.Get("Document Type", "Document No.") then
                    exit;

                GSTRate.Reset();
                GSTRate.SetRange("From State", PurchaseHeader.State);
                GSTRate.SetRange("Location State Code", PurchaseHeader."Location State Code");
                GSTRate.SetRange("GST Group Code", Rec."GST Group Code");
                if GSTRate.FindFirst() then
                    KlFloogPer := GSTRate."KFloodCess Percentage";

                CUstomDuty := Rec."Line Amount" * KlFloogPer / 100;

                Rec."IGST Amount" := (Rec."Line Amount" + CUstomDuty) * (Rec."IGST Percentage" / 100);
                UpdateTotalGST();
            end;
        }
        field(50003; "SGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'SGST Amount';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50004; "CGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'CGST Amount';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50005; "IGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'IGST Amount';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50006; "Total GST Amount"; Decimal)
        {
            Caption = 'Total GST Amount';
            Editable = false;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50007; "Total Amount Excl. GST"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Amount Excl. GST';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50008; "Posted Warehouse Rec No"; Code[20])
        {
            Caption = 'Posted Warehouse Rec No';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50009; "Available Inventory"; Decimal)
        {
            Caption = 'Available Inventory';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."), "Variant Code" = field("Variant Code"), "Drop Shipment" = const(false)));
        }
        field(50010; "Total Amount Incl. GST"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Amount Incl. GST';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50011; "Freight Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Insurance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    local procedure UpdateTotalGST()
    begin
        "Total GST Amount" := "SGST Amount" + "CGST Amount" + "IGST Amount";
    end;
}
