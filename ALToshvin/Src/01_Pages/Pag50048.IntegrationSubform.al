page 50048 "Integration Subform"
{
    ApplicationArea = All;
    Caption = 'Integration Subform';
    PageType = ListPart;
    SourceTable = "TripGain Voucher Line";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Comments"; Rec.Comments)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
