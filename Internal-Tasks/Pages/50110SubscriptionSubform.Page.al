page 50110 "Subscription Subform"
{
    Caption = 'Subscription Lines';
    PageType = ListPart;
    // MultipleNewLines = true;
    AutoSplitKey = true;
    // LinksAllowed = false;
    // DelayedInsert = true;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = filter("Blanket Order"));
    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies the type';
                    ShowMandatory = true;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the line number';
                    ShowMandatory = true;
                    trigger OnValidate()
                    var
                        SubscriptionSetup: Record "Subscription Setup";
                        Val: Text;
                    begin
                        // ShortcutDimCode();
                        // Rec."SCB Invoicing Frequency DF" := Format(SubscriptionSetup."SCB Sales Days per Month");
                        Val := '30D';
                        Evaluate(Rec."SCB Invoicing frequency DF", Val);
                        // Message(Format(Rec."SCB Invoicing frequency DF"));
                    end;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Caption = 'Variant Code';
                    ToolTip = 'Specifies the Variant Code of item in the line';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Caption = 'Gen. Prod. Posting Group';
                    ToolTip = 'Specifies the Gen. Prod. Posting Group';
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Prod. Posting Group';
                    ToolTip = 'Specifies the VAT Prod. Posting Group';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the Description';
                    ShowMandatory = true;
                    trigger OnValidate()
                    var
                        Val: text;
                    begin
                        // ShortcutDimCode();
                        Val := '30D';
                        Evaluate(Rec."SCB Invoicing frequency DF", Val);
                    end;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Caption = 'Description 2';
                    ToolTip = 'Specifies the Description 2';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'Location Code';
                    ToolTip = 'Specifies the Location Code';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the Quantity';
                    BlankZero = true;
                    ShowMandatory = true;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Caption = 'Unit of Measure Code';
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'Unit of Measure';
                    ToolTip = 'Specifies the Unit of Measure';
                    Visible = false;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Cost (LCY)';
                    ToolTip = 'Specifies the Unit Cost (LCY)';
                    Visible = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Price';
                    ToolTip = 'Specifies the Unit Price';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    Caption = 'Line Discount %';
                    ToolTip = 'Specifies the Line Discount %';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Line Amount';
                    ToolTip = 'Specifies the Line Amount';
                }
                field("SCB Starting Date"; Rec."SCB Starting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date';
                    ToolTip = 'Specifies the SCB Starting Date';
                    ShowMandatory = true;

                }
                field("SCB Invoicing Frequency"; Rec."SCB Invoicing Frequency")
                {
                    ApplicationArea = All;
                    Caption = 'SCB Invoicing Frequency';
                    ToolTip = 'Specifies the SCB Invoicing Frequency';
                    Visible = false;
                    // obsolete
                }
                field("SCB Invoicing Frequency DF"; Rec."SCB Invoicing Frequency DF")
                {
                    ApplicationArea = All;
                    Caption = 'Invoicing Frequency';
                    ToolTip = 'Specifies the SCB Invoicing Frequency DF';
                }
                field("SCB End Date First Period"; Rec."SCB End Date First Period")
                {
                    ApplicationArea = All;
                    Caption = 'End Date First Period';
                    ToolTip = 'Specifies End Date First Period';
                }
                field("SCB Next Invoicing Date"; Rec."SCB Next Invoicing Date")
                {
                    ApplicationArea = All;
                    Caption = 'Next Invoicing Date';
                    ToolTip = 'Specifies Next Invoicing Date';
                    trigger OnValidate()
                    begin

                    end;
                }
                field("SCB Ending Date"; Rec."SCB Ending Date")
                {
                    ApplicationArea = All;
                    Caption = 'Ending Date';
                    ToolTip = 'Specifies Ending Date';
                }
                field("Deferral Code"; Rec."Deferral Code")
                {
                    ApplicationArea = All;
                    Caption = 'Deferral Code';
                    ToolTip = 'Specifies Deferral Code';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Line Discount Amount';
                    ToolTip = 'Specifies Line Discount Amount';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 1 Code';
                    ToolTip = 'Specifies Shortcut Dimension 1 Code';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 2 Code';
                    ToolTip = 'Specifies Shortcut Dimension 2 Code';
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';
                    ToolTip = 'Specifies Job No.';
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    Caption = 'Job Task No.';
                    ToolTip = 'Specifies Job Task No.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SubSetup: Record "Subscription Setup";
        temp: Text;
    begin
        Rec."Document Type" := Rec."Document Type"::"Blanket Order";
        Rec."SCB Blanket Order Type" := Rec."SCB Blanket Order Type"::"Subscription Order";
    end;
}