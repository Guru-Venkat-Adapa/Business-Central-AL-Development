pageextension 50123 "Purchases & Payables Setup Ext" extends "Purchases & Payables Setup"
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
        modify("Reverse Charge VAT Posting Gr.")
        {
            Caption = 'Reverse Charge GST Posting Gr.';
        }
    }
}
