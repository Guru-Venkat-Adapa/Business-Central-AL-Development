pageextension 50062 "Ext Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        modify("Vendor Invoice No.")
        {
            ShowMandatory = true;
        }

        //TBC-1060 --->
        addafter("Vendor Invoice No.")
        {
            field("Vendor Invoice Date"; Rec."Vendor Invoice Date")
            {
                ApplicationArea = All;
                Caption = 'Vendor Invoice Date';
            }
        }
        //TBC-1060 <---

        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        addafter("Bill of Entry No.")
        {
            group(ReferanceDate)
            {
                Caption = '';
                Visible = Rec."GST Vendor Type" = Rec."GST Vendor Type"::Import;

                field("Reference Date (Import)"; Rec."Reference Date (Import)")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
            }

        }
        addafter("Include GST in TDS Base")
        {
            //TBC-1062 --->
            field("Custom Freight Amount INR"; Rec."Custom Freight Amount INR")
            {
                ApplicationArea = All;
                Caption = 'Custom Freight Amount INR';
                Visible = false;

                trigger OnValidate()
                var
                    ExchageRate: Decimal;
                begin
                    if Rec."Currency Factor" <> 0 then
                        ExchageRate := 1 / Rec."Currency Factor"
                    else
                        ExchageRate := 1;
                    Rec.Validate("Custom Freight Amount", (Rec."Custom Freight Amount INR" * ExchageRate));
                end;
            }
            field("Custom Insurance Amount INR"; Rec."Custom Insurance Amount INR")
            {
                ApplicationArea = All;
                Caption = 'Custom Insurance Amount INR';
                Visible = false;

                trigger OnValidate()
                var
                    ExchageRate: Decimal;
                begin
                    if Rec."Currency Factor" <> 0 then
                        ExchageRate := 1 / Rec."Currency Factor"
                    else
                        ExchageRate := 1;
                    Rec.Validate("Custom Insurance Amount", (Rec."Custom Insurance Amount INR" * ExchageRate));
                end;
            }
            //TBC-1062 <---
            field("Custom Freight Amount"; Rec."Custom Freight Amount")
            {
                ApplicationArea = All;
                Caption = 'Custom Freight Amount';


                trigger OnValidate()
                var
                    PurchLine: Record "Purchase Line";
                    TotalPOAmount: Decimal;
                begin
                    Rec.TestStatusOpen();
                    TotalPOAmount := 0;

                    // Calculate total PO line amount
                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", Rec."Document Type");
                    PurchLine.SetRange("Document No.", Rec."No.");
                    if PurchLine.FindSet() then
                        repeat
                            TotalPOAmount += PurchLine."Line Amount";
                        until PurchLine.Next() = 0;

                    // Distribute Insurance Amount
                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", Rec."Document Type");
                    PurchLine.SetRange("Document No.", Rec."No.");
                    if PurchLine.FindSet() then
                        repeat
                            if Rec."Custom Freight Amount" <> 0 then begin
                                if (TotalPOAmount <> 0) and
                                   (PurchLine."Direct Unit Cost" <> 0) and
                                   (PurchLine.Quantity <> 0)
                                then
                                    PurchLine."Freight Amount" :=
                                        (Rec."Custom Freight Amount" / TotalPOAmount) * PurchLine."Line Amount"
                            end else
                                PurchLine."Freight Amount" := 0;
                            PurchLine.Modify(false);
                        until PurchLine.Next() = 0;
                end;

            }
            field("Custom Insurance Amount"; Rec."Custom Insurance Amount")
            {
                ApplicationArea = All;
                Caption = 'Custom Insurance Amount';


                trigger OnValidate()
                var
                    PurchLine: Record "Purchase Line";
                    TotalPOAmount: Decimal;
                begin
                    Rec.TestStatusOpen();
                    TotalPOAmount := 0;

                    // Calculate total PO line amount
                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", Rec."Document Type");
                    PurchLine.SetRange("Document No.", Rec."No.");
                    if PurchLine.FindSet() then
                        repeat
                            TotalPOAmount += PurchLine."Line Amount";
                        until PurchLine.Next() = 0;

                    // Distribute Insurance Amount
                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", Rec."Document Type");
                    PurchLine.SetRange("Document No.", Rec."No.");
                    if PurchLine.FindSet() then
                        repeat
                            if Rec."Custom Insurance Amount" <> 0 then begin
                                if (TotalPOAmount <> 0) and
                                   (PurchLine."Direct Unit Cost" <> 0) and
                                   (PurchLine.Quantity <> 0)
                                then
                                    PurchLine."Insurance Amount" :=
                                        (Rec."Custom Insurance Amount" / TotalPOAmount) * PurchLine."Line Amount"
                            end else
                                PurchLine."Insurance Amount" := 0;
                            PurchLine.Modify(false);
                        until PurchLine.Next() = 0;
                end;
            }
        }
    }
}
