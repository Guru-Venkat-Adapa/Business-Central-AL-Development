pageextension 50104 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field(OriginalCopy; Rec.OriginalCopy)
            {
                ApplicationArea = All;
                Caption = 'Original Copy';
            }
        }
    }
}
