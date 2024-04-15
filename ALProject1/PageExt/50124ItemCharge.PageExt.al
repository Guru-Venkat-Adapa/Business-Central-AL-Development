pageextension 50124 "ItemChagreExt" extends "Item Charges"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(Item; Rec.Item)
            {
                Caption = 'Items';
                ApplicationArea = All;

            }
            field(ItemQty; Rec.ItemQty)
            {
                Caption = 'Item Qty %';
                ApplicationArea = All;
                BlankZero = true;
                MinValue = 0;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}