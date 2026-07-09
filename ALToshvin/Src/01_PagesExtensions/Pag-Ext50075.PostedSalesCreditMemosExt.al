pageextension 50075 "Posted Sales Credit Memos Ext" extends "Posted Sales Credit Memos"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        //TBC-1069 ---->

        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
        moveafter("Due Date"; "Shortcut Dimension 1 Code")
        addbefore("Shortcut Dimension 1 Code")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                Caption = 'Customer PO#';
            }
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field(DepartmentName; DepartmentName)
            {
                ApplicationArea = All;
                Caption = 'Department Name';
            }
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
        moveafter(DepartmentName; "Shortcut Dimension 2 Code")
        addafter("Shortcut Dimension 2 Code")
        {
            field(RegionName; RegionName)
            {
                ApplicationArea = All;
                Caption = 'Region Name';
            }
        }
        addafter(RegionName)
        {
            field(CustLedgerEntry; CustLedgerEntry."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Caption = 'Teams Code';
            }
            field(TeamsName; TeamsName)
            {
                ApplicationArea = All;
                Caption = 'Teams Name';
            }
        }
        modify("Applies-to Doc. Type")
        {
            Visible = true;
        }


        addafter(TeamsName)
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
            }
            field("Reference Invoice No."; Rec."Reference Invoice No.")
            {
                ApplicationArea = All;
            }

            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
            }
            //TBC-1072 -->
            field("Applies-to ID"; Rec."Applies-to ID")
            {
                ApplicationArea = All;
                Caption = 'Applies-to ID';
                Editable = false;
            }
            //TBC-1072 <---
            field("Credit Note Type"; Rec."Credit Note Type")
            {
                ApplicationArea = All;
            }
            field("Location State Code"; Rec."Location State Code")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Reference Invoice No."; "Applies-to Doc. Type")
        addafter("Location Code")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            //TBC-1069 <----
        }
    }
    trigger OnAfterGetRecord()
    begin
        //TBC-1069 ---->
        Clear(DepartmentName);
        Clear(RegionName);
        Clear(TeamsName);

        DimesionValue.Reset();
        DimesionValue.SetRange(Code, Rec."Shortcut Dimension 1 Code");
        if DimesionValue.FindFirst() then
            DepartmentName := DimesionValue.Name;

        DimesionValue.Reset();
        DimesionValue.SetRange(Code, Rec."Shortcut Dimension 2 Code");
        if DimesionValue.FindFirst() then
            RegionName := DimesionValue.Name;

        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Customer No.", Rec."Sell-to Customer No.");
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Credit Memo");
        CustLedgerEntry.SetRange("Document No.", Rec."No.");
        if CustLedgerEntry.FindFirst() then begin
            CustLedgerEntry.CalcFields(CustLedgerEntry."Shortcut Dimension 3 Code");
            ShortcutDimension3Code := CustLedgerEntry."Shortcut Dimension 3 Code";
            DimesionValue.Reset();
            DimesionValue.SetRange(Code, ShortcutDimension3Code);
            if DimesionValue.FindFirst() then
                TeamsName := DimesionValue.Name;
        end;
        //TBC-1069 <----
    end;

    var

        DimesionValue: Record "Dimension Value";
        DepartmentName: Text;
        RegionName: Text;
        TeamsName: Text;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ShortcutDimension3Code: Code[20];
}

