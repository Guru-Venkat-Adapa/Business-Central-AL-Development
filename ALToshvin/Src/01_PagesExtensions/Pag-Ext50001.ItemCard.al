pageextension 50001 ItemCard extends "Item Card"
{
    layout
    {
        //NavSoft_HG_24/04/2025 Remove Mandatory sign from Vat Prod. Posting Group  ---->  
        modify("VAT Prod. Posting Group")
        {
            ShowMandatory = false;
        }
        //NavSoft_HG_24/04/2025 Remove Mandatory sign from Vat Prod. Posting Group  <----

        //NavSoft_HG_26/05/2025 Added for T-Square Integration  +++
        addafter(Description)
        {
            field("CRM Item No."; Rec."CRM Item No.")
            {
                ApplicationArea = All;
                Caption = 'CRM Item No.';
                ToolTip = 'Specifies the value of the CRM Item No. field.';
            }
        }
        //NavSoft_HG_26/05/2025 Added for T-Square Integration  ---
        addafter("Purchasing Code")
        {
            field("Item Reorder"; Rec."Item Reorder")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Reorder fields.';
            }
        }
        addlast(Item)
        {
            field("Primary Category 1"; Rec."Primary Category 1")
            {
                ApplicationArea = All;
                Caption = 'Primary Category 1';
            }
            field("Primary Category 2"; Rec."Primary Category 2")
            {
                ApplicationArea = All;
                Caption = 'Primary Category 2';
            }
            field("Primary Category 3"; Rec."Primary Category 3")
            {
                ApplicationArea = All;
                Caption = 'Primary Category 3';
            }
            field("Item Category 1"; Rec."Item Category 1")
            {
                ApplicationArea = All;
                Caption = 'Item Category 1';
            }
            field("Item Category 2"; Rec."Item Category 2")
            {
                ApplicationArea = All;
                Caption = 'Item Category 2';
            }
            field(Principal; Rec.Principal)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Principal field.';
            }
        }
    }


}
