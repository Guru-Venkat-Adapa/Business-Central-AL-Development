page 50108 "Import Data from Excel"
{
    ApplicationArea = All;
    Caption = 'Import Data from Excel';
    PageType = List;
    SourceTable = "Import From Excel";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Import Data")
            {
                Caption = 'Import Data';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    data: Record "Import From Excel";
                begin
                    ReadExcelSheet();
                    ImportExcelData();
                end;
            }
        }
    }
    var
        FileName: Text[100];
        SheetName: Text[100];

        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        BatchISBlankMsg: Label 'Batch name is blank';
        ExcelImportSucess: Label 'Excel is successfully imported.';


    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        Import: Record "Import From Excel";
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
        temp: Code[20];
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        Import.Reset();
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            Evaluate(temp, GetValueAtCell(RowNo, 1));
            Import.SetRange("No.", temp);
            if Import.FindFirst() then begin
                Evaluate(Import.Name, GetValueAtCell(RowNo, 2));
                Evaluate(Import.Address, GetValueAtCell(RowNo, 3));
                Import.Modify(true);
            end;
        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}
