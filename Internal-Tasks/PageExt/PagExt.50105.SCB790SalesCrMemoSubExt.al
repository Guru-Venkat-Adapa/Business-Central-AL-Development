/// <summary>
/// PageExtension SCB 790 SalesCrMemoSub Ext. (ID 50003) extends Record Posted Sales Cr. Memo Subform.
/// </summary>
pageextension 50105 "SCB 790 SalesCrMemoSub Ext." extends "Posted Sales Cr. Memo Subform"

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
    begin
        ShowSubscription := false;
    end;
}