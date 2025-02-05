pageextension 50120 "Shpfy Product" extends "Shpfy Products"
{
    layout
    {
        // Add changes to page layout here
        addafter(ItemNo)
        {
            field(Rec; Rec."Shpfy SKU")
            {
                ApplicationArea = All;
                Caption = 'BC Item No.';
                AssistEdit = true;
                DrillDown = true;
                DrillDownPageId = "Item Card";
                ToolTip = 'Specifies the item number.';
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
    // IF Rec."Shpfy SKU" = '' then
    //     if Item.GetBySystemId(Rec."Item SystemId") then
    //         Rec."Shpfy SKU" := Item."No.";
    end;
    trigger OnOpenPage()
    var
        Item: Record Item;
        shpyprod: Record "Shpfy Product";
    begin
        shpyprod.Reset();
        shpyprod.SetRange(shpyprod."Item No.", '');
        if shpyprod.FindSet()then repeat if Item.GetBySystemId(shpyprod."Item SystemId")then begin
                    shpyprod."Shpfy SKU":=Item."No.";
                    shpyprod.Modify();
                end until shpyprod.Next() = 0;
    end;
}
