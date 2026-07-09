pageextension 50101 "Item Tracking Summary" extends "Item Tracking Summary"
{
    layout
    {
        //TBC-950 -->
        addafter("Lot No.")
        {
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        //TNC-950 <--
    }
}
