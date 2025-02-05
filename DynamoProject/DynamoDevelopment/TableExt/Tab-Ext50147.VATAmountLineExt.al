tableextension 50147 "VAT Amount Lines Ext" extends "VAT Amount Line"
{
    fields
    {
        modify("Non-Deductible VAT Base")
        {
            Caption = 'Non-Deductible GST Base';
        }
        modify("Non-Deductible VAT Amount")
        {
            Caption = 'Non-Deductible GST Amount';
        }
        modify("Deductible VAT Base")
        {
            Caption = 'Deductible GST Base';
        }
        modify("Deductible VAT Amount")
        {
            Caption = 'Deductible GST Amount';
        }
        modify("VAT Base (ACY)")
        {
            Caption = 'GST Base (ACY)';
        }
        modify("VAT Amount (ACY)")
        {
            Caption = 'GST Amount (ACY)';
        }
        modify("Amount Including VAT (ACY)")
        {
            Caption = 'Amount Including GST (ACY)';
        }
        modify("VAT Difference (ACY)")
        {
            Caption = 'GST Difference (ACY)';
        }
    }
}
