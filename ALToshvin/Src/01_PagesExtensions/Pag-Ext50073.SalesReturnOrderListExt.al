pageextension 50073 "Sales Return Order List Ext" extends "Sales Return Order List"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
    }
}
