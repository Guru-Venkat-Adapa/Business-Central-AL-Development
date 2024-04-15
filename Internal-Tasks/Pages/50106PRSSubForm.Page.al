page 50106 "PRS SubForm"
{
    PageType = ListPart;
    // ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "PRS Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {
                // field("Line No."; Rec."Line No.")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Line No.';
                // }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                }
                // field("Item Category Code",)
                // {
                //     ApplicationArea=All;
                //     Caption='Item Category Code';
                // }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    caption = 'No.';
                    ShowMandatory = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ShowMandatory = true;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Caption = 'Description 2';
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Caption = 'Unit of Measure Code';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Price';
                    ShowMandatory = true;
                }
                // field("Item Specification Code"; Rec."Item Specification Code")
                // {
                //     ApplicationArea = All;
                //     Caption='Item Specification Code';
                // visible=false;
                // }
                // field("Total Requested Qty";Rec."Total Requested Quantity")
                // {
                //     ApplicationArea=All;
                //     Caption='Total Requested Qty';
                // }
                // field("Suggested Qty to Order";Rec."Suggested Qty to Order")
                // {
                //     ApplicationArea=All;
                //     Caption='Suggested Qty to Order';
                // }
                field("Requested Quantity"; Rec."Requested Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Requested Quantity';
                    ToolTip = 'Specifies the quantity of the MRS request';
                }
                field("Qty to Order"; Rec."Qty to Order")
                {
                    ApplicationArea = All;
                    Caption = 'Qty to Order';
                    ShowMandatory = true;
                    BlankZero = true;
                }
                field("Expected Delivery Date"; Rec."Expected Delivery Date")
                {
                    ApplicationArea = All;
                    Caption = 'Expected Delivery Date';
                }
                field("Avaliable Stock"; Rec."Avaliable Stock")
                {
                    ApplicationArea = All;
                    Caption = 'Avaliable Stock';
                }
                field("Order Quantity (Base)"; Rec."Order Quantity (Base)")
                {
                    ApplicationArea = All;
                    caption = 'Ordered Quantity';
                    Editable = false;
                }
                // field("Remaining Quantity"; Rec."Remaning Quantity")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Remaining Quantity';
                //     Editable = false;
                // }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                    ShowMandatory = true;
                }
                field("Purchase Type"; Rec."Purchase Type")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Type';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Order)
            {
                ApplicationArea = All;
                Caption = 'Order';
                Image = Order;
                ToolTip = 'Specifies to orders of requisition line document ';
                trigger OnAction()
                begin

                end;
            }
            action(Invoice)
            {
                ApplicationArea = All;
                Caption = 'Invoice';
                Image = Invoice;
                ToolTip = 'Specifies to Invoices for the requisition line document';
                trigger OnAction()
                begin

                end;
            }
            action(Receipts)
            {
                ApplicationArea = All;
                Caption = 'Receipts';
                Image = ReceiptLines;
                ToolTip = 'Specifies to receipts for requisition line document';
                trigger OnAction()
                begin

                end;
            }
            action(Dimensions)
            {
                ApplicationArea = All;
                Caption = 'Dimensions';
                Image = Dimensions;
                ToolTip = 'Specifies to dimensions for requisition line document';
                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if (rec."Documnet No." = '') then begin
            rec."Documnet No." := xRec."Documnet No.";
            rec.Modify(true);
        end;
    end;
}