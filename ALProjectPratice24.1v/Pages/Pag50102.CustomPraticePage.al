page 50102 "Custom Pratice Page"
{
    ApplicationArea = All;
    Caption = 'Custom Pratice Page';
    PageType = List;
    SourceTable = "Custom Pratice";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
            }
        }
        area(FactBoxes)
        {
            part("Document Attachment"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(3),
                "No." = field("No.");
            }
        }
    }
}
