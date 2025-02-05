pageextension 50134 "Test Role Center Ext" extends "Test Role Center"
{
    layout
    {
        addfirst(rolecenter)
        {
            part(Customer; Sales)
            {
                ApplicationArea = All;
            }
        }
    }
}
