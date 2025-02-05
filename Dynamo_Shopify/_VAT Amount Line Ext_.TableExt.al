tableextension 50107 "VAT Amount Line Ext" extends "VAT Amount Line"
{
    fields
    {
        modify("VAT %")
        {
        Caption = 'GST %';
        }
        modify("VAT Base")
        {
        CaptionClass = 'GST Base';
        }
        modify("VAT Amount")
        {
        CaptionClass = 'GST Amount';
        }
        modify("Amount Including VAT")
        {
        CaptionClass = 'Amount Includes GST';
        }
    }
}
