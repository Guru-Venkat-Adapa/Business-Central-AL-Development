page 50026 "Sales Order Type List"
{
    ApplicationArea = All;
    Caption = 'Sales Order Type List';
    PageType = List;
    SourceTable = "Sales Order Type";
    UsageCategory = Lists;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field("Sales Order Type"; Rec."Sales Order Type")
                {
                    ToolTip = 'Specifies the value of the Sales Order Type field.', Comment = '%';
                }
            }
        }
    }
}
