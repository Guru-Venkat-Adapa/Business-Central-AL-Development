tableextension 50135 "Purch. Cr. Memo Hdr. Ext" extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        modify("Amount Including VAT")
        {
            Caption = 'Amount Including GST';
        }
    }
}
