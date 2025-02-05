page 50106 "Sales"
{
    Caption = 'Sales';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = SalesOpenDocuments;
    layout
    {
        area(Content)
        {
            cuegroup(Group1)
            {
                Caption = 'Open Documents';
                field("Sales Quote"; Rec."Sales Quote")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Quote';
                    DrillDownPageId = "Sales Quotes";
                }
                field("Sales Order"; Rec."Sales Order")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Order';
                    DrillDownPageId = "Sales Orders";
                    Style = Attention;
                }
                field("Sales Invoice"; Rec."Sales Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Invoice';
                    DrillDownPageId = "Sales Invoice List";
                }
            }
            cuegroup(Group2)
            {
                Caption = 'Released Documents';
                field("Sales Quote Released"; Rec."Sales Quote Released")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Quote';
                    DrillDownPageId = "Sales Quotes";
                }
                field("Sales Order Released"; Rec."Sales Order Released")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Order';
                    DrillDownPageId = "Sales Orders";
                    Style = Unfavorable;
                }
                field("Sales Invoice Released"; Rec."Sales Invoice Released")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Invoice';
                    DrillDownPageId = "Sales Invoice List";
                }
            }
        }
    }
    var
        rport: Report 393;
}
