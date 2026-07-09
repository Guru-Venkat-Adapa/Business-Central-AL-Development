pageextension 50061 "Item Reclass. Journal" extends "Item Reclass. Journal"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = All;
                Caption = 'Lot No.';
                ToolTip = 'Specifies the Lot Number for the item reclassification transaction.';
                Editable = true;
            }
            field("New Lot No."; Rec."New Lot No.")
            {
                ApplicationArea = All;
                Caption = 'New Lot No.';
                ToolTip = 'Specifies the new Lot Number for the item after reclassification.';
                Editable = true;
            }
        }
    }
}
