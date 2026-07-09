page 50006 "Delivery Terms Lists"
{
    ApplicationArea = All;
    Caption = 'Delivery Terms Lists';
    PageType = List;
    SourceTable = "Delivery Terms";
    UsageCategory = Lists;
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
            }
        }
    }
}
