tableextension 50207 "IC Inbox Jnl. Line Ext" extends "IC Inbox Jnl. Line"
{
    fields
    {
        field(50200; "Project reference"; Code[50])
        {
            Caption = 'Project reference';
            DataClassification = CustomerContent;
        }
    }
}
