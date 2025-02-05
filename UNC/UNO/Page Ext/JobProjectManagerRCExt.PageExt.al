pageextension 50103 "Job Project Manager RC Ext" extends "Job Project Manager RC"
{
    actions
    {
        addafter(Resources)
        {
            action(FundTransfer)
            {
                Caption = 'Fund Transfer';
                ApplicationArea = All;
                ToolTip = 'Manages the Fund Transfer records.';
                RunObject = page "Fund Transfer List";
            }
        }
    }
}
