tableextension 50102 "Item Unit of Measure Ext" extends "Item Unit of Measure"
{
    fields
    {
        modify(Length)
        {
            trigger OnAfterValidate()
            begin
                CheckDimensions(Rec);
                // UpdateDescription(Rec);
            end;
        }
        modify(Width)
        {
            trigger OnAfterValidate()
            begin
                CheckDimensions(Rec);
                // UpdateDescription(Rec);
            end;
        }
        modify(Height)
        {
            trigger OnAfterValidate()
            begin
                CheckDimensions(Rec);
                // UpdateDescription(Rec);
            end;
        }
        modify(Weight)
        {
            trigger OnAfterValidate()
            begin
                CheckDimensions(Rec);
                // UpdateDescription(Rec);
            end;
        }
    }
    var
        LenLbl: Label 'Length: ';
        WidLbl: Label 'Width: ';
        HeiLbl: Label 'Height: ';
        WieLbl: Label 'Weight: ';

    procedure CheckDimensions(var Rec: Record "Item Unit of Measure")
    var
        ItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        if (Rec.Length <> 0) and (Rec.Width <> 0) and (Rec.Height <> 0) and (Rec.Weight <> 0) then begin
            ItemUnitofMeasure.SetRange(Length, Rec.Length);
            ItemUnitofMeasure.SetRange(Width, Rec.Width);
            ItemUnitofMeasure.SetRange(Height, Rec.Height);
            ItemUnitofMeasure.SetRange(Weight, Rec.Weight);
            if ItemUnitofMeasure.FindFirst() then
                Error('The Box having length %1, Width %2, Height %3 and weight %4 already exists with Item No. %5', Rec.Length, Rec.Width, Rec.Height, Rec.Weight, ItemUnitofMeasure."Item No.");
            UpdateDescription(Rec);
        end;
    end;

    procedure UpdateDescription(var Rec: Record "Item Unit of Measure")
    var
        Item: Record Item;
    begin
        if (Rec.Length <> xRec.Length) or (Rec.Width <> xRec.Width) or (Rec.Height <> xRec.Height) or (Rec.Weight <> xRec.Weight) then
            if Dialog.Confirm('DO you want to change item description automatically as per the dimensons..?') then begin
                Item.SetRange("No.", Rec."Item No.");
                If Item.FindFirst() then begin
                    Item.Description := StrSubstNo('%5 %1, %6 %2, %7 %3, %8 %4', Rec.Length, Rec.Width, Rec.Height, Rec.Weight, LenLbl, WidLbl, HeiLbl, WieLbl);
                    Item.Modify(false);
                end;
            end;
    end;


}
