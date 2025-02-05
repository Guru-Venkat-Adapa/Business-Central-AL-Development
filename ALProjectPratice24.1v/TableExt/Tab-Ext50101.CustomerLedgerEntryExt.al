tableextension 50101 CustomerLedgerEntryExt extends "Cust. Ledger Entry"
{
    fields
    {
        field(50100; "Total Incl. Amount"; Decimal)
        {
            Caption = 'Total Incl. Amount';
            DataClassification = CustomerContent;
        }
    }
}
