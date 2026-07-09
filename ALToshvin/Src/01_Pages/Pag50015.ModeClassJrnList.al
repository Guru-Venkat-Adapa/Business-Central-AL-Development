namespace Toshvin.Toshvin;

page 50015 "Mode/Class Jrn List"
{
    ApplicationArea = All;
    Caption = 'Mode/Class Jrn List';
    PageType = List;
    SourceTable = "Mode/Class Jrn";
    UsageCategory = Lists;
    RefreshOnActivate = true;
    SourceTableView = order(ascending);

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
