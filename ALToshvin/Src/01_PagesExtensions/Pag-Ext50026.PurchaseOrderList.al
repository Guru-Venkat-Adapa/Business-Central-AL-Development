namespace Toshvin.Toshvin;

using Microsoft.Purchases.Document;

pageextension 50026 "Purchase Order List" extends "Purchase Order List"
{
    layout
    {
        addafter("No.")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
            }
            field("Purchase Order Type"; Rec."Purchase Order Type")
            {
                ApplicationArea = All;
            }
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        moveafter("Purchase Order Type"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        moveafter("Shortcut Dimension 2 Code"; "Buy-from Vendor No.")
        moveafter("Buy-from Vendor No."; "Buy-from Vendor Name")
        moveafter("Buy-from Vendor Name"; "Location Code")
        addafter("Location Code")
        {
            field("Vendor Invoice No."; Rec."Vendor Invoice No.")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Vendor Invoice No."; Status)
        moveafter(Status; "Posting Date")
        addafter("Posting Date")
        {
            field("Total Amount Excl. GST"; Rec."Total Amount Excl. GST")
            {
                ApplicationArea = All;
            }
            field("GST Amount"; Rec."GST Amount")
            {
                ApplicationArea = all;
            }
        }
        moveafter("GST Amount"; Amount)
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
        modify("Amount Including VAT")
        {
            Visible = false;
        }
    }
    actions
    {
        addafter(Post)
        {
            action(DND)
            {
                ApplicationArea = All;
                Caption = 'DND';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                trigger OnAction()
                var
                    SalesLine: Record "Purchase Line";
                begin
                    SalesLine.Reset();
                    if SalesLine.FindSet() then
                        repeat
                            SalesLine."Total GST Amount" :=
                                SalesLine."SGST Amount" + SalesLine."CGST Amount" + SalesLine."IGST Amount";
                            SalesLine.Modify();
                        until SalesLine.Next() = 0;
                    Message('Total GST Amount updated for existing Sales Lines.');
                end;
            }
        }
        addbefore(AttachAsPDF)
        {
            action(PurchOrderPrint1)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purch order Print';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    PuchHeader: Record "Purchase Header";
                begin
                    PuchHeader.Reset();
                    PuchHeader.SetRange("Document Type", PuchHeader."Document Type"::Order);
                    PuchHeader.SetRange("No.", Rec."No.");
                    if PuchHeader.FindFirst() then
                        if PuchHeader."Purchase Type" = PuchHeader."Purchase Type"::Domestic then
                            Report.RunModal(Report::CustomPurchaseOrder, true, false, PuchHeader)
                        else
                            if PuchHeader."Purchase Type" = PuchHeader."Purchase Type"::Import then
                                Report.RunModal(Report::ImportPurchaseOrder, true, false, PuchHeader)
                            else
                                Report.RunModal(Report::CustomPurchaseOrder, true, false, PuchHeader)
                end;
            }
        }
        // addlast(Category_Category5)
        // {
        //     actionref("PrintName1"; PurchOrderPrint1) { }
        // }
    }
}
