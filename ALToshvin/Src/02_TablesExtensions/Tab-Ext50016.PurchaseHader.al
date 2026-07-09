namespace Toshvin.Toshvin;

using Microsoft.Purchases.Document;

tableextension 50016 "Purchase Hader" extends "Purchase Header"
{
    fields
    {

        field(50000; "GST Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Total GST Amount"
                      where("Document Type" = field("Document Type"),
                            "Document No." = field("No.")));
        }
        field(50001; "Total Amount Excl. GST"; Decimal)
        {
            Caption = 'Amount Excl. GST';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Total GST Amount" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
        }
        field(50002; "Purchase Order Type"; Text[100])
        {
            Caption = 'Purchase Order Type';
            DataClassification = ToBeClassified;
        }
        field(50003; "Domesctic Order"; Boolean)
        {
            Caption = 'Domesctic Order';
            DataClassification = CustomerContent;
        }
        field(50004; "Sales Type"; Text[10])
        {
            Caption = 'Sales Type';
            DataClassification = CustomerContent;
        }
        field(50005; "Folio No."; Code[100])
        {
            Caption = 'Folio No.';
            DataClassification = CustomerContent;
        }
        field(50006; "Transportation Chg."; Decimal)
        {
            Caption = 'Transportation Chg.';
            DataClassification = CustomerContent;
        }
        field(50007; "Delivery Terms"; Text[50])
        {
            Caption = 'Delivery Terms';
            DataClassification = CustomerContent;
        }
        field(50008; "Supplier Quote No."; Text[50])
        {
            Caption = 'Supplier Quote No.';
            DataClassification = CustomerContent;
        }
        field(50009; "Supplier Quote Date"; Date)
        {
            Caption = 'Supplier Quote Date';
            DataClassification = CustomerContent;
        }
        field(50010; Warranty; Text[100])
        {
            Caption = 'Warranty';
            DataClassification = CustomerContent;
        }
        field(50011; "Payment Term Details"; Text[1048])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Term Details';
        }
        field(50012; "Purchase Type"; Option)
        {
            Caption = 'Purchase Type';
            DataClassification = CustomerContent;
            OptionMembers = ,Domestic,Import,"Expense Order";
        }
        field(50013; "Inco Terms"; Text[100])
        {
            Caption = 'Inco Terms';
            DataClassification = CustomerContent;
        }
        field(50014; "Invoice Discount Perc"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Discount %';
        }
        field(50015; "Custom Freight Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Custom Freight Amount';

            //TBC-1062 --->
            // trigger OnValidate()
            // var
            //     PurchLine: Record "Purchase Line";
            //     TotalPOAmount: Decimal;
            // begin
            //     Rec.TestStatusOpen();
            //     TotalPOAmount := 0;

            //     PurchLine.Reset();
            //     PurchLine.SetRange("Document Type", Rec."Document Type");
            //     PurchLine.SetRange("Document No.", Rec."No.");
            //     if PurchLine.FindSet() then
            //         repeat
            //             TotalPOAmount += PurchLine."Line Amount";
            //         until PurchLine.Next() = 0;

            //     PurchLine.Reset();
            //     PurchLine.SetRange("Document Type", Rec."Document Type");
            //     PurchLine.SetRange("Document No.", Rec."No.");
            //     if PurchLine.FindSet(true) then
            //         repeat
            //             if (Rec."Custom Freight Amount" <> 0) and
            //                (TotalPOAmount <> 0) and
            //                (PurchLine."Direct Unit Cost" <> 0) and
            //                (PurchLine.Quantity <> 0)
            //             then
            //                 PurchLine."Freight Amount" :=
            //                     (Rec."Custom Freight Amount" / TotalPOAmount) * PurchLine."Line Amount"
            //             else
            //                 PurchLine."Freight Amount" := 0;
            //             PurchLine.Modify(false);
            //         until PurchLine.Next() = 0;
            // end;

            //TBC-1062 <----

        }
        field(50016; "Custom Insurance Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Custom Insurance Amount';

            //TBC-1062 ---->
            // trigger OnValidate()
            // var
            //     PurchLine: Record "Purchase Line";
            //     TotalPOAmount: Decimal;
            // begin
            //     Rec.TestStatusOpen();
            //     TotalPOAmount := 0;

            //     PurchLine.Reset();
            //     PurchLine.SetRange("Document Type", Rec."Document Type");
            //     PurchLine.SetRange("Document No.", Rec."No.");
            //     if PurchLine.FindSet() then
            //         repeat
            //             TotalPOAmount += PurchLine."Line Amount";
            //         until PurchLine.Next() = 0;

            //     PurchLine.Reset();
            //     PurchLine.SetRange("Document Type", Rec."Document Type");
            //     PurchLine.SetRange("Document No.", Rec."No.");
            //     if PurchLine.FindSet(true) then
            //         repeat
            //             if (Rec."Custom Insurance Amount" <> 0) and
            //                (TotalPOAmount <> 0) and
            //                (PurchLine."Direct Unit Cost" <> 0) and
            //                (PurchLine.Quantity <> 0)
            //             then
            //                 PurchLine."Insurance Amount" :=
            //                     (Rec."Custom Insurance Amount" / TotalPOAmount) * PurchLine."Line Amount"
            //             else
            //                 PurchLine."Insurance Amount" := 0;
            //             PurchLine.Modify(false);
            //         until PurchLine.Next() = 0;
            // end;
            //TBC-1062 <----

        }
        field(50017; "Custom Assigned User ID"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assigned User ID';
        }
        field(50018; "Custom Ship-to"; Enum "Purchase Order Ship-to Options")
        {
            Caption = 'Custom Ship-to';
            DataClassification = CustomerContent;
        }
        field(50019; "Port Code (Imports)"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Port Code (Imports)';
        }
        field(50020; "Reference Date (Import)"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Reference Date (Import)';
        }
        //TBC-1060 --->
        field(50021; "Vendor Invoice Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        //TBC-1060 <----

        //TBC-1062 --->
        field(50022; "Custom Freight Amount INR"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Custom Freight Amount INR';
        }
        field(50023; "Custom Insurance Amount INR"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Custom Insurance Amount INR';
        }
        //TBC-1062 <---
    }

}
