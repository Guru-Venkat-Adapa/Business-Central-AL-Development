pageextension 50101 "Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        addbefore(Quantity)
        {
            field(Length_; Rec.Length)
            {
                ApplicationArea = All;
                Caption = 'Length';
                ToolTip = 'Specifies the length required for the Sq Ft.';
                // Visible = Show;
                Editable = Show;
            }
            field(Width; Rec.Width)
            {
                ApplicationArea = All;
                Caption = 'Width';
                ToolTip = 'Specifies the Width required for the Sq Ft.';
                // Visible = Show;
                Editable = Show;
            }
        }
        modify("Unit of Measure Code")
        {
            trigger OnAfterValidate()
            begin
                Show := false;
                If Rec."Unit of Measure Code" = 'SQ FT' then
                    Show := true;
            end;
        }
    }
    var
        Show: Boolean;
}
