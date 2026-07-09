pageextension 50020 "Purchase Order List Ext" extends "Purchase Order List"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
    }
    actions
    {
        addbefore(AttachAsPDF)
        {
            action(PurchOrderPrint)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purch order Print';
                Ellipsis = true;
                Image = Print;
                // Promoted = true;
                // PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    PuchHeader: Record "Purchase Header";
                begin
                    PuchHeader.Reset();
                    PuchHeader.SetRange("Document Type", PuchHeader."Document Type"::Order);
                    PuchHeader.SetRange("No.", Rec."No.");
                    if PuchHeader.FindFirst() then
                        Report.RunModal(Report::CustomPurchaseOrder, true, false, PuchHeader);
                end;
            }
        }
        // addlast(Category_Category5)
        // {
        //     actionref("PrintName"; PurchOrderPrint) { }
        // }
    }
}
