pageextension 50108 "Sales Order SubForm Ext" extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("IC Partner Reference")
        {
            field("Text Line"; Rec."Text Line")
            {
                Caption = 'Text For Line';
                ApplicationArea = All;
            }
        }
        addafter("Line Amount")
        {
            field(IVA; Rec.IVA)
            {
                Caption = 'IVA';
                ApplicationArea = All;
                BlankZero = true;
                // trigger OnValidate()
                // begin
                //     if Rec."Line Amount" <> xRec."Line Amount" then begin
                //         Rec.IVA := (24 * Rec."Line Amount") / 100;
                //     end;
                // end;
            }
            field(IEPS; Rec.IEPS)
            {
                Caption = 'IEPS';
                ApplicationArea = All;
                BlankZero = true;
                // trigger OnValidate()
                // begin
                //     if Rec."Line Amount" <> xRec."Line Amount" then begin
                //         Rec.IEPS := (53 * Rec."Line Amount") / 100;
                //     end;
                // end;
            }
        }
        // modify("Line Amount")
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         if Rec."Line Amount" <> 0 then begin
        //             Rec.IVA := (24 * Rec."Line Amount") / 100;
        //             Rec.IEPS := (53 * Rec."Line Amount") / 100;
        //         end;
        //     end;
        // }
    }
    trigger OnModifyRecord(): Boolean
    var
        value: Decimal;
        value2: Decimal;
        Sales_line: Record "Sales Line";
    begin
        Sales_line.SetRange("Line No.", Rec."Line No.");
        if Sales_line.FindSet() then begin

            if Rec."Line Amount" <> xRec."Line Amount" then begin
                repeat
                    value := (24 * xRec."Line Amount") / 100;
                    Rec.IVA := value;
                    value2 := (53 * xRec."Line Amount") / 100;
                    Rec.IEPS := value2;
                until Sales_line.Next() = 0;
            end;
        end;
    end;
}