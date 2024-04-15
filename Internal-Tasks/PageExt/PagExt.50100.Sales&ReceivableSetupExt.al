pageextension 50100 "Sale & Recive Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here
        addlast("Number Series")
        {
            field(MRS; Rec.MRS)
            {
                Caption = 'MRS No. Series';
                ApplicationArea = All;
            }
            field(PRS; Rec.PRS)
            {
                Caption = 'Prs No. Series';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}