tableextension 50110 "Sales Invoice Line Ext" extends "Sales Invoice Line"
{
    fields
    {
        modify("Unit Price")
        {
        CaptionClass = 'Unit Price Excl. GST';
        }
        modify("Line Amount")
        {
        CaptionClass = 'Line Amount Excl. GST';
        }
    }
}
