page 50043 "Service Type"
{
    ApplicationArea = All;
    Caption = 'Service Type';
    PageType = List;
    SourceTable = ServiceType;
    UsageCategory = Administration;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Service Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Service Code field.', Comment = '%';
                }
                field("Service Description"; Rec."Service Name")
                {
                    ToolTip = 'Specifies the value of the Service Name field.', Comment = '%';
                }
            }
        }
    }
}
