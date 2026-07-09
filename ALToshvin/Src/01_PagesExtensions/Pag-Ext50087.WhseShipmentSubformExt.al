pageextension 50087 "Whse. Shipment Subform Ext" extends "Whse. Shipment Subform"
{
    layout
    {
        //TBC - 835 -->
        modify("Source Line No.")
        {
            Visible = true;
            Editable = false;
        }
        movebefore("Source No."; "Source Line No.")
        //TBC - 835 <--
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        //TBC-950 --->
        addafter(Description)
        {
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Lot No.';
            }
        }
        //TBC-950 <---
    }
}
