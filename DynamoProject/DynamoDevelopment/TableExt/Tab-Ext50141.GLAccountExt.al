tableextension 50141 "G/L Account Ext" extends "G/L Account"
{
    fields
    {
        modify("VAT Bus. Posting Group")
        {
            Caption = 'GST Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'GST Prod. Posting Group';
        }
        modify("VAT Amt.")
        {
            Caption = 'GST Amount';
        }
        modify("VAT Reporting Date Filter")
        {
            Caption = 'GST Reporting Date Filter';
        }
    }
}
