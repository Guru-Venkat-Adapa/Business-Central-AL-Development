pageextension 50104 "Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    //TBC-905 ---->
    layout
    {
        //TBC-1056 --->
        addafter("Document No.")
        {
            field(PurchaseOrderNo; PurchaseOrderNo)
            {
                ApplicationArea = All;
                Caption = 'Purchase Order No.';
                Editable = false;
            }
        }
        //TBC-1056 <---

        modify("Remaining Amount")
        {
            Caption = 'Opening Balance';
        }
        addafter("Vendor No.")
        {
            field(MSMEVendorType; MSMEVendorType)
            {
                ApplicationArea = All;
                Caption = 'Is MSME Vendor';
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
        addafter("TDS Section Code")
        {
            field(TDSAmount; TDSAmount)
            {
                ApplicationArea = All;
                Caption = 'TDS Amount';
                Editable = false;
            }
        }
        addafter("Payment Method Code")
        {
            field(ChequeNo; ChequeNo)
            {
                ApplicationArea = All;
                Caption = 'Cheque No.';
                Editable = false;
            }
            field(BankName; BankName)
            {
                ApplicationArea = All;
                Caption = 'Bank Name';
                Editable = false;
            }
            field(AccountNo; AccountNo)
            {
                ApplicationArea = All;
                Caption = 'Account No.';
                Editable = false;
            }
            field(IFSCCode; IFSCCode)
            {
                ApplicationArea = All;
                Caption = 'IFSC Code';
                Editable = false;
            }
            field("Beneficiary Name"; Rec."Beneficiary Name")
            {
                ApplicationArea = All;
                Caption = 'Beneficiary Name';
            }
        }
        addafter("Location GST Reg. No.")
        {
            field(Comment; Comment)
            {
                ApplicationArea = All;
                Caption = 'Comment';
                Editable = false;
            }
            field(Voucher; Voucher)
            {
                ApplicationArea = All;
                Caption = 'Voucher';
                Editable = false;
            }
            field(LineVoucher; LineVoucher)
            {
                ApplicationArea = All;
                Caption = 'Line Voucher';
                Editable = false;
            }

        }

    }



    trigger OnAfterGetRecord()
    var
    begin

        if Vend.Get(Rec."Vendor No.") then
            if Vend."Is MSME" then
                MSMEVendorType := true
            else
                MSMEVendorType := false;

        Clear(RegionName);
        Clear(DepartmentName);
        Clear(TeamsName);
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

        TDSAmount := 0;
        TDSEntry.Reset();
        TDSEntry.SetRange("Document No.", Rec."Document No.");
        if TDSEntry.FindFirst() then
            TDSAmount := TDSEntry."TDS Amount";

        Clear(ChequeNo);
        Clear(BankName);
        Clear(AccountNo);
        Clear(IFSCCode);
        BankAccountLedgerEntry.Reset();
        BankAccountLedgerEntry.SetRange("Document Type", BankAccountLedgerEntry."Document Type"::Payment);
        BankAccountLedgerEntry.SetRange("Document No.", Rec."Document No.");
        if BankAccountLedgerEntry.FindFirst() then begin
            ChequeNo := BankAccountLedgerEntry."Cheque No.";
            if BankAccount.Get(BankAccountLedgerEntry."Bank Account No.") then begin
                BankName := BankAccount.Name;
                AccountNo := BankAccount."Bank Account No.";
                IFSCCode := BankAccount."IFSC Code";
            end
        end;

        Clear(Voucher);
        Clear(LineVoucher);
        PostedNarration.Reset();
        PostedNarration.SetRange("Transaction No.", Rec."Transaction No.");
        PostedNarration.SetRange("Entry No.", 0);
        if PostedNarration.FindFirst() then
            Voucher := PostedNarration.Narration;

        PostedNarration.Reset();
        PostedNarration.SetRange("Transaction No.", Rec."Transaction No.");
        PostedNarration.SetRange("Entry No.", Rec."Entry No.");
        if PostedNarration.FindFirst() then
            LineVoucher := PostedNarration.Narration;


        //TBC-995 --->
        Clear(Comment);
        if Rec."Document Type" = Rec."Document Type"::Invoice then
            if Rec."Document No." <> '' then
                if PurchInvHeader.Get(Rec."Document No.") then begin
                    PurchCommentLine.Reset();
                    PurchCommentLine.SetRange("Document Type", PurchCommentLine."Document Type"::"Posted Invoice");
                    PurchCommentLine.SetRange("No.", PurchInvHeader."No.");
                    PurchCommentLine.SetRange("Document Line No.", 0);
                    if PurchCommentLine.FindSet() then
                        repeat
                            if Comment = '' then
                                Comment := PurchCommentLine.Comment
                            else
                                Comment := Comment + ' ' + PurchCommentLine.Comment;
                        until PurchCommentLine.Next() = 0;
                end;
        //TBC-995 <---

        //TBC-1056 --->
        Clear(PurchaseOrderNo);
        PurchaseInvoiceHeader.Reset();
        PurchaseInvoiceHeader.SetRange("No.", Rec."Document No.");
        if PurchaseInvoiceHeader.FindFirst() then
            PurchaseOrderNo := PurchaseInvoiceHeader."Order No.";
        //TBC-1056 <---
    end;

    var
        Dimension: Record "Dimension Value";
        RegionName: Text;
        DepartmentName: Text;
        TeamsName: Text;
        TDSEntry: Record "TDS Entry";
        TDSAmount: Decimal;
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        ChequeNo: Code[10];
        BankAccount: Record "Bank Account";
        BankName: Text;
        AccountNo: Text;
        IFSCCode: Text;
        Vend: Record Vendor;
        MSMEVendorType: Boolean;
        Voucher: Text;
        LineVoucher: Text;
        PostedNarration: Record "Posted Narration";
        Comment: Text; //TBC-995
        PurchInvHeader: Record "Purch. Inv. Header";//TBC-995
        PurchCommentLine: Record "Purch. Comment Line";

        PurchaseInvoiceHeader: Record "Purch. Inv. Header";
        PurchaseOrderNo: Code[20];

    //TBC-905 <----

}
