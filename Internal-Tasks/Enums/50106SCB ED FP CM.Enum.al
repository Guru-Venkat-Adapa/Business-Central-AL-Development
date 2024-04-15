enum 50106 "SCB 790 ED FP CM"
{
    Caption = 'SCB 790 End Date First Period Calcuation Method';
    Extensible = true;
    value(0; "")
    {
        Caption = '';
        // locked=true;
    }
    value(1; "End Current Period")
    {
        Caption = 'End Current Period';
    }
    value(2; "End Month")
    {
        Caption = 'End Month';
    }
    value(3; "Actual Period Length")
    {
        Caption = 'Actual Period Length';
        ObsoleteState = Pending;
        ObsoleteReason = 'Value is incorporated into business logic';
    }
    value(4; "Manual Calculation")
    {
        Caption = 'Manual Calcuation';
    }
}