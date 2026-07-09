report 50021 "Import PO Annexure"
{
    ApplicationArea = All;
    Caption = 'Import PO Annexure';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\04_Reports\Layouts\ImportPOAnnexure.rdlc';
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Purchase - Order';
            column(PuchOrderNo_; "No.") { }
            column(PuchOrdPostDt; PostingDate) { }
            column(Currecny; Currecny.Description) { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemLinkReference = "Purchase Header";
                column(ItemNo; "No.") { }
                column(ItemDescription; Description) { }
                column(ItemQuantity; Quantity) { }
                column(ItemUnit_Price; "Direct Unit Cost") { }
                column(ItemLine_Amount; "Line Amount") { }
                column(Narration; Narration) { }
                trigger OnAfterGetRecord()
                var
                    PuchCommentLine: Record "Purch. Comment Line";
                begin
                    Clear(Narration);
                    PuchCommentLine.SetRange("Document Type", "Purchase Line"."Document Type"::Order);
                    PuchCommentLine.SetRange("No.", "Purchase Line"."Document No.");
                    PuchCommentLine.SetRange("Document Line No.", "Purchase Line"."Line No.");
                    if PuchCommentLine.findfirst() then
                        Narration := PuchCommentLine.Comment
                    else
                        Narration := '';
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(PostingDate);
                PostingDate := Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                // if "Currency Code" <> '' then
                if Currecny.get("Currency Code") then;
            end;
        }
    }
    var
        Currecny: Record Currency;
        PostingDate: Text;
        Narration: Text;
}
