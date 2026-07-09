namespace Toshvin.Toshvin;

page 50022 "No Series Selection for Purch"
{
    ApplicationArea = All;
    Caption = 'No Series Selection for Purch';
    PageType = List;
    SourceTable = "No Series for Purchase";
    UsageCategory = Lists;
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Purchase Order No. Series"; Rec."Purchase Order No. Series")
                {
                    ToolTip = 'Specifies the value of the Purchase Order No. Series field.', Comment = '%';
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ToolTip = 'Specifies the value of the Posting No. Series field.', Comment = '%';
                }
                field("Receiving No. Series"; Rec."Receiving No. Series")
                {
                    ToolTip = 'Specifies the value of the Receiving No. Series field.', Comment = '%';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ToolTip = 'Specifies the value of the Item Category Code field.', Comment = '%';
                }
                field("Ven Gen Bus Pos Group"; Rec."Ven Gen Bus Pos Group")
                {
                    ToolTip = 'Specifies the value of the Ven Gen Bus Pos Group field.', Comment = '%';
                }
            }
        }
    }
}
