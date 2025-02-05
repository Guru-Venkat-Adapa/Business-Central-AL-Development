pageextension 50205 "Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        addafter(PurchLines)
        {
            part(Payment; "Payment part for Purch Order")
            {
                ApplicationArea = Suite;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
        }
    }
    // trigger OnOpenPage()
    // var
    //     VendorLedEntry: Record "Vendor Ledger Entry";
    //     PosedPuchInv: Record "Purch. Inv. Header";
    // begin
    //     PosedPuchInv.Get(Rec."No.");
    //     VendorLedEntry.get(PosedPuchInv."Order No.");
    //     If VendorLedEntry.Open= true then begin
    //         Message(Format(VendorLedEntry.pay));
    //     end;
    // end;
}
