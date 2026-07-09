pageextension 50103 "General Ledger Entries" extends "General Ledger Entries"
{
    //TBC-978 -->
    layout
    {
        modify("Source Type")
        {
            Visible = true;
        }
        modify("Source No.")
        {
            Visible = true;
        }
        moveafter("Document No."; "Source Type")
        moveafter("Source Type"; "Source No.")

        addafter("Source No.")
        {

            field(VendorName; VendorName)
            {
                ApplicationArea = All;
                Caption = 'Name';
                Editable = false;
            }
        }
        addafter("Shortcut Dimension 3 Code")
        {

            field(Comment; Comment)
            {
                ApplicationArea = All;
                Caption = 'Sales Line Comment';
                Editable = false;
            }
            field(Narration; Narration)
            {
                ApplicationArea = All;
                Caption = 'Narration';
                Editable = false;
            }
            field(LineNarration; LineNarration)
            {
                ApplicationArea = All;
                Caption = 'Line Narration';
                Editable = false;
            }
        }
        //TBC-1010 --->
        addafter("Bal. Account No.")
        {
            field("UTR/Cheque No."; Rec."UTR/Cheque No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(StandardComment; Rec.Comment)
            {
                Caption = 'Comment';
                ApplicationArea = All;
                Editable = false;
            }
        }
        //TBC-1010 <---
    }
    trigger OnAfterGetRecord()
    var
    begin
        Clear(VendorName);
        Clear(Narration);
        Clear(LineNarration);
        if Rec."Source Type" = Rec."Source Type"::Vendor then begin
            if Vend.Get(Rec."Source No.") then
                VendorName := Vend.Name;
        end else if Rec."Source Type" = Rec."Source Type"::Customer then begin
            if Cust.Get(Rec."Source No.") then
                VendorName := Cust.Name;
        end;

        PostedNarration.Reset();
        PostedNarration.SetRange("Transaction No.", Rec."Transaction No.");
        PostedNarration.SetRange("Entry No.", 0);
        PostedNarration.SetRange("Document No.", Rec."Document No.");
        if PostedNarration.FindFirst() then
            Narration := PostedNarration.Narration;

        LinePostedNarration.Reset();
        LinePostedNarration.SetRange("Transaction No.", Rec."Transaction No.");
        LinePostedNarration.SetRange("Entry No.", Rec."Entry No.");
        LinePostedNarration.SetRange("Document No.", Rec."Document No.");
        if LinePostedNarration.FindFirst() then
            LineNarration := LinePostedNarration.Narration;

        //TBC-996 ----->
        Clear(Comment);

        if (Rec."Document Type" = Rec."Document Type"::Invoice) and
           (Rec."Document No." <> '') then begin
            if SalesInvHeader.Get(Rec."Document No.") then begin
                SalesCommentLine.Reset();
                SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::"Posted Invoice");
                SalesCommentLine.SetRange("No.", SalesInvHeader."No.");
                SalesCommentLine.SetRange("Document Line No.", 0);
                if SalesCommentLine.FindSet() then
                    repeat
                        if Comment = '' then
                            Comment := SalesCommentLine.Comment
                        else
                            Comment := Comment + ' ' + SalesCommentLine.Comment;
                    until SalesCommentLine.Next() = 0;
            end;
        end;//TBC-996 <-----

        //TBC-1027 --->
        if (Rec."Document Type" = Rec."Document Type"::Invoice) AND (Rec."Source Type" = Rec."Source Type"::Vendor)
        then begin
            PurchCommentLine.Reset();
            PurchCommentLine.SetRange("Document Type", PurchCommentLine."Document Type"::"Posted Invoice");
            PurchCommentLine.SetRange("No.", Rec."Document No.");
            if PurchCommentLine.FindFirst() then
                Rec.Comment := PurchCommentLine.Comment;
        end;
        //TBC-1027 <---
    end;

    var
        VendorName: Text;
        Vend: Record Vendor;
        PostedNarration: Record "Posted Narration";
        LinePostedNarration: Record "Posted Narration";
        Narration: Text;
        LineNarration: Text;
        Cust: Record Customer;
        Comment: Text; //TBC-996
        SalesInvHeader: Record "Sales Invoice Header";//TBC-996
        SalesCommentLine: Record "Sales Comment Line";//TBC-996
        PurchCommentLine: Record "Purch. Comment Line"; //TBC-1027


    //TBC-978 <--
}
