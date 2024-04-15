page 50108 "Subscription List"
{
    Caption = 'Subscription List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    RefreshOnActivate = true;
    Editable = false;
    CardPageId = "Subscription Order";
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const("Blanket Order"), "SCB Blanket Order Type" = const("Subscription Order"));
    ShowFilter = false;
    PromotedActionCategories = 'New,Process,Report,Invoice,Lines,Credit Memo,Request Approval,Periodic Activities,Inventory,Dimenions';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer No. of the sales order';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer Name of the sales order';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the external document no.';
                    // Visible=false;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the post code';
                    // Visible=false;
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country/region code';
                    // Visible=false;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact';
                    // Visible=false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status';
                    // Visible=false;
                }
                field("invoicing Frequency"; Rec."SCB Invoicing Frequency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Invoicing Frequency';
                    // Visible=false;
                }
                field("Invoicing Frequency DF"; Rec."SCB Invoicing Frequency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Invoicing Frequency';
                    // Visible=false;
                }
                field("Next Invoicing Date"; Rec."SCB Next Invoicing Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the next invoicing date';
                    // Visible=false;
                }
                field("Next Action Date"; Rec."SCB Next Action Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the next action date';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer No. to bill';
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer Name to bill';
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the post code to bill';
                    // Visible=false;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country/region code to bill';
                    // Visible=false;
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact to bill';
                    // Visible=false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date';
                    // Visible=false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shortcut Dimension 1 Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shortcut Dimension 2 Code';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Salesperson Code';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Assigned User ID';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Currency Code';
                }
                field("SCB Sales Amount per Year"; Rec."SCB Sales Amount per Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SCB Sales Amount per Year';
                }
                // field("Monthly Revenue"; Rec."SCB Monthly Revenue")
                // {
                //     applicationArea = All;
                //     ToolTip = 'Specifies the monthly revenue';
                // }
                // field("Realized Sales Amount"; Rec."Realized Sales Amount")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Realized Sales Amount';

                //     trigger OnDrillDown()
                //     begin
                //         // SubscriptionMgt.LookupSalesEntries();
                //     end;
                // }
                // field("Realized Cost Amount"; Rec."Realized Cost Amount")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Realized Cost Amount';

                //     trigger OnDrillDown()
                //     begin
                //         // SubscriptionMgt.LookupSalesEntries();
                //     end;
                // }
                // field("Realized Profit Amount"; Rec."Realized Profit Amount")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Realized Profit Amount';

                //     trigger OnDrillDown()
                //     begin
                //         // SubscriptionMgt.LookupSalesEntries();
                //     end;
                // }
                // field("Realized VAT Amount"; Rec."Realized VAT Amount")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Realized VAT Amount';

                //     trigger OnDrillDown()
                //     begin
                //         // SubscriptionMgt.LookupSalesEntries();
                //     end;
                // }
                // field("Outstanding Amount"; Rec."Outstanding Amount")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Outstanding Amount';

                //     trigger OnDrillDown()
                //     begin
                //         // SubscriptionMgt.OutstandingSalesEntries();
                //     end;
                // }
            }
        }
        area(FactBoxes)
        {
            // part("SCB Subscription";"SCB Subscription")
            // {
            //     ApplicationArea=All;
            //     Caption='Subscription Details';
            //     SubPageLink="Document Type"=field("Document Type"),"No."=field("No.");
            // }
            // part("Attachements";"Attachment Documents")
            // {
            //     ApplicationArea=All;
            //     Caption='Attachment';
            //     SubPageLink= "Table ID"=const(36),"No."=field("No."),"Document Type"=field("Document Type");
            // }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Create Invoice")
            {
                ApplicationArea = All;
                ToolTip = 'For Creating Invoice';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Category4;
                trigger OnAction()
                begin
                    // Report.Run(Report::"SCB Subscription Create Invoice",true,false,Rec);
                end;
            }
            action("Posted Invoice")
            {
                ApplicationArea = All;
                ToolTip = 'For Posting Invoice';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Category4;
                trigger OnAction()
                begin
                    // ShowPostedInvoice();
                end;
            }
            action("Posted Invoice Lines")
            {
                ApplicationArea = All;
                ToolTip = 'Posting Invoice Lines';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Category5;
                trigger OnAction()
                begin
                    // ShowPostedInvoicesLines();
                end;
            }
            action("Posted Credit Memo")
            {
                ApplicationArea = All;
                ToolTip = 'Posted Credit Memo';
                Image = PostedCreditMemo;
                Promoted = true;
                PromotedCategory = Category6;
                trigger OnAction()
                begin
                    // ShowPostedCreditMemo();
                end;
            }
            action("Posted Credit Memo Lines")
            {
                ApplicationArea = All;
                ToolTip = 'Posted Credit Memo Lines';
                Image = PostedCreditMemo;
                Promoted = true;
                PromotedCategory = Category5;
                trigger OnAction()
                begin
                    // ShowPostedCreditMemo();
                end;
            }
            action("Subscription Lines")
            {
                ApplicationArea = All;
                ToolTip = 'Subscription Order Lines';
                Image = JobLines;
                Promoted = true;
                PromotedCategory = Category5;
                trigger OnAction()
                begin
                    // Page.RunModal(Page::"SCB 790 Sub Order Lines");
                end;
            }
            action("Open Invoice/Credit Memo")
            {
                ApplicationArea = All;
                ToolTip = 'Open Invoices/Credit Memo';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Category6;
                trigger OnAction()
                begin
                    //    Page.RunModal(Page::"SCB 790 Sub. Order Lines");
                end;
            }
            action("Dimensions")
            {
                ApplicationArea = All;
                ToolTip = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Category10;
                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                end;
            }
            action("Statistics")
            {
                ApplicationArea = All;
                ToolTip = 'Statistics';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Category10;
                trigger OnAction()
                begin
                    // Page.RunModal(Page::"Sales Order Statistics".Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
}