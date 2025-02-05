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
    var myInt: Integer;
}
