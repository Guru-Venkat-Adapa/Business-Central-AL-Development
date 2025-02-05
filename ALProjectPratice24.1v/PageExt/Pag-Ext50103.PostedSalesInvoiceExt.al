pageextension 50103 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Custom Amount (LCY)"; Rec."Custom Amount (LCY)")
            {
                ApplicationArea = All;
                Caption = 'Customer Amount(LCY)';
                ToolTip = 'Specifies the Quantity to ship amount';
                Editable = false;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(PrintbyEmail)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print By Email';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                // Visible = not IsOfficeAddin;

                trigger OnAction()
                var

                    SalesInvoice: Record "Sales Invoice Header";
                begin
                    SalesInvoice.Reset();
                    SalesInvoice.SetRange(SalesInvoice."No.", Rec."No.");
                    SalesInvoice.SetRange(SalesInvoice."Bill-to Customer No.", Rec."Bill-to Customer No.");
                    if SalesInvoice.FindFirst() then begin
                        Report.RunModal(Report::"Posted Sales Invoice Email", true, true, SalesInvoice);
                    end;
                end;
            }
        }
    }
    var
        test: Record "Sales Invoice Header";
}
