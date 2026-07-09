namespace Toshvin.Toshvin;

using Microsoft.Purchases.Document;

pageextension 50025 "Purchase Sub Form" extends "Purchase Order Subform"
{
    layout
    {
        //TBC - 835 -->
        modify("Line No.")
        {
            Visible = true;
        }
        movebefore("No."; "Line No.")
        //TBC - 835 <--
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        moveafter(Description; "Description 2")
        moveafter("Description 2"; "HSN/SAC Code")
        moveafter("HSN/SAC Code"; "Location Code")
        addafter("Location Code")
        {
            field("Available Inventory"; Rec."Available Inventory")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the values of Available Inventory filed';
            }
        }
        moveafter("Available Inventory"; Quantity)
        moveafter("Unit of Measure Code"; "Direct Unit Cost")
        moveafter("Direct Unit Cost"; "Line Discount %")
        moveafter("Line Discount %"; "Line Discount Amount")
        moveafter("Line Discount Amount"; "Line Amount")
        moveafter("Line Amount"; "GST Group Code")
        addbefore("GST Group Code")
        {
            field(Amount; Rec.Amount)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("InvoiceDiscount Amount"; Rec."Inv. Discount Amount")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Purchasing Code"; Rec."Purchasing Code")
            {
                ApplicationArea = All;
            }
            field("Special Order Sales No."; Rec."Special Order Sales No.")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field("Special Order Sales Line No."; Rec."Special Order Sales Line No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Special Order"; Rec."Special Order")
            {
                ApplicationArea = All;
            }

        }
        addafter("Custom Duty Amount")
        {
            field("Freight Amount"; Rec."Freight Amount")
            {
                ApplicationArea = All;
                Caption = 'Freight Amount';

            }
            field("Insurance Amount"; Rec."Insurance Amount")
            {
                ApplicationArea = All;
                Caption = 'Insurance Amount';

            }
        }

        addafter("GST Group Code")
        {
            field("SGST Percentage"; Rec."SGST Percentage")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("SGST Amount"; Rec."SGST Amount")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("CGST Percentage"; Rec."CGST Percentage")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("CGST Amount"; Rec."CGST Amount")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("IGST Percentage"; Rec."IGST Percentage")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("IGST Amount"; Rec."IGST Amount")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        moveafter("IGST Amount"; "Qty. to Receive")
        moveafter("Qty. to Receive"; "Quantity Received")
        moveafter("Quantity Received"; "Qty. to Invoice")
        moveafter("Qty. to Invoice"; "Quantity Invoiced")
        modify(Control19)
        {
            Visible = false;
        }
        modify("HSN/SAC Code")
        {
            Editable = false;
        }
        modify("GST Group Code")
        {
            Editable = false;
        }
        addafter(Control37)
        {
            group("Invoice Amt")
            {
                field("Total Amount Excl. GST"; Rec."Total Amount Excl. GST")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(TotalGSTAmount; TotalGSTAmount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total GST Amount';
                }
                field("Total Amount Incl. GST"; Rec."Total Amount Incl. GST")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        modify("Item Reference No.")
        {
            Visible = false;
        }
        modify("Reserved Quantity")
        {
            Visible = false;
        }
        modify("TDS Section Code")
        {
            Visible = false;
        }
        modify("Nature of Remittance")
        {
            Visible = false;
        }
        modify("Act Applicable")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("GST Assessable Value")
        {
            Visible = false;
        }
        modify("Custom Duty Amount")
        {
            Visible = false;
        }
        modify(Exempted)
        {
            Visible = false;
        }
        modify("GST Credit")
        {
            Visible = false;
        }
        modify("Item Charge Qty. to Handle")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
        modify("Planned Receipt Date")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify("Over-Receipt Code")
        {
            Visible = false;
        }
        modify("Over-Receipt Quantity")
        {
            Visible = false;
        }
        modify("Description 2")
        {
            Visible = true;
        }
        modify("Direct Unit Cost")
        {
            CaptionClass = 'Direct Unit Cost Excl. GST';
        }
        modify("Line Amount")
        {
            CaptionClass = 'Line Amount Excl. GST';
            Editable = false;
        }
        modify(Description)
        {
            Editable = false;
        }


    }
    trigger OnAfterGetCurrRecord()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(TotalGSTAmount);
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."Document No.");
        if PurchaseLine.FindSet() then
            repeat
                TotalGSTAmount += PurchaseLine."SGST Amount" + PurchaseLine."CGST Amount" + PurchaseLine."IGST Amount";
            until PurchaseLine.Next() = 0;
        Rec."Total Amount Excl. GST" := TotalPurchaseLine.Amount;
        Rec."Total Amount Incl. GST" := TotalGSTAmount + TotalPurchaseLine."Amount Including VAT";
    end;

    //This Function call from Purchase Order Page Action - Break Special Order ------>
    procedure UpdateSpecialOrderDiscount(var PurchaseLine: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        AmountWithDiscountAllowed: Decimal;
        InvoiceDiscountPct: Decimal;
        InvoiceDiscountAmount: Decimal;
    begin
        // Get Purchase Header for the line
        if not PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") then
            exit;
        InvoiceDiscountPct := PurchaseHeader."Invoice Discount Perc";
        // If discount is zero → just clear values and exit
        if InvoiceDiscountPct = 0 then begin
            PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(0, PurchaseHeader);
            exit;
        end;
        // Load currency
        if PurchaseHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision()
        else
            Currency.Get(PurchaseHeader."Currency Code");

        // Calculate allowed discount base
        AmountWithDiscountAllowed :=
            CalcTotalPurchAmountOnlyDiscountAllowed(PurchaseLine);

        // Calculate discount amount
        InvoiceDiscountAmount :=
            Round(AmountWithDiscountAllowed * InvoiceDiscountPct / 100,
                  Currency."Amount Rounding Precision");

        // Apply discount
        PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, PurchaseHeader);

        // Mark totals as obsolete → forces BC to recalc
        PurchaseDocTotalsNotUpToDate();
    end;
    //This Function call from Purchase Order Page Action - Break Special Order <------

    procedure CalcTotalPurchAmountOnlyDiscountAllowed(PurchLine: Record "Purchase Line"): Decimal
    var
        TotalPurchLine: Record "Purchase Line";
    begin
        TotalPurchLine.SetRange("Document Type", PurchLine."Document Type");
        TotalPurchLine.SetRange("Document No.", PurchLine."Document No.");
        TotalPurchLine.SetRange("Allow Invoice Disc.", true);
        TotalPurchLine.CalcSums("Line Amount");
        exit(TotalPurchLine."Line Amount");
    end;

    procedure PurchaseDocTotalsNotUpToDate()
    begin
        TotalsUpToDate := false;
    end;

    var
        TotalGSTAmount: Decimal;

        TotalsUpToDate: Boolean;






}
