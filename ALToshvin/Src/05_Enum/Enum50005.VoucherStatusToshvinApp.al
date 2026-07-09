namespace Toshvin.Toshvin;

enum 50005 "Voucher Status Toshvin App"
{
    Extensible = true;

    value(0; "Draft")
    {
        Caption = 'Draft';
    }
    value(1; "Pending Finance Approval")
    {
        Caption = 'Pending Finance Approval';
    }
    value(2; "Error")
    {
        Caption = 'Error';
    }
    value(3; "Pending Approval")
    {
        Caption = 'Pending Approval';
    }
    value(4; "Approved")
    {
        Caption = 'Approved';
    }
    value(5; "Rejected")
    {
        Caption = 'Rejected';
    }
    value(6; "Finance Approved")
    {
        Caption = 'Finance Approved';
    }
    value(7; "Finance Rejected")
    {
        Caption = 'Finance Rejected';
    }

}
