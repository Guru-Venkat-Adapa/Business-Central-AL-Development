pageextension 50105 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter("Qty. on Purch. Order")
        {
            field("Qty. on Blanket Puch Order"; Rec."Qty. on Blanket Puch Order")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies how many units of the item are inbound on blanket purchase orders, meaning listed on outstanding purchase order lines.';
            }
            field("Qty. to Recive Bl Puch Order"; Rec."Qty. to Recive Bl Puch Order")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies how many units of the item are remaing to inbound on blanket purchase orders, meaning listed on outstanding purchase order lines.';
            }
        }
        addafter("Qty. on Sales Order")
        {
            field("Qty. on Blanket Sales Order"; Rec."Qty. on Blanket Sales Order")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies how many units of the item are allocated to blanket sales orders, meaning listed on outstanding sales orders lines.';
            }
            field("Qty. to Recive Bl Sales Order"; Rec."Qty. to Recive Bl Sales Order")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies how many units of the item are remaining to be allocated to blanket sales orders, meaning listed on outstanding sales order lines.';
            }
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'GST Prod. Posting Group';
        }
        modify(CalcUnitPriceExclVAT)
        {
            CaptionClass = 'Unit Price Excl. GST';
        }
        modify("Price Includes VAT")
        {
            Caption = 'Price Includes GST';
        }
    }
}
