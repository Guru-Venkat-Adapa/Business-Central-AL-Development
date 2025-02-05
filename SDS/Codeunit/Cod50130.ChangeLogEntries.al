// codeunit 50130 ChangeLogEntries
// {
//     procedure ExportCustLedEntrytoExcel(var ChangeLogEntry: Record "Change Log Entry")
//     var
//         TempExcelBuffer: Record "Excel Buffer" temporary;
//         ChangeLogEntryLbl: Label 'Change Log Entries';
//         ExcelFileName: Label 'ChangeLogEntries_%1_%2';
//     begin
//         TempExcelBuffer.Reset();
//         TempExcelBuffer.DeleteAll();
//         TempExcelBuffer.NewRow();
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Entry No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Date and Time"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption(Time), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Time);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("User ID"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Table No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Table Caption"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Field No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Field Caption"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Type of Change"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Old Value"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("New Value"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Primary Key"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Primary Key Field 1 No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Primary Key Field 1 Caption"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Primary Key Field 1 Value"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Primary Key Field 2 No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Primary Key Field 2 Caption"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Primary Key Field 2 Value"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Primary Key Field 3 No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Primary Key Field 3 Caption"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Primary Key Field 3 Value"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Record ID"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption(Protected), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Changed Record SystemId"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Notification Status"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Field Log Entry Feature"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption("Notification Message Id"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption(SystemId), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption(SystemCreatedAt), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption(SystemCreatedBy), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption(SystemModifiedAt), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.AddColumn(ChangeLogEntry.FieldCaption(SystemModifiedBy), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//         TempExcelBuffer.CreateNewBook(CustLedgerEntriesLbl);
//         TempExcelBuffer.WriteSheet(CustLedgerEntriesLbl, CompanyName, UserId);
//         TempExcelBuffer.CloseBook();
//         TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
//         TempExcelBuffer.OpenExcel();
//     end;
// }
