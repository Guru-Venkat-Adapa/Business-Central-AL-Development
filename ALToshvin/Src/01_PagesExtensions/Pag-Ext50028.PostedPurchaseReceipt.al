namespace Toshvin.Toshvin;

using Microsoft.Purchases.History;

pageextension 50028 "Posted Purchase Receipt" extends "Posted Purchase Receipt"
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
            field("AWB No."; Rec."AWB No.")
            {
                ApplicationArea = All;
                Caption = 'AWB No.';
                Editable = false;
            }
            field("AWB Date"; Rec."AWB Date")
            {
                ApplicationArea = All;
                Caption = 'AWB Date';
                Editable = false;
            }
            field("Bill of Entry No."; Rec."Bill of Entry No.")
            {
                ApplicationArea = All;
                Caption = 'Bill of Entry No.';
                Editable = false;
            }
            field("Bill of Entry Date"; Rec."Bill of Entry Date")
            {
                ApplicationArea = All;
                Caption = 'Bill of Entry Date';
                Editable = false;
            }
            field("Vendor Bill No."; Rec."Vendor Bill No.")
            {
                ApplicationArea = All;
                Caption = 'Vendor Bill No.';
                Editable = false;
            }
            field("Vendor Bill Date"; Rec."Vendor Bill Date")
            {
                ApplicationArea = All;
                Caption = 'Vendor Bill Date';
                Editable = false;
            }
            field("BL No."; Rec."BL No.")
            {
                ApplicationArea = All;
                Caption = 'BL No.';
                Editable = false;
            }
            field("BL Date"; Rec."BL Date")
            {
                ApplicationArea = All;
                Caption = 'BL Date';
                Editable = false;
            }
        }
        //TBC-1060 --->
        addafter("Vendor Order No.")
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
}
