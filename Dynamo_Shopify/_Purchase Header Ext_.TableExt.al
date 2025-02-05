tableextension 50109 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        modify("Prices Including VAT")
        {
        Caption = 'Prices Includes GST';
        }
        modify("VAT Bus. Posting Group")
        {
        Caption = 'GST Bus. Posting Group';
        }
    }
}
