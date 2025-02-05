pageextension 50119 ItemListExt extends "Item List"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Substitutes Exist")
        {
            field(ScheduleAvaliableInventory; getsum())
            {
                Caption = 'Schedule Avaliable';
                ApplicationArea = All;

            }
        }
    }
    procedure getsum(): Decimal
    begin
        Rec.CalcFields("Qty. on Purch. Order", Rec."No.");
        exit(rec."Qty. on Purch. Order" + Rec."Qty. on Assembly Order");
    end;

}
