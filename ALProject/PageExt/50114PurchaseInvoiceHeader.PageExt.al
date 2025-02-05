pageextension 50114 "Purchase Invoice Header Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter("Vendor Invoice No.")
        {
           field("Temp Text"; Rec."Temp Text")
            {
                Caption = 'Temporary Text';
                ApplicationArea = All;
            }
        }
    }
}