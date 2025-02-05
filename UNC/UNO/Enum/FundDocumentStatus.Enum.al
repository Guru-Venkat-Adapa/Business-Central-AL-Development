enum 50103 "Fund Document Status"
{
    Extensible = true;

    value(0; Open) { Caption = 'Open'; }
    value(1; Released) { Caption = 'Released'; }
    value(2; "Pending Approval") { Caption = 'Pending Approval'; }
    value(3; "Pending Prepayment") { Caption = 'Approval Rejected'; }
}