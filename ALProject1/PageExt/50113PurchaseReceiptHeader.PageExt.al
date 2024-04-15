pageextension 50113 "Purchase Receipt Header Ext" extends "Posted Purchase Receipt"
{
    layout
    {
        // Add changes to page layout here
        addafter("Responsibility Center")
        {
            field("Temp Text"; Rec."Temp Text")
            {
                Caption = 'Temporary Text';
                ApplicationArea = All;
            }
        }
    }
}