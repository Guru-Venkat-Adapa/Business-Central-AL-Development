pageextension 50104 OrderProcessorRoleCenterExt extends "Order Processor Role Center"
{
    layout
    {
        addafter(ApprovalsActivities)
        {
            part(PuchAnalysisCuePage; PuchAnalysisCuePage)
            {
                ApplicationArea = All;
            }
        }
    }
}
