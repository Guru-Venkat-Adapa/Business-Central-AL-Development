pageextension 50063 "Purch. Invoice Subform" extends "Purch. Invoice Subform"
{
    layout
    {
        //TBC - 835 -->
        modify("Line No.")
        {
            Visible = true;
            Editable = false;
        }
        movebefore("No."; "Line No.")
        //TBc - 835 <--
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        modify("HSN/SAC Code")
        {
            Editable = true;
        }
        modify("GST Group Code")
        {
            Editable = true;
        }
        addafter("Custom Duty Amount")
        {
            field("Freight Amount"; Rec."Freight Amount")
            {
                ApplicationArea = All;
                Caption = 'Freight Amount';
            }
            field("Insurance Amount"; Rec."Insurance Amount")
            {
                ApplicationArea = All;
                Caption = 'Insurance Amount';
            }
        }
    }
}
