pageextension 50081 "Purchase Invoices Ext" extends "Purchase Invoices"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
    }
}
