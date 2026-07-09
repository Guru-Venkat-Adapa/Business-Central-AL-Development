namespace Toshvin.Toshvin;

using Microsoft.Sales.History;
using Microsoft.Utilities;

pageextension 50023 "Posted Sales Invoice Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {

        //TBC-823 --->
        addafter("Description 2")
        {
            field(Remark; Rec.Remark)
            {
                ApplicationArea = All;
                Caption = 'Remark';
                Editable = false;
            }
        }
        //TBC - 835 --->
        //TBC - 835 --->
        addbefore("No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        //TBC - 835 <---
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        modify("Total VAT Amount")
        {
            Visible = false;
        }
        modify("Total Amount Incl. VAT")
        {
            Visible = false;
        }
        addafter("Total Amount Excl. VAT")
        {
            field(TotalGSTAmount; TotalGSTAmount)
            {
                ApplicationArea = All;
                Caption = 'Total GST Amount';
                Editable = false;
            }
            field(TotalIncGST; TotalIncGST)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatExpression = TotalSalesInvoiceHeader."Currency Code";
                AutoFormatType = 1;
                CaptionClass = DocumentTotals.GetTotalInclVATCaption(TotalSalesInvoiceHeader."Currency Code");
                Caption = 'Total Amount Incl. GST';
                Editable = false;
                Style = Strong;
                StyleExpr = true;
                ToolTip = 'Specifies the sum of the value in the Line Amount Incl. GST field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
            }
        }
        addafter("Unit Price")
        {
            field("L-Spares Quotation"; Rec."L-Spares Quotation")
            {
                ApplicationArea = All;
            }
            field("Item Instrument No."; Rec."Item Instrument No.")
            {
                ApplicationArea = All;
            }
            field("Lead Time Calculation"; Rec."Lead Time Calculation")
            {
                ApplicationArea = All;
            }
        }
        addafter("Line Amount")
        {
            field("SGST Percentage"; Rec."SGST Percentage")
            {
                ApplicationArea = All;
            }
            field("SGST Amount"; Rec."SGST Amount")
            {
                ApplicationArea = All;
            }
            field("CGST Percentage"; Rec."CGST Percentage")
            {
                ApplicationArea = All;
            }
            field("CGST Amount"; Rec."CGST Amount")
            {
                ApplicationArea = All;
            }
            field("IGST Percentage"; Rec."IGST Percentage")
            {
                ApplicationArea = All;
            }
            field("IGST Amount"; Rec."IGST Amount")
            {
                ApplicationArea = All;
            }
        }
        addafter("Deferral Code")
        {
            field(MOQ_Quantity; Rec."MOQ Quantity")
            {
                ApplicationArea = All;
                Caption = 'MOQ';
                ToolTip = 'Specifies the values of MOQ for Item';
                Visible = MOQField;
            }
            field("Non MOQ"; Rec."Non MOQ")
            {
                ApplicationArea = All;
                Caption = 'Non MOQ';
                ToolTip = 'Specifies the values of Non MOQ for Item';
                Visible = MOQField;
            }
        }
        addafter("Location Code")
        {

            field("Batch/Serial Number"; Rec."Batch/Serial Number")
            {
                ApplicationArea = All;
                Caption = 'Batch/Serial No.';
                ToolTip = 'Specifies the values of batch/serial number filed';
                Visible = ShowCustomField;
            }
            field("CMC/AMC Start Date"; Rec."CMC/AMC Start Date")
            {
                ApplicationArea = All;
                Caption = 'Contract Start Date';
                ToolTip = 'Specifies the values of CMC/AMC start date filed';
                Visible = ShowCustomField;
            }
            field("CMC/AMC End Date"; Rec."CMC/AMC End Date")
            {
                ApplicationArea = All;
                Caption = 'Contract End Date';
                ToolTip = 'Specifies the values of CMC/AMC end date filed';
                Visible = ShowCustomField;
            }

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
            field("Inst SR No."; Rec."Inst SR No.")
            {
                ApplicationArea = All;
                Caption = 'Instrument Serial No.';
                Visible = ClaimCustomField;
            }
            field("Inst. Model"; Rec."Inst. Model")
            {
                ApplicationArea = All;
                Caption = 'Instrument Model No.';
                Visible = ClaimCustomField;
            }
            field("Installation Date"; Rec."Installation Date")
            {
                ApplicationArea = All;
                Caption = 'Installation Date';
                Visible = ClaimCustomField;
            }
            field("Warranty/Service Period"; Rec."Warranty/Service Period")
            {
                ApplicationArea = All;
                Caption = 'Warranty/Service Period';
                Visible = ShowCustomField;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        Clear(TotalGSTAmount);
        Clear(TotalIncGST);
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Document No.", Rec."Document No.");
        if SalesInvoiceLine.FindSet() then
            repeat
                TotalGSTAmount += SalesInvoiceLine."SGST Amount" + SalesInvoiceLine."CGST Amount" + SalesInvoiceLine."IGST Amount";
            until SalesInvoiceLine.Next() = 0;

        TotalIncGST := TotalSalesInvoiceHeader.Amount + TotalGSTAmount;
        SetVisibilty();
    end;

    var
        TotalGSTAmount: Decimal;
        TotalIncGST: Decimal;
        DocumentTotals: Codeunit "Document Totals";
        ShowCustomField: Boolean;
        ClaimCustomField: Boolean;
        ShowStandardField: Boolean;
        MOQField: Boolean;
        SalesInvoiceHeader: Record "Sales Invoice Header";

    trigger OnAfterGetRecord()
    begin
        SetVisibilty();
    end;

    trigger OnOpenPage()
    begin
        SetVisibilty();
    end;

    procedure SetVisibilty()
    begin
        if SalesInvoiceHeader.Get(Rec."Document No.") then begin
            // if (SalesInvoiceHeader."Sales Order Type" = 'Sales Order AMC') or (SalesInvoiceHeader."Sales Order Type" = 'Sales Order CMC') or (SalesInvoiceHeader."Sales Order Type" = 'Service Order') then begin
            if (SalesInvoiceHeader."AMC Order") or (SalesInvoiceHeader."CMC Order") or (SalesInvoiceHeader."Service Order") then begin
                ShowStandardField := false;
                ClaimCustomField := false;
                ShowCustomField := true;
                MOQField := true;
            end
            else if SalesInvoiceHeader."Claim Order" then begin
                ShowCustomField := false;
                ShowStandardField := true;
                ClaimCustomField := true;
                MOQField := false;
            end
            else if SalesInvoiceHeader."Spare Order" then begin
                ShowStandardField := false;
                ClaimCustomField := false;
                ShowCustomField := false;
                MOQField := true;
            end
            else begin
                ShowCustomField := false;
                ShowStandardField := true;
                ClaimCustomField := false;
                MOQField := false;
            end
        end
        else begin
            ShowCustomField := false;
            ShowStandardField := true;
            ClaimCustomField := false;
            MOQField := false;
        end;
    end;
}
