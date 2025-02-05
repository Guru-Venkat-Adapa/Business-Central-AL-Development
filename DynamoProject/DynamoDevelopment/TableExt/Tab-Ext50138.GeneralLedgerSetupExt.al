tableextension 50138 "Gen Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        modify("VAT Reporting Date")
        {
            Caption = 'Default GST Date';
        }
        modify("VAT Reporting Date Usage")
        {
            Caption = 'GST Date Usage';
        }
        modify("Pmt. Disc. Excl. VAT")
        {
            Caption = 'Pmt. Disc. Excl. GST';
        }
        modify("Unrealized VAT")
        {
            Caption = 'Unrealized GST';
        }
        modify("VAT Tolerance %")
        {
            Caption = 'GST Tolerance %';
        }
        modify("VAT Exchange Rate Adjustment")
        {
            Caption = 'GST Exchange Rate Adjustment';
        }
        modify("Max. VAT Difference Allowed")
        {
            Caption = 'Max. GST Difference Allowed';
        }
        modify("VAT Rounding Type")
        {
            Caption = 'GST Rounding Type';
        }
        modify("Bill-to/Sell-to VAT Calc.")
        {
            Caption = 'Bill-to/Sell-to GST Calc.';
        }
        modify("Print VAT specification in LCY")
        {
            Caption = 'Print GST specification in LCY';
        }
        modify("Prepayment Unrealized VAT")
        {
            Caption = 'Prepayment Unrealized GST';
        }
        modify("Control VAT Period")
        {
            Caption = 'Control GST Period';
        }
        modify("Enable VAT Registration No.")
        {
            Caption = 'Enable GST Registration No.';
        }
        modify("Interest Cal Excl. VAT")
        {
            Caption = 'Interest Cal Excl. GST';
        }
    }
}
