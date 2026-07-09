pageextension 50056 "Item Tracking Lines Ext" extends "Item Tracking Lines"
{
    layout
    {
        addbefore("Quantity (Base)")
        {
            field("Bin Code"; Rec."Bin Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the bin where the items are picked or put away.';
            }
        }
    }
}
