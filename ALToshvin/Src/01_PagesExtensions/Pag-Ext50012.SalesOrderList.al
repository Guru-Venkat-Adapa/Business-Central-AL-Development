pageextension 50012 SalesOrderList extends "Sales Order List"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        addafter("No.")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
            }
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order Type field.';
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
        moveafter("Sales Order Type"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        moveafter("Shortcut Dimension 2 Code"; "Sell-to Customer No.")
        moveafter("Sell-to Customer No."; "Sell-to Customer Name")
        moveafter("Sell-to Customer Name"; "Location Code")
        moveafter("Location Code"; "External Document No.")
        moveafter("External Document No."; Status)
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
            field(IncAmount; TotalInclGST)
            {
                ApplicationArea = All;
                Caption = 'Amount';
                ToolTip = 'Calculated as GST Amount + Total Amount Excl. GST from lines.';
            }
        }
        modify("External Document No.")
        {
            Caption = 'Customer PO No.';
        }
        modify(Amount)
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Completely Shipped")
        {
            Visible = false;
        }
        modify("Amt. Ship. Not Inv. (LCY) Base")
        {
            Visible = false;
        }
        modify("Amt. Ship. Not Inv. (LCY)")
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
        addlast("P&osting")
        {
            action(DeleteAllSalesData)
            {
                ApplicationArea = All;
                Caption = 'Delete All Sales Data';
                Image = Delete;
                Visible = false;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                begin
                    if not Confirm('This will delete ALL Sales Headers and Sales Lines. Continue?') then
                        exit;

                    // Delete all sales lines first
                    SalesLine.Reset();
                    if SalesLine.FindSet() then
                        SalesLine.DeleteAll();

                    // Delete all sales headers
                    SalesHeader.Reset();
                    if SalesHeader.FindSet() then
                        SalesHeader.DeleteAll();

                    Message('All Sales Headers and Sales Lines have been deleted.');
                end;
            }
            action(DeleteEmptySO)
            {
                ApplicationArea = All;
                Caption = 'Delete SO with empty Customer';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange("Sell-to Customer No.", '');
                    if SalesHeader.FindSet(true) then begin
                        repeat
                            SalesLine.Reset();
                            SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                            SalesLine.SetRange("Document No.", SalesHeader."No.");
                            if SalesLine.FindSet(true) then
                                SalesLine.DeleteAll(true);
                            SalesHeader.Delete(true);
                        until SalesHeader.Next() = 0;
                    end;
                end;

            }
        }
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
        Clear(TotalInclGST);
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No."); // Make sure this matches Sales Header's "No."
        if SalesLine.FindSet() then
            repeat
                TotalInclGST += SalesLine."Total GST Amount" + SalesLine."Amount Including VAT";
            until SalesLine.Next() = 0;
    end;


    var
        SalesLine: Record "Sales Line";
        TotalInclGST: Decimal;


}
