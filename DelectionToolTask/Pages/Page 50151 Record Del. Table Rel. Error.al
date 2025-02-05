page 50101 "Record Del. Table Rel. Error"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Records Del. Table Rel. Error";
    AccessByPermission = page "Record Del. Table Rel. Error" = x;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = All;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                }
                field(Error; Rec.Error)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}