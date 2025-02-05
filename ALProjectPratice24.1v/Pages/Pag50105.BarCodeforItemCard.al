page 50105 "Bar Code for Item Card"
{
    Caption = 'Bar Code for Item Card';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(Content)
        {
            field("Bar Code"; Rec."Bar Code")
            {
                // Caption = 'Bar Code';
                ApplicationArea = Basic, Suite;
                ShowCaption = false;
            }
        }
    }
}
