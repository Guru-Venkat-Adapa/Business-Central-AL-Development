enum 50108 "SCB 790 Subscr Create Invoice"
{
    Caption = 'SCB 790 Subscription Create Invoice - InvoicePer';
    Extensible = true;

    value(0; "")
    {
        Caption = '';
    }
    value(1; Customer)
    {
        Caption = 'Customer';
    }
    value(2; Subscription)
    {
        Caption = 'Subscription';
    }
    value(3; Line)
    {
        Caption = 'Line';
    }
}