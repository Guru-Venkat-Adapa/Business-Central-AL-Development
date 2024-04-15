pageextension 50106 "posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter(Closed)
        {
            field("Name Text"; Rec."Name Text")
            {
                ApplicationArea = All;
                Caption = 'Text For Name';
            }
        }
    }


}