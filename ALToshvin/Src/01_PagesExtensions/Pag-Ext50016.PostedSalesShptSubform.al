namespace Toshvin.Toshvin;

using Microsoft.Sales.History;

pageextension 50016 "Posted Sales Shpt. Subform" extends "Posted Sales Shpt. Subform"
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
        //TBC-823 <---
        //TBC - 835 -->
        addbefore("No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
            }
        }
        //TBC - 835 <----
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        addafter("Quantity Invoiced")
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
        addafter("Shipment Date")
        {
            field(MOQ; Rec."MOQ Quantity")
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
    var
        ShowCustomField: Boolean;
        ClaimCustomField: Boolean;
        ShowStandardField: Boolean;
        MOQField: Boolean;
        SalesShipmentHeader: Record "Sales Shipment Header";

    trigger OnAfterGetRecord()
    begin
        SetVisibilty();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetVisibilty();
    end;

    trigger OnOpenPage()
    begin
        SetVisibilty();
    end;

    procedure SetVisibilty()
    begin
        if SalesShipmentHeader.Get(Rec."Document No.") then begin
            // if (SalesShipmentHeader."Sales Order Type" = 'Sales Order AMC') or (SalesShipmentHeader."Sales Order Type" = 'Sales Order CMC') or (SalesShipmentHeader."Sales Order Type" = 'Service Order') then begin
            if (SalesShipmentHeader."AMC Order") or (SalesShipmentHeader."CMC Order") or (SalesShipmentHeader."Service Order") then begin
                ShowStandardField := false;
                ClaimCustomField := false;
                ShowCustomField := true;
                MOQField := true;
            end
            else if SalesShipmentHeader."Claim Order" then begin
                ShowCustomField := false;
                ShowStandardField := true;
                ClaimCustomField := true;
                MOQField := false;
            end
            else if SalesShipmentHeader."Spare Order" then begin
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
