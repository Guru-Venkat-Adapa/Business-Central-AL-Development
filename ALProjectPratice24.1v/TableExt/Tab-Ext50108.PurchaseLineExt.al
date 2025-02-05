tableextension 50108 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        modify("Direct Unit Cost")
        {
            CaptionClass = 'Direct Unit Cost Excl. GST';
        }
        modify("Line Amount")
        {
            CaptionClass = 'Line Amount Excl. GST';
        }
    }
}
