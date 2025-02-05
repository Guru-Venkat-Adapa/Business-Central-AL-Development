pageextension 50121 "Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Line Discount %")
        {
            field("Item Margins"; Rec."Item Margins")
            {
                Caption = 'Item Margins';
                ToolTip = 'Item Margins';
                Editable = false;
                ApplicationArea = all;
            }
            field("Explode Bundle"; Rec."Explode Bundle")
            {
                Caption = 'Explode Bundle';
                ToolTip = 'Explode Bundle';
                Editable = true;
                ApplicationArea = all;

                trigger OnValidate()
                var
                    DocumentTotals: Codeunit "Document Totals";
                begin
                    CurrPage.Activate(true)end;
            }
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
                SalesLineRec: Record "Sales Line" temporary;
            begin
                SalesLineRec.DeleteAll();
                IF Item.Get(Rec."No.")THEN;
                Item.CalcFields("Assembly BOM");
                IF(Rec.Quantity <> 0) and (Item."Assembly BOM")then IF GuiAllowed then begin
                        if Rec."Prepmt. Amt. Inv." <> 0 then Error(Text001);
                        SalesLineRec.Copy(Rec);
                        CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
                        DocumentTotals.SalesDocTotalsNotUpToDate();
                        //CurrPage.SaveRecord();
                        Rec:=SalesLineRec;
                        Rec.Init();
                        Rec.Description:=SalesLineRec.Description;
                        Rec."Description 2":=SalesLineRec."Description 2";
                        Rec."BOM Item No.":=SalesLineRec."No.";
                        CurrPage.Update(true);
                    end;
            end;
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
    end;
    var ErrText001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
    bhj: Page 9305;
    Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
}
