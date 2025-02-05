pageextension 50102 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Export Excel Data"; Rec."Export Excel Data")
            {
                ApplicationArea = All;
                Caption = 'Export Excel Data';
                ToolTip = 'Specifes the No. Series for Excel Exporting Data';
            }
        }
    }
}
