page 50104 "Bonus Entries"
{
    PageType = List;
    SourceTable = "Bonus Entry";
    Caption='Bonus Entites';
    Editable=false;
    DeleteAllowed=false;
    InsertAllowed=false;
    ModifyAllowed=false;

    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field("Entry No.";Rec."Entry No.")
                {
                    ApplicationArea=All;
                    Caption='Entry No.';
                    ToolTip='Specifes the entry no.';
                }
                field("Bonus No.";Rec."Bonus No.")
                {
                    ApplicationArea=All;
                    Caption='Bonus No.';
                    ToolTip='Specifies bonus No.';
                }
                field("Documnet No.";Rec."Documnet No.")
                {
                    ApplicationArea=All;
                    Caption='Document No.';
                    ToolTip='Specifies document No.';
                }
                field("Item No.";Rec."Item No.")
                {
                    ApplicationArea=All;
                    Caption='Item No.';
                    ToolTip='Specifies item no.';
                }
                field("Posting Date";Rec."Posting Date")
                {
                    ApplicationArea=All;
                    Caption='Posting date';
                    ToolTip='Specifies posting date';
                }
                field("Bonus Amount";Rec."Bonus Amount")
                {
                    ApplicationArea=All;
                    Caption='Bonus Amount';
                    ToolTip='Specifies bonus amount';
                }
            }
        }
    }
}