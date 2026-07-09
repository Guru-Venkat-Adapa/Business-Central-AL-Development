namespace Toshvin.Toshvin;

page 50007 "Freight Term Lists"
{
    ApplicationArea = All;
    Caption = 'Freight Term Lists';
    PageType = List;
    SourceTable = "Freight Term";
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
                    ToolTip = 'Specifies the value of the Freight Term field.', Comment = '%';
                }
            }
        }
    }
}
