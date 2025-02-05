page 50102 "Read Excel Data"
{
    ApplicationArea = All;
    Caption = 'Read Excel Data';
    PageType = List;
    SourceTable = "Reading Excel";
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Box Serial"; Rec."Box Serial")
                {
                    ToolTip = 'Specifies the value of the Box Serial field.', Comment = '%';
                }
                field(Length; Rec.Length)
                {
                    ToolTip = 'Specifies the value of the Length field.', Comment = '%';
                }
                field(Width; Rec.Width)
                {
                    ToolTip = 'Specifies the value of the Width field.', Comment = '%';
                }
                field(Height; Rec.Height)
                {
                    ToolTip = 'Specifies the value of the Height field.', Comment = '%';
                }
                field(Weight; Rec.Weight)
                {
                    ToolTip = 'Specifies the value of the Weight field.', Comment = '%';
                }
                field(Cbm; Rec.Cbm)
                {
                    ToolTip = 'Specifies the value of the Cbm field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("&Import")
            {
                Caption = '&Import';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Import data from excel.';

                trigger OnAction()
                var
                begin
                    ReadExcelSheet();
                    ImportExcelData();
                end;
            }
            action(CreateItem)
            {
                ApplicationArea = All;
                Caption = 'Create new Items';
                Promoted = true;
                PromotedCategory = Process;
                Image = NewItem;
                ToolTip = 'Creates new Item';
                trigger OnAction()
                begin
                    CreateChildItem();
                end;
            }
            action(GetSelectedItem_)
            {
                ApplicationArea = All;
                Caption = 'Get Selected Item';
                Promoted = true;
                PromotedCategory = Process;
                Image = SelectMore;
                ToolTip = 'Gets selected Item';
                trigger OnAction()
                begin
                    // CurrPage.SetSelectionFilter(Rec);
                    // Message(Rec.);
                    // Message(GetSelectionFilter());
                end;
            }

        }
    }
    // procedure GetSelectionFilter(): Text
    // var
    //     DataExcel: Record "Reading Excel";
    //     SelectionFilterManagement: Codeunit SelectionFilterManagement;
    // begin
    //     CurrPage.SetSelectionFilter(DataExcel);
    //     exit(Rec.GetSelectionFilterForItem(DataExcel));
    // end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        SalesReceiveable: Record "Sales & Receivables Setup";
        InvSetup: Record "Inventory Setup";
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit "No. Series";
        FileName: Text;
        SheetName: Text[250];
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
    //                   Read excel data and insert into business central
    local procedure ReadExcelSheet()
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

    local procedure ImportExcelData()
    var
        SOImportBuffer: Record "Reading Excel";
        RowNo: Integer;
        BoxSeries: Integer;
        MaxRowNo: Integer;
        Length_: Decimal;
        Width_: Decimal;
        Height_: Decimal;
        Weight_: Decimal;
        Cbm_: Decimal;
        RecNo: Code[20];
    begin
        RowNo := 2;
        MaxRowNo := 0;
        if TempExcelBuffer.FindLast() then
            MaxRowNo := TempExcelBuffer."Row No.";

        for RowNo := 2 to MaxRowNo do begin
            //Geeting values from excel to variable
            Evaluate(BoxSeries, GetValueAtCell(RowNo, 1));
            Evaluate(Length_, GetValueAtCell(RowNo, 2));
            Evaluate(Width_, GetValueAtCell(RowNo, 3));
            Evaluate(Height_, GetValueAtCell(RowNo, 4));
            Evaluate(Weight_, GetValueAtCell(RowNo, 5));
            Evaluate(Cbm_, GetValueAtCell(RowNo, 6));
            // Check for duplicates in the SOImportBuffer table.
            SOImportBuffer.Reset();
            SOImportBuffer.SetRange(Length, Length_);
            SOImportBuffer.SetRange(Width, Width_);
            SOImportBuffer.SetRange(Height, Height_);
            SOImportBuffer.SetRange(Weight, Weight_);
            if not SOImportBuffer.FindFirst() then begin
                SOImportBuffer.Init();
                // SOImportBuffer.Reset();
                // if SOImportBuffer.FindLast() then
                //     RecNo := NoSeriesMgt.GetNextNo(NoSeries.Code)
                // else begin
                if SalesReceiveable.get() then
                    SalesReceiveable.TestField("Export Excel Data");
                if NoSeries.Get(SalesReceiveable."Export Excel Data") then
                    RecNo := NoSeriesMgt.GetNextNo(NoSeries.Code);
                // end;
                // Initialize and populate the new record.
                SOImportBuffer.No := Format(RecNo);
                SOImportBuffer.Description := StrSubstNo('%5 %1, %6 %2, %7 %3, %8 %4', Length_, Width_, Height_, Weight_, LenLbl, WidLbl, HeiLbl, WieLbl);
                SOImportBuffer."Box Serial" := BoxSeries;
                SOImportBuffer.Length := Length_;
                SOImportBuffer.Width := Width_;
                SOImportBuffer.Height := Height_;
                SOImportBuffer.Weight := Weight_;
                SOImportBuffer.Cbm := Cbm_;
                SOImportBuffer.Insert();
            end;
        end;
        Message('Excel data imported successfully.');
    end;
    //Read Excel data and return the value
    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
    //                   Creates list of items from the current page
    procedure CreateChildItem()
    var
        Item: Record Item;
        ItemUnitofMeasure: Record "Item Unit of Measure";
        ReadExcelData: Record "Reading Excel";
    begin
        ReadExcelData.FindSet();
        repeat
            Item.SetRange("No. 2", ReadExcelData.No);
            If not Item.FindFirst() then begin
                Item.Init();
                if InvSetup.Get() then begin
                    InvSetup.TestField("Item Nos.");
                    if NoSeries.Get(InvSetup."Item Nos.") then
                        Item."No." := NoSeriesMgt.GetNextNo(NoSeries.Code);
                    Item.Validate("No. 2", ReadExcelData.No);
                    Item.Validate(Description, ReadExcelData.Description);
                    Item.Validate(Type, Item.Type::Inventory);
                    Item."Base Unit of Measure" := 'BOX';
                    Item.Insert();
                    ItemUnitofMeasure.SetRange("Item No.", Item."No.");
                    ItemUnitofMeasure.SetRange(Code, Item."Base Unit of Measure");
                    if not ItemUnitofMeasure.FindFirst() then begin
                        ItemUnitofMeasure.Init();
                        ItemUnitofMeasure.Validate("Item No.", Item."No.");
                        ItemUnitofMeasure.Validate(Code, Item."Base Unit of Measure");
                        ItemUnitofMeasure.Validate(Length, ReadExcelData.Length);
                        ItemUnitofMeasure.Validate(Width, ReadExcelData.Width);
                        ItemUnitofMeasure.Validate(Height, ReadExcelData.Height);
                        ItemUnitofMeasure.Validate(Weight, ReadExcelData.Weight);
                        ItemUnitofMeasure.Validate(Cubage, ReadExcelData.Cbm);
                        ItemUnitofMeasure.Insert();
                    end;
                end;
            end;
        until ReadExcelData.Next() = 0;
        Message('Items are Created Successfully.');
    end;

    var
        LenLbl: Label 'Length: ';
        WidLbl: Label 'Width: ';
        HeiLbl: Label 'Height: ';
        WieLbl: Label 'Weight: ';
}
