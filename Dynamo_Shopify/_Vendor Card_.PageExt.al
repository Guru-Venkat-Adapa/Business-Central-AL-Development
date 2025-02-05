pageextension 50103 "Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter("Primary Contact No.")
        {
            field("Primary Contact Name"; Rec."Primary Contact Name")
            {
                ApplicationArea = all;
                ToolTip = 'Primary Contact Person Name';
                Editable = false;
            }
        }
    }
}
