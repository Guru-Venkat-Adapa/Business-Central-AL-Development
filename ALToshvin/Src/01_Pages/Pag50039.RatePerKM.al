page 50039 "Rate Per KM"
{
    ApplicationArea = All;
    Caption = 'Rate Per KM';
    PageType = List;
    SourceTable = "Rate Per KM";
    UsageCategory = Lists;

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
                field("Per KM Rate"; Rec."Per KM Rate")
                {
                    ToolTip = 'Specifies the value of the Per KM Rate field.', Comment = '%';
                }
            }
        }
    }
}
