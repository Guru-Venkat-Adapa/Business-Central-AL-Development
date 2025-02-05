pageextension 50122 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        modify("Allow VAT Difference")
        {
            Caption = 'Allow GST Difference';
        }
        modify("Calc. Inv. Disc. per VAT ID")
        {
            Caption = 'Calc. Inv. Disc. per GST ID';
        }
        modify("VAT Bus. Posting Gr. (Price)")
        {
            Caption = 'GST Bus. Posting Gr. (Price)';
        }
        modify("Reverse Charge VAT Posting Gr.")
        {
            Caption = 'Reverse Charge GST Posting Gr.';
        }
    }
}
