codeunit 50100 CustomerLedgerEntriesCustom
{
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterCopyGenJnlLineFromSalesHeader, '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line");
    begin
        SalesHeader.CalcFields("Amount Including VAT");
        GenJournalLine."Total Incl. Amount" := SalesHeader."Amount Including VAT";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure CopytoCustLedEntFromGenJnlEntry(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry."Total Incl. Amount" := GenJournalLine."Total Incl. Amount";
    end;

    // Exporting data to execl sheet

    procedure ExportCustLedEntrytoExcel(var CustLedgerEntryRec: Record "Cust. Ledger Entry")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CustLedgerEntriesLbl: Label 'Customer Ledger Entries';
        ExcelFileName: Label 'CustomerLedgerEntries_%1_%2';
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Entry No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Posting Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Document Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Document No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Customer No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Customer Name"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Currency Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Original Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption(Amount), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Amount (LCY)"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Remaining Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Remaining Amt. (LCY)"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption(Open), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        if CustLedgerEntryRec.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Entry No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Document Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Customer No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Customer Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Currency Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Original Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec.Amount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Amount (LCY)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Remaining Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Remaining Amt. (LCY)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec.Open, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until CustLedgerEntryRec.Next() = 0;
        TempExcelBuffer.CreateNewBook(CustLedgerEntriesLbl);
        TempExcelBuffer.WriteSheet(CustLedgerEntriesLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
    end;
}
