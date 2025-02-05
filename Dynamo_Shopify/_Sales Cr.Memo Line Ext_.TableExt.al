tableextension 50111 "Sales Cr.Memo Line Ext" extends "Sales Cr.Memo Line"
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
