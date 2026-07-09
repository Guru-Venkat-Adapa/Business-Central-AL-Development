namespace Toshvin.Toshvin;

using Microsoft.Purchases.History;

pageextension 50084 "Posted Purchase Receipts" extends "Posted Purchase Receipts"
{
    layout
    {
        // addafter("No.")
        // {
        //     field("Purchase Order Type"; Rec."Purchase Order Type")
        //     {
        //         ApplicationArea = All;
        //     }
        // }
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }

    }
}
