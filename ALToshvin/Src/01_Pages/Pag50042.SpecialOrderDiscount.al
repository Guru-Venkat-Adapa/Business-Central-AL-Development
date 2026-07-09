page 50042 "Special Order Discount"
{
    ApplicationArea = All;
    Caption = 'Special Order Discount';
    PageType = StandardDialog;
    SourceTable = "Purchase Header";
    UsageCategory = Lists;
    RefreshOnActivate = true;
    DataCaptionExpression = Rec."No." + '-' + Rec."Buy-from Vendor Name";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                // Bind directly to table field
                field("Invoice Discount Perc"; Rec."Invoice Discount Perc")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Discount %';
                    ToolTip = 'Enter the discount percentage for this purchase order.';
                    trigger OnValidate()
                    begin
                        if Rec."Invoice Discount Perc" < 0 then
                            Error('Discount percentage cannot be negative.');
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec."Invoice Discount Perc" <> 0 then begin
            Rec."Invoice Discount Perc" := 0;
            Rec.Modify(false);
        end;
    end;

    //Old running code with enter Mannully List price in PO ------->
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        PurchaseLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        PurchaseSubForm: Page "Purchase Order Subform";
    begin
        if CloseAction = Action::OK then begin
            // Reopen the PO if currently Released
            if Rec.Status = Rec.Status::Released then begin
                Rec.Status := Rec.Status::Open;
                Rec.Modify(false);
            end;
            // Process all Purchase Lines
            PurchaseLine.Reset();
            PurchaseLine.SetRange("Document Type", Rec."Document Type");
            PurchaseLine.SetRange("Document No.", Rec."No.");
            PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
            if PurchaseLine.FindSet() then
                repeat
                    // Break Special Order Link
                    if PurchaseLine."Special Order" then begin
                        // Update Related Sales Line
                        SalesLine.Reset();
                        SalesLine.SetRange("Document No.", PurchaseLine."Special Order Sales No.");
                        SalesLine.SetRange("Line No.", PurchaseLine."Special Order Sales Line No.");
                        SalesLine.SetRange("Special Order", true);
                        if SalesLine.FindFirst() then begin
                            SalesLine."Purchasing Code" := '';
                            SalesLine."Special Order Purchase No." := '';
                            SalesLine."Special Order Purch. Line No." := 0;
                            SalesLine."Special Order" := false;
                            SalesLine.Modify(false);
                        end;

                        // Update Purchase Line – Remove Linking
                        PurchaseLine."Purchasing Code" := '';
                        PurchaseLine."Special Order Sales No." := '';
                        PurchaseLine."Special Order Sales Line No." := 0;
                        PurchaseLine."Special Order" := false;
                    end;

                    // Force "Allow Invoice Disc." = TRUE if it is FALSE
                    if not PurchaseLine."Allow Invoice Disc." then
                        PurchaseLine.Validate("Allow Invoice Disc.", true);

                    // Save Purchase Line
                    PurchaseLine.Modify(false);

                    // Update Subform Discount Logic (if required)
                    PurchaseSubForm.UpdateSpecialOrderDiscount(PurchaseLine);

                until PurchaseLine.Next() = 0;

            Message('The Special Order has been successfully broken.');
            exit(true);
        end;
        exit(true);
    end;
}
