page 50045 "Custom Duty Setup"
{
    ApplicationArea = All;
    Caption = 'Custom Duty Setup';
    PageType = List;
    SourceTable = "Custom Duty Setup";
    UsageCategory = Lists;
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Group; Rec.Group)
                {
                    ApplicationArea = All;
                }
                field("Custom Duty Sucharge Perc."; Rec."Custom Duty Sucharge Perc.")
                {
                    ApplicationArea = All;
                }
                field("IGST Percentage"; Rec."IGST Percentage")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
