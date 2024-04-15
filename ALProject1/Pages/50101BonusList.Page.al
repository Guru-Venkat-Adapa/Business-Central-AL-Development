page 50101 "Bonus List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "bonus Header";
    Caption = 'Bonus List';
    Editable = true;
    CardPageId="Bonus Card";
    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Bonus No.';
                    Caption = 'No.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer No.';
                    Caption = 'Customer No.';
                }
                field("Sarting Date"; Rec."Sarting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Starting Date';
                    Caption = 'Starting Date';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Ending Date';
                    Caption = 'Ending Date';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bonus Status';
                    Caption = 'Status';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Customer Card")
            {
                ApplicationArea = All;
                Caption = 'Customer Card';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Customer Card";
                RunPageLink = "No." = field("Customer No.");
                ToolTip = 'Open Customer Card';
            }
        }
    }
}