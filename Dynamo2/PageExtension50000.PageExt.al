pageextension 50000 PageExtension50000 extends "Item Journal"
{
    layout
    {
        moveafter("Applies-to Entry"; "Gen. Prod. Posting Group")
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("Applies-to Entry"; "Gen. Bus. Posting Group")
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        addafter("Gen. Prod. Posting Group")
        {
            field("Inventory Posting Group61792"; Rec."Inventory Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
