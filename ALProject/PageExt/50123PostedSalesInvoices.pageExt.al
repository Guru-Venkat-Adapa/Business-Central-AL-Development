pageextension 50123 "Posted Sales Invoices Ext" extends "Posted Sales Invoices"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Invoice")
        {
            action(Exportdata)
            {
                Caption = 'Export Data';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Export;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Xmlport.Run(50102, true, false);
                end;
            }
        }
    }

    var
        myInt: Integer;
}