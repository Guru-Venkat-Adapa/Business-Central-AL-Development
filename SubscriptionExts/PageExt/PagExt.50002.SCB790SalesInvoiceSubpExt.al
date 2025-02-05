/// <summary>
/// PageExtension SCB 790 SalesInvoiceSubp Ext. (ID 50002) extends Record Posted Sales Invoice Subform.
/// </summary>
pageextension 50002 "SCB 790 SalesInvoiceSubp Ext." extends "Posted Sales Invoice Subform"
{

    layout
    {
        // Add changes to page layout here
        addlast(Content)
        {
            field("SCB Subscription No."; Rec."SCB Subscription No.")
            {
                ApplicationArea = All;
                Visible = ShowSubscription;
                ToolTip = 'Specifies SCB Subscription No.';

            }
            field("SCB Subscription Line No."; Rec."SCB Subscription Line No.")
            {
                ApplicationArea = All;
                Visible = ShowSubscription;
                ToolTip = 'Specifies SCB Subscription Line No.';
            }
            field("SCB Subscription Info"; Rec."SCB Subscription Info")
            {
                ApplicationArea = All;
                Visible = ShowSubscription;
                ToolTip = 'Specifies SCB Subscription Info';
            }
        }
    }

    var
        ShowSubscription: Boolean;

    trigger OnOpenPage()
    var
        NotificationAppMgt: Codeunit "SCB 790 Notific. Management";
    begin
       //ShowSubscription := NotificationAppMgt.IsAppEnabled();
    end;

}