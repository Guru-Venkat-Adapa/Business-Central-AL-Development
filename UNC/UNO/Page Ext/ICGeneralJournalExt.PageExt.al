pageextension 50100 "IC General Journal Ext" extends "IC General Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field(Project; Rec.Project)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the project of the fund Tranfer Document';
            }
        }
    }
}