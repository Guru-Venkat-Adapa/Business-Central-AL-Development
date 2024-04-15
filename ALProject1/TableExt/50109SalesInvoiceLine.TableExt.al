tableextension 50109 "Sales Invoice Line Ext" extends "Sales Invoice Line"
{
    fields
    {
        // Add changes to table fields here
         field(50100; "Text Line"; Text[100])
        {
            Caption = 'Text For Line';
            DataClassification = CustomerContent;
        }
    }
}