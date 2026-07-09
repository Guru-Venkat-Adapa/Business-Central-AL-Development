pageextension 50069 "Sales Invoice List Ext" extends "Sales Invoice List"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
    }
}
