pageextension 50066 "Sales Invoice Subform" extends "Sales Invoice Subform"
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
            }
        }
        //TBC-823 <---
        //TBC - 835 --->
        modify("Line No.")
        {
            Visible = true;
            Editable = false;
        }
        movebefore("No."; "Line No.")
        //TBC - 835 <---
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
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
            field("Warranty/Service Period"; Rec."Warranty/Service Period")
            {
                ApplicationArea = All;
                Caption = 'Warranty/Service Period';
                Visible = InstFields;
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
            field(MOQ; Rec."MOQ")
            {
                ApplicationArea = All;
                Caption = 'MOQ';
                ToolTip = 'Specifies the values of MOQ for Item';
                Visible = MOQField;
            }
        }
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
        //TBC - 898 <--
        modify("GST Jurisdiction Type")
        {
            Editable = false;
        }
        //TBC - 898  -->
    }
    trigger OnAfterGetRecord()
    begin
        SetVisibility();
    end;

    trigger OnAfterGetCurrRecord()
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
    begin
        //28/07/2025 guru
        SetVisibility();
    end;

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
        ShowCustomField: Boolean;
        IsEditable: Boolean;
        TotalGSTAmount: Decimal;
        ShowStandardField: Boolean;
        ClaimCustomField: Boolean;
        SparesFields: Boolean;
        MOQField: Boolean;
        InstFields: Boolean;
        SalesHeader: Record "Sales Header";
}
