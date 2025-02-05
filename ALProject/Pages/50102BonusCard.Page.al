page 50102 "Bonus Card"
{
    PageType = Document;
    SourceTable = "bonus Header";
    Caption = 'Bonus Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies bonus number';
                    Caption = 'No.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Customer No.';
                    Caption = 'Customer No.';
                    DrillDownPageId = "Customer Card";
                }
                field("Sarting Date"; Rec."Sarting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Staring Date ';
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
                    ToolTip = 'Specifies Bonus Status';
                    Caption = 'Status';
                }
            }
            part(Lies; "Bonus Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
        area(FactBoxes)
        {
            part(Image; "Customer Picture")
            {
                ApplicationArea = All;
                Caption = 'Image';
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
            action("Bonus Enties")
            {
                ApplicationArea = All;
                Caption = 'Bonus Entites';
                Image = Entry;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Bonus Entries";
                RunPageLink = "Bonus No." = field("No.");
                ToolTip = 'Opens bonus entries';
            }
        }
    }
}