tableextension 50139 "Purchases & Payables Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        modify("Allow VAT Difference")
        {
            Caption = 'Allow GST Difference';
        }
        modify("Calc. Inv. Disc. per VAT ID")
        {
            Caption = 'Calc. Inv. Disc. per GST ID';
        }
    }
}
