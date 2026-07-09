pageextension 50076 "Posted Sales Credit Memo Ext" extends "Posted Sales Credit Memo"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        //TBC-1034 ---->
        addbefore("Salesperson Code")
        {
            field("Credit Note Type"; Rec."Credit Note Type")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        //TBC-1034 <----

        //TBC-1069 --->
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
            Caption = 'Department Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
            Caption = 'Region Code';
        }
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        addafter("Shortcut Dimension 2 Code")
        {
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Caption = 'Teams Code';
                Editable = false;
            }
        }
        addafter("Cancel Reason")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
        //TBC-1069 <---

        //TBC-1042 --->
        addafter(General)
        {
            group(CMC)
            {
                Caption = 'Service';
                Editable = false;
                Visible = ServiceTab;
                field("CMC_Service Type"; Rec."Service_Type_")
                {
                    ApplicationArea = All;
                    Caption = 'Service Type';
                }
                field("CMC_Service Description"; Rec."Service Description")
                {
                    ApplicationArea = All;
                    Caption = 'Service Description';
                }
                field("CMC_No. of visits"; Rec."No. of visit")
                {
                    ApplicationArea = All;
                    Caption = 'No. of Visits';
                }
                field("CMC_Visit Date"; Rec."Visit Date")
                {
                    ApplicationArea = All;
                    Caption = 'Visit Date';
                }
                field("CMC_Invoice Term"; Rec."Invoice Term")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Term';
                }
                field("Service CRM Employee ID 1"; Rec."Executive Master")
                {
                    ApplicationArea = All;
                    Caption = 'Service Person ID';
                    ToolTip = 'Specifies the value of the CRM Employee ID 1 field.';
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                }
            }
        }
        //TBC-1042 <---

        //TBC-1072 --->
        addafter("Applies-to Doc. No.")
        {
            field("Applies-to ID"; Rec."Applies-to ID")
            {
                ApplicationArea = All;
                Caption = 'Applies-to ID';
                Editable = false;
            }
        }
        //TBC-1072 <---
    }

    //TBC-1042 --->
    trigger OnOpenPage()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        InvoiceNo: Code[20];
    begin
        ServiceTab := false;

        if Rec."Applies-to Doc. No." <> '' then
            InvoiceNo := Rec."Applies-to Doc. No."
        else
            if Rec."Reference Invoice No." <> '' then
                InvoiceNo := Rec."Reference Invoice No.";

        if InvoiceNo <> '' then begin
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SetRange("No.", InvoiceNo);
            if SalesInvoiceHeader.FindFirst() then
                if (SalesInvoiceHeader."Sales Order Type" = 'SERVICES') or
                   (SalesInvoiceHeader."Sales Order Type" = 'CMC') or
                   (SalesInvoiceHeader."Sales Order Type" = 'AMC') then
                    ServiceTab := true;
        end;
    end;

    //TBC-1042 <---

    var
        ServiceTab: Boolean;
}
