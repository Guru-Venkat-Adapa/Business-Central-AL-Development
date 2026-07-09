pageextension 50011 SalesOrderSubform extends "Sales Order Subform"
{
    ModifyAllowed = true;
    layout
    {
        //TBC-823 --->
        addafter("Description 2")
        {
            field(Remark; Rec.Remark)
            {
                ApplicationArea = All;
                Caption = 'Remark';
            }
        }
        //TBC-823 <---
        //TBC - 835 -->
        modify("Line No.")
        {
            Visible = true;
        }
        movebefore("No."; "Line No.")
        //TBC - 835 <--

        //TBC - 898 <--
        modify("GST Jurisdiction Type")
        {
            Editable = false;
        }
        //TBC - 898  -->
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        modify("Item Reference No.")
        {
            Visible = false;
        }
        modify("TCS Nature of Collection")
        {
            Visible = false;
        }
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }

        moveafter(Description; "HSN/SAC Code")
        moveafter("HSN/SAC Code"; "Location Code")
        modify("HSN/SAC Code")
        {
            Editable = false;
        }
        addafter("Location Code")
        {
            field("Available Inventory"; Rec."Available Inventory")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the values of Available Inventory filed';
            }
        }
        addafter(Description)
        {
            field(Description2; Rec.Description2)
            {
                ApplicationArea = All;
                Caption = 'Description 2';
                trigger OnValidate()
                begin
                    if Rec.Description2 <> '' then
                        Rec."Description 2" := Rec.Description2
                    else
                        Rec."Description 2" := '';

                    Rec.Modify(false);

                end;
            }
        }
        modify("Line Discount Amount")
        {
            Visible = true;
        }
        addafter("Location Code")
        {

            field("Batch/Serial Number"; Rec."Batch/Serial Number")
            {
                ApplicationArea = All;
                Caption = 'Batch/Serial No.';
                ToolTip = 'Specifies the values of batch/serial number filed';
                TableRelation = "Item Ledger Entry"."Serial No.";
                Visible = ShowCustomField;
                trigger OnLookup(var Text: Text): Boolean
                var
                    ItemLedEntry: Record "Item Ledger Entry";
                begin
                    ItemLedEntry.SetRange("Entry Type", ItemLedEntry."Entry Type"::Sale);
                    ItemLedEntry.SetFilter("Serial No.", '<>''''');
                    if Page.RunModal(Page::"Item Ledger Entries", ItemLedEntry) = Action::LookupOK then begin
                        Rec."Batch/Serial Number" := ItemLedEntry."Serial No.";
                        Rec.Modify(true);
                        Text := ItemLedEntry."Serial No.";
                        exit(true);
                    end;

                    exit(false);
                end;

            }
            field("Item Instrument No."; Rec."Item Instrument No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Instrument No. field.';
                Caption = 'Instrument Serial No.';
            }
            field("Sp Inst. Model"; Rec."Inst. Model")
            {
                ApplicationArea = All;
                Caption = 'Instrument Model No.';
                Visible = true;
            }
            field("CMC/AMC Start Date"; Rec."CMC/AMC Start Date")
            {
                ApplicationArea = All;
                Caption = 'Contract Start Date';
                ToolTip = 'Specifies the values of contract start date filed';
                Visible = ShowCustomField;
            }
            field("CMC/AMC End Date"; Rec."CMC/AMC End Date")
            {
                ApplicationArea = All;
                Caption = 'Contract End Date';
                ToolTip = 'Specifies the values of contract end date filed';
                Visible = ShowCustomField;
                trigger OnValidate()
                begin
                    if Rec."CMC/AMC End Date" < Rec."CMC/AMC Start Date" then
                        Error('End date can not be before the start date');
                end;
            }

        }
        moveafter("Available Inventory"; Quantity)
        moveafter(Quantity; "Purchasing Code")
        addafter("Purchasing Code")
        {
            field("Special Order Purchase No."; Rec."Special Order Purchase No.")
            {
                Editable = true;
                ApplicationArea = All;
                Visible = ShowStandardField;
            }
            field("Special Order Purch. Line No."; Rec."Special Order Purch. Line No.")
            {
                Editable = true;
                ApplicationArea = All;
                Visible = ShowStandardField;
            }
            field(Principal; Rec.Principal)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Principal field.';
                Visible = ShowStandardField;
            }
        }
        moveafter(Principal; "Unit of Measure Code")
        moveafter("Unit of Measure Code"; "Unit Price")
        moveafter("Unit Price"; "Line Discount %")
        moveafter("Line Discount %"; "Line Discount Amount")
        moveafter("Line Discount Amount"; "Line Amount")
        moveafter("Line Amount"; "GST Group Code")
        modify("GST Group Code")
        {
            Editable = false;
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
        moveafter("IGST Amount"; "Qty. to Ship")
        moveafter("Qty. to Ship"; "Quantity Shipped")
        moveafter("Quantity Shipped"; "Qty. to Invoice")
        moveafter("Qty. to Invoice"; "Quantity Invoiced")
        addbefore("GST Group Code")
        {
            field("Gross Value"; Rec."Gross Value")
            {
                ApplicationArea = All;
                Caption = 'Gross Value';
                ToolTip = 'Specifies the value of the Gross Value field.';
            }
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = All;
                Caption = 'Qty. on Purch. Order';
                ToolTip = 'Specifies how many units of the item are inbound on purchase orders, meaning listed on outstanding purchase order lines.';
            }
            field("Warehouse Receipt Quantity"; Rec."Warehouse Receipt Quantity")
            {
                ApplicationArea = All;
                Caption = 'Warehouse Receipt Qty';
                ToolTip = 'Specifies how many units of the item have been received into inventory through warehouse receipts.';
            }
            field("Total Reserved Quantity"; Rec."Total Reserved Quantity")
            {
                ApplicationArea = All;
                Caption = 'Total Reserved Qty';
                ToolTip = 'Specifies the total quantity of the item that is reserved.';
            }
        }
        addafter("Purchasing Code")
        {
            field("Warranty/Service Period"; Rec."Warranty/Service Period")
            {
                ApplicationArea = All;
                Caption = 'Warranty/Service Period';
                Visible = InstFields;
            }
        }
        addafter("Quantity Invoiced")
        {
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
                Caption = 'Item Category';
                ToolTip = 'Specifies the value of the Item Category field.';
                Editable = false;
            }
            field(MOQ; Rec."MOQ Quantity")
            {
                ApplicationArea = All;
                Caption = 'MOQ';
                ToolTip = 'Specifies the values of MOQ for Item';
                Visible = MOQField;
            }

        }

        modify("Invoice Disc. Pct.")
        {
            Editable = IsEditable;
            trigger OnAfterValidate()
            var
                SalesLine: Record "Sales Line";
                WeSalesQuote: Codeunit SalesQuoteWebToBC;
                SalesHeader: Record "Sales Header";
                TotalGST: Record "Sales Line";
            begin
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", Rec."Document Type");
                SalesLine.SetRange("Document No.", Rec."Document No.");
                if SalesLine.FindFirst() then begin
                    SalesLine."Total Amount Excl. GST" := TotalSalesLine."Line Amount" - InvoiceDiscountAmount;
                    SalesLine."Total Amount Incl. GST" := TotalSalesLine."Line Amount" - InvoiceDiscountAmount;
                    SalesLine.Modify(false);
                end;

                TotalGST.Reset();
                TotalGST.SetRange("Document Type", Rec."Document Type");
                TotalGST.SetRange("Document No.", Rec."Document No.");
                if TotalGST.FindSet() then
                    repeat
                        if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
                            TotalGST.Validate("SGST Percentage", WeSalesQuote.SGSTPercentage(SalesHeader, SalesLine));
                            TotalGST.Validate("CGST Percentage", WeSalesQuote.CGSTPercentage(SalesHeader, SalesLine));
                            TotalGST.Validate("IGST Percentage", WeSalesQuote.IGSTPercentage(SalesHeader, SalesLine));
                            TotalGST.Modify(false);
                        end;
                    until TotalGST.Next() = 0;
            end;
        }

        modify("Invoice Discount Amount")
        {
            Editable = IsEditable;
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Inv. Discount Amount Excl. GST', Currency.Code);
            trigger OnAfterValidate()
            var
                SalesLine: Record "Sales Line";
                WeSalesQuote: Codeunit SalesQuoteWebToBC;
                SalesHeader: Record "Sales Header";
                TotalGST: Record "Sales Line";
            begin
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", Rec."Document Type");
                SalesLine.SetRange("Document No.", Rec."Document No.");
                if SalesLine.FindFirst() then begin
                    SalesLine."Total Amount Excl. GST" := TotalSalesLine."Line Amount" - InvoiceDiscountAmount;
                    SalesLine."Total Amount Incl. GST" := TotalSalesLine."Line Amount" - InvoiceDiscountAmount;
                    SalesLine.Modify(false);
                end;

                TotalGST.Reset();
                TotalGST.SetRange("Document Type", Rec."Document Type");
                TotalGST.SetRange("Document No.", Rec."Document No.");
                if TotalGST.FindSet() then
                    repeat
                        if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
                            TotalGST.Validate("SGST Percentage", WeSalesQuote.SGSTPercentage(SalesHeader, SalesLine));
                            TotalGST.Validate("CGST Percentage", WeSalesQuote.CGSTPercentage(SalesHeader, SalesLine));
                            TotalGST.Validate("IGST Percentage", WeSalesQuote.IGSTPercentage(SalesHeader, SalesLine));
                            TotalGST.Modify(false);
                        end;
                    until TotalGST.Next() = 0;
            end;
        }
        addafter(Control45)
        {
            group("Invoice Amt")
            {
                field("Total Amount Excl. GST"; Rec."Total Amount Excl. GST")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total GST Amount"; TotalGSTAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Total GST Amount';
                    Editable = false;
                }
                field("Total Amount Incl. GST"; Rec."Total Amount Incl. GST")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }

        modify("Unit Price")
        {
            CaptionClass = 'Unit Price Excl. GST';
            ShowMandatory = false;
        }
        modify("Line Amount")
        {
            CaptionClass = 'Line Amount Excl. GST';
            ShowMandatory = false;
            Editable = false;
        }

        modify("TotalSalesLine.""Line Amount""")
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Subtotal Excl GST', Currency.Code);
            Editable = false;
        }

        modify("Total Amount Excl. VAT")
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Total Excl. GST', Currency.Code);
            Editable = false;
        }
        modify("Total Amount Incl. VAT")
        {
            CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Total Incl. GST', Currency.Code);
            Editable = false;
        }
        modify(Control28)
        {
            Visible = false;
        }
        moveafter("Item Category Code"; "Drop Shipment")
        moveafter("Drop Shipment"; "Special Order")
        addafter("Item Category Code")
        {
            field("Reordering Policy"; Rec."Reordering Policy")
            {
                ApplicationArea = All;
                Caption = 'Reordering Policy';
                ToolTip = 'Specifies the value of the Reordering Policy field.';
                Visible = false;

            }
            field("Lead Time Calculation"; Rec."Lead Time Calculation")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lead Time Calculation field.';
                Visible = ShowStandardField;
            }
            field("L-Spares Quotation"; Rec."L-Spares Quotation")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the L-Spares Quotation field.';
                Visible = ShowStandardField;
            }
        }
        modify("Purchasing Code")
        {
            Visible = true;
        }
        modify("Bin Code")
        {
            Visible = true;
        }
        modify("Unit Price Incl. of Tax")
        {
            Visible = false;
        }
        modify("GST Assessable Value (LCY)")
        {
            Visible = false;
        }
        modify("GST on Assessable Value")
        {
            Visible = false;
        }
        modify(Exempted)
        {
            Visible = false;
        }
        modify("Substitution Available")
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
        modify("Item Charge Qty. to Handle")
        {
            Visible = false;
        }
        modify("Planned Delivery Date")
        {
            Visible = false;
        }
        modify("Planned Shipment Date")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        moveafter("Qty. to Ship"; "Deferral Code")
        modify("Deferral Code")
        {
            Visible = InstFields;
            trigger OnAfterValidate()
            var
                Deferral: Record "Deferral Template";
                Periods: Integer;
                DateFormula: Text;
            begin
                if Deferral.Get(Rec."Deferral Code") then begin
                    Rec."CMC/AMC Start Date" := Today;
                    Periods := Deferral."No. of Periods";
                    DateFormula := '+' + Format(Periods) + 'M';
                    Rec."CMC/AMC End Date" := CalcDate(DateFormula, Rec."CMC/AMC Start Date");
                end;
            end;
        }
        addafter("Line Amount")
        {

            field(Instrument; Rec.Instrument)
            {
                ApplicationArea = All;
                Caption = 'Instrument';
                Visible = ClaimCustomField;
            }
            field("RDC No."; Rec."RDC No.")
            {
                ApplicationArea = All;
                Caption = 'RDC No.';
                Visible = ClaimCustomField;
            }
            field("RDC Date"; Rec."RDC Date")
            {
                ApplicationArea = All;
                Caption = 'RDC Date';
                Visible = ClaimCustomField;
            }
            field("Installation Date"; Rec."Installation Date")
            {
                ApplicationArea = All;
                Caption = 'Installation Date';
                Visible = ClaimCustomField;
            }

        }
    }
    //28/07/2025 guru
    trigger OnAfterGetRecord()
    begin
        SetVisibility();
        if Rec."Description 2" <> '' then
            Rec.Description2 := Rec."Description 2";
    end;

    trigger OnAfterGetCurrRecord()
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
    begin
        //28/07/2025 guru
        SetVisibility();
        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
            IsEditable := SalesHeader.Status = SalesHeader.Status::Open;

        Clear(TotalGSTAmount);
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."Document No.");
        if SalesLine.FindSet() then
            repeat
                TotalGSTAmount += SalesLine."SGST Amount" + SalesLine."CGST Amount" + SalesLine."IGST Amount";
            until SalesLine.Next() = 0;
        Rec."Total Amount Excl. GST" := TotalSalesLine.Amount;
        Rec."Total Amount Incl. GST" := TotalGSTAmount + TotalSalesLine."Amount Including VAT";


    end;
    //28/07/2025 guru
    trigger OnOpenPage()
    begin
        SetVisibility();
    end;

    procedure SetVisibility()
    begin
        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            case SalesHeader."Sales Order Type" of
                'AMC', 'CMC', 'SERVICES':
                    begin
                        ShowCustomField := true;
                        ShowStandardField := false;
                        ClaimCustomField := false;
                        SparesFields := false;
                        MOQField := true;
                        InstFields := true;
                    end;
                else
                    if SalesHeader."Claim Order" then begin
                        ShowCustomField := false;
                        ShowStandardField := true;
                        ClaimCustomField := true;
                        SparesFields := false;
                        InstFields := false;
                        MOQField := false;
                    end else if SalesHeader."Spare Order" then begin
                        ShowCustomField := false;
                        ShowStandardField := true;
                        ClaimCustomField := false;
                        SparesFields := true;
                        InstFields := false;
                        MOQField := true;
                    end else if SalesHeader."Instrument Order" then begin
                        ShowStandardField := false;
                        ClaimCustomField := false;
                        SparesFields := false;
                        ShowCustomField := true;
                        InstFields := true;
                        MOQField := false;
                    end else begin
                        ShowCustomField := false;
                        ShowStandardField := true;
                        ClaimCustomField := false;
                        SparesFields := false;
                        MOQField := false;
                        InstFields := false;
                    end;
            end;
        end else begin
            ShowCustomField := false;
            ShowStandardField := true;
            ClaimCustomField := false;
            SparesFields := false;
            MOQField := false;
            InstFields := false;
        end;
    end;

    var
        IsEditable: Boolean;
        TotalGSTAmount: Decimal;
        ShowCustomField: Boolean;
        ShowStandardField: Boolean;
        ClaimCustomField: Boolean;
        SparesFields: Boolean;
        MOQField: Boolean;
        InstFields: Boolean;
        SalesHeader: Record "Sales Header";

}
