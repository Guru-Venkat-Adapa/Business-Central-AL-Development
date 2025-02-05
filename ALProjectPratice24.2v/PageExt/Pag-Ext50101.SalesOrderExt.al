pageextension 50101 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {
            // field(InvoiceAmt; Rec.InvoiceAmt)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Invoice Amount';
            //     Editable = false;
            // }
            // field(BalanceAmt; Rec.BalanceAmt)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Balance Amount';
            //     Editable = false;
            // }
            // field(TotalAmt; Rec.TotalAmt)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Total Amount';
            //     Editable = false;

            // }
            field("Order Margin"; Rec."Order Margin")
            {
                ApplicationArea = All;
                Caption = 'Order Margin';
            }
        }
    }
    actions
    {
        // addafter("Archive Document")
        // {
        //     action(GetShipmentData)
        //     {
        //         ApplicationArea = All;
        //         Promoted = true;
        //         PromotedCategory = Category10;
        //         // trigger OnAction()
        //         // var
        //         //     Code: Codeunit "CustomFieldLineTransfer";
        //         // begin
        //         //     Code.TransferCustomFieldFromSales(Rec);
        //         //     Code.TransferCustomFieldFromSales1(Rec);
        //         // end;
        //     }
        // }
    }
    // trigger OnOpenPage()
    // var
    //     SalesLine: Record "Sales Line";
    //     InvoiceValue: Decimal;
    //     TotalValue: Decimal;
    // begin
    //     Rec.TotalAmt := 0;
    //     rec.BalanceAmt := 0;
    //     Rec.InvoiceAmt := 0;
    //     SalesLine.SetRange("Document No.", Rec."No.");
    //     SalesLine.SetRange("Document Type", Rec."Document Type");
    //     if SalesLine.FindSet() then begin
    //         repeat
    //             InvoiceValue := SalesLine."Quantity Invoiced" * SalesLine."Unit Price";
    //             TotalValue := SalesLine."Amount Including VAT";
    //             Rec.InvoiceAmt += InvoiceValue;
    //             Rec.TotalAmt += TotalValue;
    //         until SalesLine.Next() = 0;
    //         Rec.BalanceAmt := Rec.TotalAmt - Rec.InvoiceAmt;
    //         Rec.Modify(true);
    //     end;
    // end;
    // trigger OnAfterGetRecord()
    // begin
    //     Rec.BalanceAmt := Rec.TotalAmt - Rec.InvoiceAmt;
    //     Rec.Modify(true);
    // end;
}
