pageextension 50037 "No. Series" extends "No. Series"
{
    layout
    {
        // modify(Description)
        // {
        //     Editable = false;
        // }
        addafter(Implementation)
        {
            field("PO Order No. Series"; Rec."PO Order No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether this No. Series is used to create Special Purchase Orders based on the selected No. Series.';
            }
        }
        addafter(StartNo)
        {
            //TBC - 925,922 -->
            field("Posting Warehouse No. Series"; Rec."Posting Warehouse No. Series")
            {
                ApplicationArea = All;
                Caption = 'Posting Warehouse No. Series';
            }
            //TBC - 925,922 <--
        }
    }
}
