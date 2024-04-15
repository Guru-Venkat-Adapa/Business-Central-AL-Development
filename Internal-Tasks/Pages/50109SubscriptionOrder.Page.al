page 50109 "Subscription Order"
{
    Caption = 'Subscription Order';
    PageType = Card;
    UsageCategory = Documents;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = filter("Blanket Order"), "SCB Blanket Order Type" = const("Subscription Order"));
    RefreshOnActivate = true;
    AccessByPermission = tabledata "Sales Invoice Header" = I;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record';
                    // trigger OnAssistEdit()
                    // begin
                    // end;
                    Editable = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Suite;
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies the number of the customer who will receive products';
                    Importance = Additional;
                    // trigger OnValidate()
                    // begin
                    // end;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Suite;
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies the name of the customer who will receive products';
                    Importance = Promoted;
                    // trigger OnValidate()
                    // begin
                    // end;

                    // trigger OnLookup(var Text: Text): Boolean
                    // begin
                    // end;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = Suite;
                    Caption = 'Address';
                    ToolTip = 'Specifies the customers address';
                    Importance = Additional;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ApplicationArea = Suite;
                    Caption = 'Address 2';
                    ToolTip = 'Specifies an additional part of the customers address';
                    Importance = Additional;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Post Code';
                    ToolTip = 'Specifies the postal code of the customer address';
                    Importance = Additional;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ApplicationArea = Suite;
                    Caption = 'City';
                    ToolTip = 'Specifies the city of the customer address';
                    Importance = Additional;
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    ApplicationArea = Suite;
                    Caption = 'County';
                    ToolTip = 'Specifies the state ,province or county of the customer address';
                    Importance = Additional;
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Country/Region Code';
                    ToolTip = 'Specifies the country or region of the customer address';
                    Importance = Additional;
                    trigger OnValidate()
                    begin

                    end;
                }
                field("Sell-to Contact No."; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Contact No.';
                    ToolTip = 'Specifies the number of the contact person at the customer';
                    Importance = Additional;
                    trigger OnLookup(var Text: Text): Boolean
                    begin

                    end;
                }
                field("Sell-to Phone No."; Rec."Sell-to Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the phone number of the customer';
                    Importance = Additional;
                }
                field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Email';
                    ToolTip = 'Specifies the email address of the contact person';
                    Importance = Additional;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = Suite;
                    Caption = 'Contact';
                    ToolTip = 'Specifies the name of the contact person at the customer';
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = All;
                    Caption = 'Your Reference';
                    ToolTip = 'Specifies the reference number of the order';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    Caption = 'Salesperson Code';
                    ToolTip = 'Specifies the salesperson code';
                    trigger OnValidate()
                    begin

                    end;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'External Document No.';
                    ToolTip = 'Specifies External Document No.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    ToolTip = 'Specifies the status of the order';
                }
                field("invoicing Frequency"; Rec."SCB Invoicing Frequency")
                {
                    ApplicationArea = All;
                    Caption = 'Invoicing Frequency';
                    ToolTip = 'Specifies the invoicing frequency of the order';
                }
                field("SCB Invoicing Frquency DF"; Rec."SCB Invoicing Frequency DF")
                {
                    ApplicationArea = All;
                    Caption = 'Invoicing Frquency DF';
                    ToolTip = 'Specifies SCB Invoicing Frquency DF';
                }
                field("SCB Blanket Order Type"; Rec."SCB Blanket Order Type")
                {
                    ApplicationArea = All;
                    Caption = 'Blanket Order Type';
                    ToolTip = 'Specifies SCB Blanket Order Type';
                }
                field("Next Invoicing Date"; Rec."SCB Next Invoicing Date")
                {
                    ApplicationArea = All;
                    Caption = 'Next Invoicing Date';
                    ToolTip = 'Specifies Next Action Date';
                }
                field("Next Action Date"; Rec."SCB Next Action Date")
                {
                    ApplicationArea = All;
                    Caption = 'Next Action Date';
                    ToolTip = 'Specifies Next Action Date';
                }
            }
            part("Subscription Subform"; "Subscription Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateSalesInvoice)
            {
                ApplicationArea = All;
                Caption = 'Create Sales Invoice';
                trigger OnAction()
                var
                    Create: Codeunit SubscriptionCodeunit;
                begin
                    Create.CreateSalInvoiceBySubOrder(Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        Rec."Document Type" := Rec."Document Type"::"Blanket Order";
        Rec."SCB Blanket Order Type" := Rec."SCB Blanket Order Type"::"Subscription Order";
    end;

}