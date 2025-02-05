pageextension 50107 SalesRec extends "Sales & Receivables Setup"
{
    actions
    {
        // Add changes to page actions here
        addafter("Rounding Methods")
        {
            action("Tracking Setup")
            {
                ApplicationArea = All;
                Caption = 'Tracking Setup';
                Image = Track;
                Promoted = true;
                RunObject = page "Order Tracking Setup";
            }
        }
    }
}
