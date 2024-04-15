/// <summary>
/// PageExtension SCB 790 Item Card (ID 50000) extends Record Item Card.
/// </summary>
pageextension 50102 "SCB 790 Item Card" extends "Item Card"
{
    actions
    {
        addlast(navigation)
        {
            group("SCB Subscription Management")
            {
                Caption = 'Subscription';
                Visible = ShowSubscription;
                Image = BlanketOrder;

                action("SCB Item Text Translation")
                {
                    ApplicationArea = All;
                    Image = Translations;
                    Caption = 'Subscription Text Translation';
                    ToolTip = 'Setup translations of the subscription text that is generated on the subscription invoice.';
                    // RunObject = page "SCB Item Subscr. Texts";
                    // RunPageLink = "Item No." = field("No.");
                }
            }
        }
    }
    var
        ShowSubscription: Boolean;

    trigger OnOpenPage()
    var
    // NotificationAppMgt: Codeunit "SCB 790 Notific. Management";
    begin
        //ShowSubscription := NotificationAppMgt.IsAppEnabled();
    end;
}