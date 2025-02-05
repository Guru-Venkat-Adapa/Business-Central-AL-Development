pageextension 50121 "G/L Account Card Ext" extends "G/L Account Card"
{
    layout
    {
        modify("VAT Bus. Posting Group")
        {
            Caption = 'GST Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'GST Prod. Posting Group';
        }
    }
}
