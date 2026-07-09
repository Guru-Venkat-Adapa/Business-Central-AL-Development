pageextension 50095 "Customer Ledger Entries" extends "Customer Ledger Entries"
{
    //TBC - 904  ---->
    layout
    {
        //TBC-947 --->
        addafter("Certificate Received")
        {
            field("UTR/Cheque No."; Rec."UTR/Cheque No.")
            {
                ApplicationArea = All;
                Caption = 'UTR/Cheque No.';
                Editable = false;
            }
            field("Comment"; Rec."Comment")
            {
                Caption = 'Comment';
                Editable = false;
                ApplicationArea = All;
            }
        }
        //TBC-947 <---
        modify("Customer Name")
        {
            Visible = false;
        }
        addafter("Document No.")
        {
            field(SalesOrderNo; SalesOrderNo)
            {
                ApplicationArea = All;
                Caption = 'Sales Order No.';
                Editable = false;
            }
        }
        addafter("Customer No.")
        {
            field(CustomerName; CustomerName)
            {
                ApplicationArea = All;
                Caption = 'Customer Name';
                Editable = false;
            }
        }
        addafter("Global Dimension 1 Code")
        {
            field(DepartmentName; DepartmentName)
            {
                ApplicationArea = All;
                Caption = 'Department Name';
                Editable = false;
            }
        }
        addafter("Global Dimension 2 Code")
        {
            field(RegionName; RegionName)
            {
                ApplicationArea = All;
                Caption = 'Region Name';
                Editable = false;
            }
        }
        addafter("Shortcut Dimension 3 Code")
        {
            field(TeamsName; TeamsName)
            {
                ApplicationArea = All;
                Caption = 'Teams Name';
                Editable = false;
            }
        }
        addafter("Certificate Received")
        {
            field(ChequeNo; ChequeNo)
            {
                ApplicationArea = All;
                Caption = 'Cheque No.';
                Editable = false;
            }
        }
        addafter("Amount")
        {
            field(TDSAmt; TDSAmt)
            {
                ApplicationArea = All;
                Caption = 'TDS Amount';
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(RegionName);
        Clear(DepartmentName);
        Clear(CustomerName);
        Clear(SalesOrderNo);
        Clear(ChequeNo);
        Clear(TeamsName);
        Clear(TDSAmt);

        if Cust.Get(Rec."Customer No.") then
            CustomerName := Cust."Name";

        Dimension.Reset();
        Dimension.SetRange(Code, Rec."Global Dimension 1 Code");
        if Dimension.FindFirst() then
            DepartmentName := Dimension.Name;

        Dimension.Reset();
        Dimension.SetRange(Code, Rec."Global Dimension 2 Code");
        if Dimension.FindFirst() then
            RegionName := Dimension.Name;

        Dimension.Reset();
        Dimension.SetRange(Code, Rec."Shortcut Dimension 3 Code");
        if Dimension.FindFirst() then
            TeamsName := Dimension.Name;

        if Rec."Document Type" = Rec."Document Type"::Invoice then begin
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SetRange("No.", Rec."Document No.");
            if SalesInvoiceHeader.FindFirst() then
                SalesOrderNo := SalesInvoiceHeader."Order No.";
        end;

        if Rec."Document Type" = Rec."Document Type"::Payment then begin
            BankAccountLedgerEntry.Reset();
            BankAccountLedgerEntry.SetRange("Document No.", Rec."Document No.");
            if BankAccountLedgerEntry.FindFirst() then
                ChequeNo := BankAccountLedgerEntry."Cheque No.";
        end;

        TDSSetup.Reset();
        TDSSetup.SetFilter("TDS Receivable Account", '<>%1', '');
        if TDSSetup.FindSet() then begin
            repeat
                GLEntry.Reset();
                GLEntry.SetRange("Document No.", Rec."Document No.");
                GLEntry.SetRange("G/L Account No.", TDSSetup."TDS Receivable Account");
                if GLEntry.FindSet() then begin
                    TDSAmt += GLEntry.Amount;
                end;
            until TDSSetup.Next() = 0;
        end;
    end;

    var
        CustomerName: Text;
        Cust: Record Customer;
        Dimension: Record "Dimension Value";
        RegionName: Text;
        DepartmentName: Text;
        TeamsName: Text;
        SalesOrderNo: Code[20];
        SalesInvoiceHeader: Record "Sales Invoice Header";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        ChequeNo: Code[20];
        GLEntry: Record "G/L Entry";
        TDSSetup: Record "TDS Posting Setup"; // if available
        TDSAmt: Decimal;

    //TBC - 904  <----
}
