page 50021 "No Series Selection for Sales"
{
    ApplicationArea = All;
    Caption = 'No Series Selection for Sales';
    PageType = List;
    SourceTable = "No Series for Sales";
    UsageCategory = Lists;
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sales Order Type"; Rec."Sales Order Type")
                {
                    ToolTip = 'Specifies the value of the Sales Order Type field.', Comment = '%';
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ToolTip = 'Specifies the value of the Posting No. Series field.', Comment = '%';
                }
                field("Shipping No. Series"; Rec."Shipping No. Series")
                {
                    ToolTip = 'Specifies the value of the Shipping No. Series field.', Comment = '%';
                }
            }
        }
    }
}
