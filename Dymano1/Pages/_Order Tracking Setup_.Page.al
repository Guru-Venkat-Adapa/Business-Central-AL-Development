page 50101 "Order Tracking Setup"
{
    ApplicationArea = all;
    Caption = 'Order Tracking Setup';
    DeleteAllowed = true;
    InsertAllowed = true;
    PageType = Card;
    SourceTable = "Tracking Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(MainFreight)
            {
                Caption = 'Main Freight Setup';

                field("Mainfrieght_URL"; Rec."Mainfrieght URL")
                {
                    ApplicationArea = All;
                    Caption = 'Mainfrieght URL';
                }
                field("Mainfrieght_API_Key"; Rec."Mainfrieght API Key")
                {
                    ApplicationArea = All;
                    Caption = 'Mainfrieght API Key';
                }
            }
            group(TNT)
            {
                Caption = 'TNT (Fedex) Setup';

                field(TNT_URL; Rec."TNT URL")
                {
                    ApplicationArea = All;
                    Caption = 'TNT URL';
                }
                field(TNT_API_Key; Rec."TNT API Key")
                {
                    ApplicationArea = All;
                    Caption = 'TNT API Key';
                }
            }
            group(AurPost)
            {
                Caption = 'Aus Post Setup';

                field(AusPost_URL; Rec."AusPost URL")
                {
                    ApplicationArea = All;
                    Caption = 'AusPost URL';
                }
                field(AusPost_API_Key; Rec."AusPost API Key")
                {
                    ApplicationArea = All;
                    Caption = 'AusPost API Key';
                }
            }
            group(EmailNotificationSetup)
            {
                Caption = 'Email Notification Setup';

                field("Send Delevery Email"; Rec."Send Delevery Update")
                {
                    ApplicationArea = All;
                    Caption = 'Send Delevery Email';
                    ToolTip = 'if mark this as TRUE then Once Product is deliverd Email Notification is send to Customer Email';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SendStatus)
            {
                ApplicationArea = All;
                Caption = 'Send Delivery Status';
                Image = Delivery;

                trigger OnAction()
                var
                    shopifyOrderId: Text;
                    CU: Codeunit "Auto ExplodBOM";
                begin
                    shopifyOrderId:='6031047688295';
                    CU.GetTimeLine(shopifyOrderId);
                end;
            }
        }
    }
}
