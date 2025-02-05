tableextension 50143 "Customer Ext" extends Customer
{
    fields
    {
        modify("Prices Including VAT")
        {
            Caption = 'Prices Including GST';
        }
        modify("VAT Registration No.")
        {
            Caption = 'GST Registration No.';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'GST Bus. Posting Group';
        }
        modify("Validate EU Vat Reg. No.")
        {
            Caption = 'Validate EU GST Reg. No.';
        }
    }
}
