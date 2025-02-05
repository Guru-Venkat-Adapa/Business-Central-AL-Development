pageextension 50115 "SalesOrderList" extends "Sales Order List"
{
    actions
    {
        modify("Email Confirmation")
        {
            Visible = false;
        }
        addafter("Email Confirmation")
        {
            action("Email Confirmation Custom")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Email Confirmation';
                Ellipsis = true;
                Image = Email;
                ToolTip = 'Send an order confirmation by email. The Send Email window opens prefilled for the customer so you can add or change information before you send the email.';

                trigger OnAction()
                var
                    Evgmgt: Codeunit "Event Managment";
                begin
                    Evgmgt.SendOrderConfirmation(Rec);
                end;
            }
        }
    }
    views
    {
        addafter(ShippedNotInvoiced)
        {
            view(Stages)
            {
                Caption = 'Stages Filters';
            }
            view(AwaitingPayment)
            {
                Caption = 'Awaiting Payment';
                Filters = where("Document Type"=filter(Order), Stages=filter('Awaiting Payment'));
            }
            view(PendingFraudLabsapprovals)
            {
                Caption = 'Pending FraudLabs approvals';
                Filters = where("Document Type"=filter(Order), Stages=filter('Pending FraudLabs approvals'));
            }
            view(NeedsThirdPartyShipping)
            {
                Caption = 'Needs Third Party Shipping';
                Filters = where("Document Type"=filter(Order), Stages=filter('Needs Third Party Shipping'));
            }
            view(ThirdpartyShippingAwaitingPickUp)
            {
                Caption = 'Third party Shipping Awaiting Pick Up';
                Filters = where("Document Type"=filter(Order), Stages=filter('Third party Shipping Awaiting Pick Up'));
            }
            view(OnlocaldeliveryNeedtoinformcustomer)
            {
                Caption = 'On local delivery-Need to inform customer';
                Filters = where("Document Type"=filter(Order), Stages=filter('On local delivery-Need to inform customer'));
            }
            view(OnlocaldeliverycustomerinformedREADY)
            {
                Caption = 'On local delivery-customer informed READY';
                Filters = where("Document Type"=filter(Order), Stages=filter('On local delivery-customer informed READY'));
            }
            view(PraparePickUps)
            {
                Caption = 'Prapare Pick Ups';
                Filters = where("Document Type"=filter(Order), Stages=filter('Prapare Pick Ups'));
            }
            view(NeedsPickup)
            {
                Caption = 'Needs Pickup';
                Filters = where("Document Type"=filter(Order), Stages=filter('Needs Pickup'));
            }
            view(WarrantyPartsandServicing)
            {
                Caption = 'Warranty - Parts and Servicing';
                Filters = where("Document Type"=filter(Order), Stages=filter('Warranty - Parts and Servicing'));
            }
            view(WaitingforStock)
            {
                Caption = 'Waiting for Stock';
                Filters = where("Document Type"=filter(Order), Stages=filter('Waiting for Stock'));
            }
            view(LocalInstallationTIMEREQUIRED)
            {
                Caption = 'Local Installation - TIME REQUIRED';
                Filters = where("Document Type"=filter(Order), Stages=filter('Local Installation - TIME REQUIRED'));
            }
            view(LocalInstallationTIMESET)
            {
                Caption = 'Local Installation - TIME SET';
                Filters = where("Document Type"=filter(Order), Stages=filter('Local Installation - TIME SET'));
            }
            view(CommercialInstallationTIMEREQUIRED)
            {
                Caption = 'Commercial Installation - TIME REQUIRED';
                Filters = where("Document Type"=filter(Order), Stages=filter('Commercial Installation - TIME REQUIRED'));
            }
            view(CommercialInstallationTIMESET)
            {
                Caption = 'Commercial Installation - TIME SET';
                Filters = where("Document Type"=filter(Order), Stages=filter('Commercial Installation - TIME SET'));
            }
            view(OnHold)
            {
                Caption = 'On Hold';
                Filters = where("Document Type"=filter(Order), Stages=filter('On Hold'));
            }
            view(READInternalCommentsMultipleactions)
            {
                Caption = 'READ Internal Comments Multiple actions';
                Filters = where("Document Type"=filter(Order), Stages=filter('READ Internal Comments Multiple actions'));
            }
            view(Dispatchedview)
            {
                Caption = 'Dispatched';
                Filters = where("Document Type"=filter(Order), Stages=filter('Dispatched'));
            }
            view(Preordersview)
            {
                Caption = 'Pre-orders';
                Filters = where("Document Type"=filter(Order), Stages=filter('Pre-orders'));
            }
            view(PreordersAwaitingPayment)
            {
                Caption = 'Pre-orders-Awaiting Payment';
                Filters = where("Document Type"=filter(Order), Stages=filter('Pre-orders-Awaiting Payment'));
            }
            view(ReleaseToPickWMS)
            {
                Caption = 'Release To Pick-WMS';
                Filters = where("Document Type"=filter(Order), Stages=filter('Release To Pick-WMS'));
            }
            view(ReadyToPackWMS)
            {
                Caption = 'Ready To Pack-WMS';
                Filters = where("Document Type"=filter(Order), Stages=filter('Ready To Pack-WMS'));
            }
            view(PartiallyPicked)
            {
                Caption = 'Partially Picked';
                Filters = where("Document Type"=filter(Order), Stages=filter('Partially Picked'));
            }
        }
    }
    var myInt: Integer;
}
