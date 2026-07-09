pageextension 50015 PostedSalesInvoiceList extends "Posted Sales Invoices"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        addafter("No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order Type field.';
            }
        }

        //TBC-1052 --->
        modify("No.")
        {
            Caption = 'Document No.';
        }
        modify(Amount)
        {
            Caption = 'Taxable Amount';
        }
        modify("External Document No.")
        {
            Visible = true;
            Caption = 'Customer PO No.';
            ApplicationArea = ALl;
        }
        moveafter("Sell-to Customer Name"; "External Document No.")
        addafter("External Document No.")
        {
            field("Customer PO Date"; Rec."Customer PO Date")
            {
                ApplicationArea = All;
                Caption = 'Customer PO Date';
            }
        }
        //TBC-1052 <---

        //TBC-960 --->
        addafter("Sell-to Customer Name")
        {
            field(DepartmentName; DepartmentName)
            {
                ApplicationArea = All;
                Caption = 'Department Name';
            }
            field(RegionName; RegionName)
            {
                ApplicationArea = All;
                Caption = 'Region Name';
            }
            field(TeamsName; TeamsName)
            {
                ApplicationArea = All;
                Caption = 'Teams Name';
            }
            field("Executive Master"; Rec."Executive Master")
            {
                ApplicationArea = All;
            }
            field("Executive Master2"; Rec."Executive Master2")
            {
                ApplicationArea = All;
            }
            field("CMC_Service Type"; Rec."Service_Type_")
            {
                ApplicationArea = All;
                Caption = 'Service Type';
            }
        }
        modify("Amount Including VAT")
        {
            Visible = false;
        }
        addafter(Amount)
        {

            field("Total Incl. VAT"; GetCorrectTotalInclVAT())
            {
                ApplicationArea = All;
                Caption = 'Total Incl. VAT';
                Editable = false;
                ToolTip = 'Matches Total Incl. VAT from document page.';
            }

        }
        //TBC-960 <---
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."Location Code" <> '' then
                Rec.SetRange("Location Code", UserSetup."Location Code");
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        //TBC-960 --->
        Clear(RegionName);
        Clear(DepartmentName);
        Clear(TeamsName);

        Dimension.Reset();
        Dimension.SetRange(Code, Rec."Shortcut Dimension 1 Code");
        if Dimension.FindFirst() then
            DepartmentName := Dimension.Name;

        Dimension.Reset();
        Dimension.SetRange(Code, Rec."Shortcut Dimension 2 Code");
        if Dimension.FindFirst() then
            RegionName := Dimension.Name;


        Dimension.Reset();
        Dimension.SetRange(Code, Rec."Shortcut Dimension 3 Code");
        if Dimension.FindFirst() then
            TeamsName := Dimension.Name;



        //TBC-960 <---
    end;

    local procedure GetCorrectTotalInclVAT(): Decimal
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        GSTAmount: Decimal;
    begin

        Rec.CalcFields(Amount);

        GSTAmount := 0;

        // Get GST total from ledger (values are negative)
        DetailedGSTLedgerEntry.Reset();
        DetailedGSTLedgerEntry.SetRange("Document No.", Rec."No.");
        DetailedGSTLedgerEntry.SetRange("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                GSTAmount += DetailedGSTLedgerEntry."GST Amount";
            until DetailedGSTLedgerEntry.Next() = 0;

        // ✅ FINAL CALCULATION (Correct for India GST)
        exit(Rec.Amount - GSTAmount);
    end;

    var

        SalesInvHeader: Record "Sales Invoice Header";
        Dimension: Record "Dimension Value";
        RegionName: Text;
        DepartmentName: Text;
        TeamsName: Text;
        DetGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        SalesInvoiceLine: Record "Sales Invoice Line";
        InvoiceAmount: Decimal;
        GrandInvoiceAmt: Decimal;

}
