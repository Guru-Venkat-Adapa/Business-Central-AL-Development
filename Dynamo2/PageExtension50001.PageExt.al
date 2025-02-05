pageextension 50001 PageExtension50001 extends "Warehouse Pick"
{
    layout
    {
        addafter("Sorting Method")
        {
            field("Registering No. Series28388"; Rec."Registering No. Series")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
