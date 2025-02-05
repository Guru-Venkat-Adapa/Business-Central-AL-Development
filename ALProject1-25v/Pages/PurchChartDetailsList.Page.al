page 50108 "Purch Chart Details List"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Purchase line";
    SourceTableTemporary = true;
    Editable = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater("Purchase Details")
            {
                Caption = 'Top 5 Purchase Line Details';
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Item Description';
                    ToolTip = 'Description';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No';
                    tooltip = 'No';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No';
                    tooltip = 'Buy-from Vendor No.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No';
                    tooltip = 'Document No.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity Purchase';
                    tooltip = 'Quantity';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Purch Amount';
                    tooltip = 'Amount';
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Group';
                    tooltip = 'Posting Group';
                }
            }
        }
    }

    trigger OnOpenPage()

    begin
        Rec.DeleteAll();
        PurchLine.SetFilter("Document Type", 'Order');
        PurchLine.SetFilter(Type, 'Item');
        PurchLine.SetCurrentKey(Quantity);
        PurchLine.SetAscending(Quantity, false);
        i := 1;

        if not PurchLine.GetAscending(Quantity) and PurchLine.FindSet() then
            repeat
                if i <= 5 then begin
                    Rec.Init();
                    Rec.TransferFields(PurchLine);
                    Rec.Insert();
                    i += 1;
                end
                else
                    break;
            until PurchLine.Next() = 0;
        CurrPage.SetTableView(Rec);
    end;

    var
        PurchLine: Record "Purchase Line";
        i: Integer;
}
