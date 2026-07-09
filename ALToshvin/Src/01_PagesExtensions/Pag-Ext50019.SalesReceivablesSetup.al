pageextension 50019 SalesReceivablesSetup extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Order Nos.")
        {
            field("Spares Order Nos. Series"; Rec."Spares Order Nos. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Spares Order Nos. Series field.';
            }
            field("ORC Order Nos. Series"; Rec."ORC Order Nos. Series")
            {
                ApplicationArea = All;
                Caption = 'ORC Order Nos.';
            }
        }
        //TBC-934 -->
        addafter("GST Dependency Type")
        {
            field("New LUT No."; Rec."New LUT No.")
            {
                ApplicationArea = All;
                Caption = 'New LUT No.';
            }
            field("Old LUT No."; Rec."Old LUT No.")
            {
                ApplicationArea = All;
                Caption = 'Old LUT No.';
            }
        }
        //TBc-934 <--

    }
}
