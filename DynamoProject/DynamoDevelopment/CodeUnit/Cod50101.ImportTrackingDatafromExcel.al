codeunit 50101 "Import Tracking Data fromExcel"
{
    Permissions =
        tabledata "Sales Header" = RM;

    var
        FileName: Text;
        SheetName: Text;

        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        BatchISBlankMsg: Label 'Batch name is blank';
        ExcelImportSucess: Label '%1 documents were updated successfully';


    procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text;
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

    procedure ImportExcelData()
    var
        SHeader: Record "Sales Header";
        RowNo: Integer;
        MaxRowNo: Integer;
        temp: Code[20];
        Count: Integer;
    begin
        RowNo := 0;
        MaxRowNo := 0;
        Count := 0;
        SHeader.Reset();
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then
            MaxRowNo := TempExcelBuffer."Row No.";
        for RowNo := 2 to MaxRowNo do begin
            Evaluate(temp, GetValueAtCell(RowNo, 1));
            SHeader.SetRange("No.", temp);
            if SHeader.FindFirst() then begin
                Evaluate(SHeader."Tacking Type", GetValueAtCell(RowNo, 2));
                Evaluate(SHeader."Tracking reference No.", GetValueAtCell(RowNo, 3));
                SHeader.Modify(false);
                Count += 1;
            end;
        end;
        Message(ExcelImportSucess, Count);
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    // [EventSubscriber(ObjectType::Table, database::"Sales Line", '', '', false, false)]
    // local procedure OnAfterValidateEventBOM()
    // var
    //     SalesOrderSubform: Page "Sales Order Subform";
    // begin
    //     SalesOrderSubform.ExplodeBOM();
    //     // Dialog.Message('Item BOM explored Successfully');
    // end;
    // [EventSubscriber(ObjectType::page, page::"Sales Order Subform", 'OnAfterQuantityOnAfterValidate', '', false, false)]
    // local procedure ExplodeBOMQuote(var SalesLine: Record "Sales Line"; sender: Page "Sales Order Subform"; xSalesLine: Record "Sales Line")
    // var
    //     Item: Record Item;
    // begin
    //     IF Item.Get(SalesLine."No.") THEN;
    //     Item.CalcFields("Assembly BOM");
    //     IF (SalesLine.Quantity <> 0) and (Item."Assembly BOM") then
    //         IF GuiAllowed then begin
    //             // if Rec."Prepmt. Amt. Inv." <> 0 then
    //             //     Error(Text001);
    //             CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", SalesLine);
    //             DocumentTotals.SalesDocTotalsNotUpToDate();
    //         end;
    // end;
    // [EventSubscriber(ObjectType::Page, page::"Sales Order Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
    // local procedure OnAfterValidateEventExplodeBOM(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    // var
    //     Item: Record Item;
    // begin
    //     IF Item.Get(Rec."No.") THEN;
    //     Item.CalcFields("Assembly BOM");
    //     IF (Rec.Quantity <> 0) and (Item."Assembly BOM") then
    //         IF GuiAllowed then begin
    //             // if Rec."Prepmt. Amt. Inv." <> 0 then
    //             //     Error(Text001);
    //             CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
    //             DocumentTotals.SalesDocTotalsNotUpToDate();
    //         end;
    // end;

    // var
    //     DocumentTotals: Codeunit "Document Totals";
}
