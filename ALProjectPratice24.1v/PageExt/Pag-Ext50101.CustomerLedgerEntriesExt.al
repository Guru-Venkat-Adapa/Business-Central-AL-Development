pageextension 50101 CustomerLedgerEntriesExt extends "Customer Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Total Incl. Amount"; Rec."Total Incl. Amount")
            {
                ApplicationArea = All;
                Caption = 'Total Incl. Amount';
            }
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            action(ExpoorttoExcel)
            {
                Caption = 'Export to Excel';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Export;

                trigger OnAction()
                var
                    code: Codeunit CustomerLedgerEntriesCustom;
                begin
                    code.ExportCustLedEntrytoExcel(Rec);
                end;
            }
        }
    }
}
