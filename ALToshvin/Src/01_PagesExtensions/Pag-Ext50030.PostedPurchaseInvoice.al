namespace Toshvin.Toshvin;

using Microsoft.Purchases.History;

pageextension 50030 "Posted Purchase Invoice" extends "Posted Purchase Invoice"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        addafter("No.")
        {
            field("Purchase Order Type"; Rec."Purchase Order Type")
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field("Sales Type"; Rec."Purchase Type")
            {
                ApplicationArea = All;
                Caption = 'Purchase Type';
                Editable = false;
            }
            field("Folio No."; Rec."Folio No.")
            {
                ApplicationArea = All;
                Caption = 'Folio No.';
                Editable = false;
            }
            // field("Transportation Chg."; Rec."Transportation Chg.")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Transportation Charge';
            // }

            field("Delivery Terms"; Rec."Delivery Terms")
            {
                ApplicationArea = All;
                Caption = 'Delivery Terms';
            }
            field("Supplier Quote No."; Rec."Supplier Quote No.")
            {
                ApplicationArea = All;
                Caption = 'Supplier Quote No.';
            }
            field("Supplier Quote Date"; Rec."Supplier Quote Date")
            {
                ApplicationArea = All;
                Caption = 'Supplier Quote Date';
            }
            field(Warranty; Rec.Warranty)
            {
                ApplicationArea = All;
                Caption = 'Warranty';
            }
        }

        //TBC-1060 --->
        addafter("Vendor Invoice No.")
        {
            field("Vendor Invoice Date"; Rec."Vendor Invoice Date")
            {
                ApplicationArea = All;
                Caption = 'Vendor Invoice Date';
                Editable = false;
            }
        }
        //TBC-1060 <---

    }

    actions
    {
        //TBC-1025 ---->
        addafter(AttachAsPDF)
        {
            action("RCM Tax Invoice")
            {
                ApplicationArea = All;
                Caption = 'RCM Tax Invoice';
                Promoted = true;
                PromotedCategory = Category6;
                Image = PrintReport;
                Visible = RCMTax;

                trigger OnAction()
                var
                    RCMTax: Report "RCM Tax Invoice";
                    PurInvHeader: Record "Purch. Inv. Header";
                begin
                    PurInvHeader.Reset();
                    PurInvHeader.SetRange("No.", Rec."No.");
                    if PurInvHeader.FindFirst() then
                        Report.Run(Report::"RCM Tax Invoice", true, false, PurInvHeader);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
    begin
        PurInvLine.Reset();
        PurInvLine.SetRange("Document No.", Rec."No.");
        PurInvLine.SetRange("GST Reverse Charge", true);
        if PurInvLine.FindFirst() then
            RCMTax := true
        else
            RCMTax := false;

    end;

    var
        PurInvLine: Record "Purch. Inv. Line";
        RCMTax: Boolean;


    //TBC-1025 <----
}
