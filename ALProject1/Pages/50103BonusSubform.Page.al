page 50103 "Bonus Subform"
{
    PageType = ListPart;
    SourceTable = "Bonus Line";
    Caption='Lines';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Type;Rec.Type)
                {
                    ApplicationArea=All;
                    ToolTip='Specifies Bonus Type';
                    Caption='Type';
                }
                field("Item No.";Rec."Item No.")
                {
                    ApplicationArea=All;
                    ToolTip='Specifies Item No.';
                    Caption='Item No.';
                }
                field("Bonus Perc.";Rec."Bonus Perc.")
                {
                    ApplicationArea=All;
                    ToolTip='Specifies Bonus Percentage';
                    Caption='Bonus Perc.';
                }
            }
        }
    }
}