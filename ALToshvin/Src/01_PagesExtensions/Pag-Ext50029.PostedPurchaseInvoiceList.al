namespace Toshvin.Toshvin;

using Microsoft.Purchases.History;

pageextension 50029 "Posted Purchase Invoices" extends "Posted Purchase Invoices"
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

    }
}
