pageextension 50207 "Item List Ext" extends "Item List"
{
    layout
    {
        addbefore("Substitutes Exist")
        {

        }
    }
    procedure GetTotal(): Decimal
    begin
        Rec.CalcFields("Qty. on Purch. Order", Rec.ScheduleInventoryOfBlanket);
        exit(rec."Qty. on Purch. Order" + Rec.ScheduleInventoryOfBlanket)
    end;
}
