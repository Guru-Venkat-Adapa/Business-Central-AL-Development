tableextension 50107 "Sales LIne Ext" extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Text Line"; Text[100])
        {
            Caption = 'Text For Line';
            DataClassification = CustomerContent;
        }
        field(50101; IVA; Integer)
        {
            Caption = 'IVA';
            DataClassification = CustomerContent;
            // trigger OnValidate()
            // var
            //     Sales_line: Record "Sales Line";
            // begin
            //     if Rec."Line Amount" <> xRec."Line Amount" then
            //         Rec.iva := (24 * Rec."Line Amount") / 100;
            // end;
        }
        field(50102; IEPS; Integer)
        {
            Caption = 'IEPS';
            DataClassification = CustomerContent;
            // trigger OnValidate()
            // begin
            //     if Rec."Line Amount" <> xRec."Line Amount" then
            //         Rec.IEPS := (53 * Rec."Line Amount") / 100;
            // end;
        }
        // modify("Line Amount")
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         if Rec."Line Amount" <> xRec."Line Amount" then begin
        //             Rec.IVA := (24 * Rec."Line Amount") / 100;
        //             Rec.IEPS := (53 * Rec."Line Amount") / 100;
        //         end;
        //     end;
        // }

    }
}