report 50033 "Warehouse Batchwise Stock"
{
    //TBC-966 --->
    ApplicationArea = All;
    Caption = 'Warehouse Batchwise Stock';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Posting Date") where("Remaining Quantity" = filter(> 0));

            trigger OnPreDataItem()
            begin
                if StartDate > EndDate then
                    Error('From Date should not be greater than To Date.');

                if (StartDate = 0D) or (EndDate = 0D) then
                    Error('From Date and To Date should not be blank.');

                SetRange("Posting Date", StartDate, EndDate);

                if LocationCode <> '' then
                    SetRange("Location Code", LocationCode);

                // SetFilter("Entry Type", '%1|%2|3%', "Item Ledger Entry"."Entry Type"::Purchase, "Item Ledger Entry"."Entry Type"::"Positive Adjmt.", "Item Ledger Entry"."Entry Type"::Sale);
                SetFilter("Entry Type", '%1|%2|%3',
    "Item Ledger Entry"."Entry Type"::Purchase,
    "Item Ledger Entry"."Entry Type"::"Positive Adjmt.",
    "Item Ledger Entry"."Entry Type"::Sale);

                CreateExcelHeader();
            end;

            trigger OnAfterGetRecord()
            var
                ReceiptQty: Decimal;
                IssueQty: Decimal;
                BalanceQty: Decimal;
            begin
                Clear(IssueQty);
                Clear(BalanceQty);
                Clear(ReceiptQty);
                // For Purchase entry type, only include Purchase Receipt document type
                if "Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."Entry Type"::Purchase then
                    if "Item Ledger Entry"."Document Type" <> "Item Ledger Entry"."Document Type"::"Purchase Receipt" then
                        CurrReport.Skip();

                // Calculate Balance here first — skip the row entirely if Balance = 0
                ReceiptQty := "Item Ledger Entry".Quantity;
                IssueQty := Abs(GetAppliedQuantity("Item Ledger Entry"."Entry No.")); //TBC-966 ABS
                BalanceQty := ReceiptQty - IssueQty;


                if BalanceQty = 0 then
                    CurrReport.Skip();

                CreateExcelBody(ReceiptQty, IssueQty, BalanceQty);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Warehouse)
                {
                    Caption = 'Filters';

                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ShowMandatory = true;
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ShowMandatory = true;
                    }
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Warehouse Code';
                        TableRelation = Location;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin

    end;

    trigger OnPostReport()
    begin
        CreateExcelBook();
    end;



    procedure CreateExcelBody(ReceiptQty: Decimal; IssueQty: Decimal; BalanceQty: Decimal)
    var
        LocationRec: Record Location;
        ItemRec: Record Item;
        PostedPurchaseHeader: Record "Purch. Rcpt. Header";
        PostedPurchaseLine: Record "Purch. Rcpt. Line";
        PuchCommentLine: Record "Purch. Comment Line";
        BinContent: Record "Bin Content";
        LocationName: Text[100];
        CostPerUnit: Decimal;
        Narration: Text[250];
    begin
        ExcelBuffer.NewRow();

        // Posting Date
        ExcelBuffer.AddColumn("Item Ledger Entry"."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        // Location Code
        LocationName := '';
        if "Item Ledger Entry"."Location Code" <> '' then begin
            LocationRec.Reset();
            LocationRec.SetRange(Code, "Item Ledger Entry"."Location Code");
            if LocationRec.FindFirst() then
                LocationName := LocationRec.Name;
        end;
        ExcelBuffer.AddColumn("Item Ledger Entry"."Location Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        // GRN/Document No. 
        ExcelBuffer.AddColumn("Item Ledger Entry"."Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        // Batch/Lot No.
        ExcelBuffer.AddColumn("Item Ledger Entry"."Lot No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        // Item Master Details 
        ItemRec.Reset();
        if "Item Ledger Entry"."Item No." <> '' then
            ItemRec.SetRange("No.", "Item Ledger Entry"."Item No.");

        if ItemRec.FindFirst() then begin
            ExcelBuffer.AddColumn(ItemRec."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ItemRec.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ItemRec.Principal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ItemRec."Item Category 1", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ItemRec."Item Category 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ItemRec."Primary Category 1", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ItemRec."Primary Category 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end else begin
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end;
        // Receipt / Issue / Balance
        ExcelBuffer.AddColumn(ReceiptQty, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(IssueQty, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(BalanceQty, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        // Original Purchase Rate

        CostPerUnit := GetCostPerUnit("Item Ledger Entry"."Entry No.");

        ExcelBuffer.AddColumn(CostPerUnit, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        // MExpiry Date
        PostedPurchaseLine.Reset();
        PostedPurchaseLine.SetRange("Document No.", "Item Ledger Entry"."Document No.");
        PostedPurchaseLine.SetRange("Line No.", "Item Ledger Entry"."Document Line No.");
        PostedPurchaseLine.SetRange("No.", "Item Ledger Entry"."Item No.");
        if PostedPurchaseLine.FindFirst() then
            ExcelBuffer.AddColumn(PostedPurchaseLine.MExpiryDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        // HSN Code
        ExcelBuffer.AddColumn(ItemRec."HSN/SAC Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        // Posted Purchase Receipt Details
        PostedPurchaseHeader.Reset();
        PostedPurchaseHeader.SetRange("No.", "Item Ledger Entry"."Document No.");
        if PostedPurchaseHeader.FindFirst() then begin
            ExcelBuffer.AddColumn(PostedPurchaseHeader."Vendor Bill No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PostedPurchaseHeader."Vendor Bill Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PostedPurchaseHeader."Bill of Entry No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PostedPurchaseHeader."Bill of Entry Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PostedPurchaseHeader."AWB No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PostedPurchaseHeader."AWB Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PostedPurchaseHeader."BL No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PostedPurchaseHeader."BL Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end else begin
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end;
        // Purchase Comment Line
        Clear(Narration);
        PuchCommentLine.Reset();
        PuchCommentLine.SetRange("No.", "Item Ledger Entry"."Document No.");
        PuchCommentLine.SetRange("Document Line No.", 0);
        if PuchCommentLine.FindFirst() then
            Narration := PuchCommentLine.Comment;
        ExcelBuffer.AddColumn(Narration, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        // Warehouse Bin Code
        BinContent.Reset();
        BinContent.SetRange("Location Code", "Item Ledger Entry"."Location Code");
        BinContent.SetRange("Item No.", "Item Ledger Entry"."Item No.");
        BinContent.SetFilter(Default, '%1', true);
        if BinContent.FindFirst() then
            ExcelBuffer.AddColumn(BinContent."Bin Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure GetCostPerUnit(ILEEntryNo: Integer): Decimal
    var
        ValueEntry: Record "Value Entry";
        PurchaseRate: Decimal;
    begin
        PurchaseRate := 0;
        ValueEntry.Reset();
        ValueEntry.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
        ValueEntry.SetRange("Item Ledger Entry No.", ILEEntryNo);
        ValueEntry.SetFilter("Entry Type", '%1|%2', ValueEntry."Entry Type"::"Direct Cost", ValueEntry."Entry Type"::Revaluation);
        if ValueEntry.Findset() then
            repeat
                PurchaseRate += ValueEntry."Cost Amount (Actual)";
            until ValueEntry.Next() = 0;
        exit(PurchaseRate);
    end;

    local procedure GetAppliedQuantity(ILEEntryNo: Integer): Decimal
    var
        ItemApplicationEntry: Record "Item Application Entry";
        TotalApplied: Decimal;
    begin
        TotalApplied := 0;
        ItemApplicationEntry.Reset();
        ItemApplicationEntry.SetRange("Inbound Item Entry No.", ILEEntryNo);
        ItemApplicationEntry.SetFilter("Outbound Item Entry No.", '<>%1', 0);
        if ItemApplicationEntry.FindSet() then
            repeat
                TotalApplied += ItemApplicationEntry.Quantity;
            until ItemApplicationEntry.Next() = 0;
        exit(TotalApplied);
    end;

    procedure CreateExcelHeader()
    var
        RunDateTime: DateTime;
        DateTxt: Text;
        TimeTxt: Text;
    begin
        RunDateTime := CurrentDateTime;
        DateTxt := Format(DT2Date(RunDateTime), 0, '<Day,2>-<Month,2>-<Year4>');
        TimeTxt := Format(DT2Time(RunDateTime), 0, '<Hours12,2>:<Minutes,2><AM/PM>');

        ExcelBuffer.NewRow();
        //ExcelBuffer.AddColumn('Warehouse wise stock as on ' + DateTxt + ' - run time ' + TimeTxt, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 1
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 2
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 3
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 4
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Warehouse wise stock from ' + Format(StartDate) + ' to ' + Format(EndDate) + ' - Run Time ' + TimeTxt, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Warehouse', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('GRN No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Batch No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Product Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Product Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Principal', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Category 1', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Category 2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Primary Category 1', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Primary Category 2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Receipt', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Issue', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Purchase Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Depreciated Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('M Expiry Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HSN Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Bill No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Bill Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Bill of Entry No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Bill of Entry Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('AWB No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('AWB Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BL No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BL Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('sNarration', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('sRemark', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Warehouse Bin Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('Warehouse Batchwise Stock');
        ExcelBuffer.WriteSheet('Warehouse Batchwise Stock', '', '');
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Warehouse Batchwise Stock_' + Format(DT2Date(CurrentDateTime), 0, '<Day,2>-<Month,2>-<Year4>') + '_' + Format(DT2Time(CurrentDateTime), 0, '<Hours24>:<Minutes,2>'));
        ExcelBuffer.OpenExcel();
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        LocationCode: Code[10];
        StartDate: Date;
        EndDate: Date;

    //TBC-966 <---
    //OLD Code by Guru --->
    // ApplicationArea = All;
    // Caption = 'Warehouse Batchwise Stock';
    // UsageCategory = ReportsAndAnalysis;
    // ProcessingOnly = true;

    // dataset
    // {
    //     dataitem("Item Ledger Entry"; "Item Ledger Entry")
    //     {
    //         DataItemTableView = sorting("Posting Date");

    //         trigger OnPreDataItem()
    //         begin
    //             if LocationCode <> '' then
    //                 SetRange("Location Code", LocationCode);

    //             SetFilter("Entry Type", '%1|%2', "Item Ledger Entry"."Entry Type"::Purchase, "Item Ledger Entry"."Entry Type"::"Positive Adjmt.");
    //             CreateExcelHeader();
    //         end;

    //         trigger OnAfterGetRecord()
    //         var
    //             ReceiptQty: Decimal;
    //             IssueQty: Decimal;
    //             BalanceQty: Decimal;
    //         begin
    //             // For Purchase entry type, only include Purchase Receipt document type
    //             if "Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."Entry Type"::Purchase then
    //                 if "Item Ledger Entry"."Document Type" <> "Item Ledger Entry"."Document Type"::"Purchase Receipt" then
    //                     CurrReport.Skip();

    //             // Calculate Balance here first — skip the row entirely if Balance = 0
    //             ReceiptQty := "Item Ledger Entry".Quantity;
    //             IssueQty := GetAppliedQuantity("Item Ledger Entry"."Entry No.");
    //             BalanceQty := ReceiptQty + IssueQty;

    //             if BalanceQty = 0 then
    //                 CurrReport.Skip();

    //             CreateExcelBody(ReceiptQty, IssueQty, BalanceQty);
    //         end;
    //     }
    // }

    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(Warehouse)
    //             {
    //                 field(LocationCode; LocationCode)
    //                 {
    //                     ApplicationArea = All;
    //                     Caption = 'Warehouse Code';
    //                     TableRelation = Location;
    //                 }
    //             }
    //         }
    //     }
    // }

    // trigger OnPostReport()
    // begin
    //     CreateExcelBook();
    // end;

    // var
    //     ExcelBuffer: Record "Excel Buffer" temporary;
    //     LocationCode: Code[10];

    // procedure CreateExcelBody(ReceiptQty: Decimal; IssueQty: Decimal; BalanceQty: Decimal)
    // var
    //     LocationRec: Record Location;
    //     ItemRec: Record Item;
    //     PostedPurchaseHeader: Record "Purch. Rcpt. Header";
    //     PostedPurchaseLine: Record "Purch. Rcpt. Line";
    //     PuchCommentLine: Record "Purch. Comment Line";
    //     BinContent: Record "Bin Content";
    //     LocationName: Text[100];
    //     CostPerUnit: Decimal;
    //     Narration: Text[250];
    // begin
    //     ExcelBuffer.NewRow();

    //     // Posting Date
    //     ExcelBuffer.AddColumn("Item Ledger Entry"."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
    //     // Location Code
    //     LocationName := '';
    //     if "Item Ledger Entry"."Location Code" <> '' then begin
    //         LocationRec.Reset();
    //         LocationRec.SetRange(Code, "Item Ledger Entry"."Location Code");
    //         if LocationRec.FindFirst() then
    //             LocationName := LocationRec.Name;
    //     end;
    //     ExcelBuffer.AddColumn("Item Ledger Entry"."Location Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     // GRN/Document No. 
    //     ExcelBuffer.AddColumn("Item Ledger Entry"."Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     // Batch/Lot No.
    //     ExcelBuffer.AddColumn("Item Ledger Entry"."Lot No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     // Item Master Details 
    //     ItemRec.Reset();
    //     if "Item Ledger Entry"."Item No." <> '' then
    //         ItemRec.SetRange("No.", "Item Ledger Entry"."Item No.");

    //     if ItemRec.FindFirst() then begin
    //         ExcelBuffer.AddColumn(ItemRec."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(ItemRec.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(ItemRec.Principal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(ItemRec."Item Category 1", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(ItemRec."Item Category 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(ItemRec."Primary Category 1", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(ItemRec."Primary Category 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     end else begin
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     end;
    //     // Receipt / Issue / Balance
    //     ExcelBuffer.AddColumn(ReceiptQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    //     ExcelBuffer.AddColumn(IssueQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    //     ExcelBuffer.AddColumn(BalanceQty, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    //     // Original Purchase Rate
    //     CostPerUnit := GetCostPerUnit("Item Ledger Entry"."Entry No.");
    //     ExcelBuffer.AddColumn(CostPerUnit, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    //     ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    //     ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    //     // MExpiry Date
    //     PostedPurchaseLine.Reset();
    //     PostedPurchaseLine.SetRange("Document No.", "Item Ledger Entry"."Document No.");
    //     PostedPurchaseLine.SetRange("Line No.", "Item Ledger Entry"."Document Line No.");
    //     PostedPurchaseLine.SetRange("No.", "Item Ledger Entry"."Item No.");
    //     if PostedPurchaseLine.FindFirst() then
    //         ExcelBuffer.AddColumn(PostedPurchaseLine.MExpiryDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
    //     else
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     // HSN Code
    //     ExcelBuffer.AddColumn(ItemRec."HSN/SAC Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     // Posted Purchase Receipt Details
    //     PostedPurchaseHeader.Reset();
    //     PostedPurchaseHeader.SetRange("No.", "Item Ledger Entry"."Document No.");
    //     if PostedPurchaseHeader.FindFirst() then begin
    //         ExcelBuffer.AddColumn(PostedPurchaseHeader."Vendor Bill No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(PostedPurchaseHeader."Vendor Bill Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(PostedPurchaseHeader."Bill of Entry No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(PostedPurchaseHeader."Bill of Entry Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(PostedPurchaseHeader."AWB No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(PostedPurchaseHeader."AWB Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(PostedPurchaseHeader."BL No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn(PostedPurchaseHeader."BL Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     end else begin
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     end;
    //     // Purchase Comment Line
    //     Clear(Narration);
    //     PuchCommentLine.Reset();
    //     PuchCommentLine.SetRange("No.", "Item Ledger Entry"."Document No.");
    //     PuchCommentLine.SetRange("Document Line No.", 0);
    //     if PuchCommentLine.FindFirst() then
    //         Narration := PuchCommentLine.Comment;
    //     ExcelBuffer.AddColumn(Narration, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     // Warehouse Bin Code
    //     BinContent.Reset();
    //     BinContent.SetRange("Location Code", "Item Ledger Entry"."Location Code");
    //     BinContent.SetRange("Item No.", "Item Ledger Entry"."Item No.");
    //     BinContent.SetFilter(Default, '%1', true);
    //     if BinContent.FindFirst() then
    //         ExcelBuffer.AddColumn(BinContent."Bin Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
    //     else
    //         ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    // end;

    // local procedure GetCostPerUnit(ILEEntryNo: Integer): Decimal
    // var
    //     ValueEntry: Record "Value Entry";
    //     PurchaseRate: Decimal;
    // begin
    //     PurchaseRate := 0;
    //     ValueEntry.Reset();
    //     ValueEntry.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
    //     ValueEntry.SetRange("Item Ledger Entry No.", ILEEntryNo);
    //     ValueEntry.SetFilter("Entry Type", '%1|%2', ValueEntry."Entry Type"::"Direct Cost", ValueEntry."Entry Type"::Revaluation);
    //     if ValueEntry.Findset() then
    //         repeat
    //             PurchaseRate += ValueEntry."Cost per Unit";
    //         until ValueEntry.Next() = 0;
    //     exit(PurchaseRate);
    // end;

    // local procedure GetAppliedQuantity(ILEEntryNo: Integer): Decimal
    // var
    //     ItemApplicationEntry: Record "Item Application Entry";
    //     TotalApplied: Decimal;
    // begin
    //     TotalApplied := 0;
    //     ItemApplicationEntry.Reset();
    //     ItemApplicationEntry.SetRange("Inbound Item Entry No.", ILEEntryNo);
    //     ItemApplicationEntry.SetFilter("Outbound Item Entry No.", '<>%1', 0);
    //     if ItemApplicationEntry.FindSet() then
    //         repeat
    //             TotalApplied += ItemApplicationEntry.Quantity;
    //         until ItemApplicationEntry.Next() = 0;
    //     exit(TotalApplied);
    // end;

    // procedure CreateExcelHeader()
    // var
    //     RunDateTime: DateTime;
    //     DateTxt: Text;
    //     TimeTxt: Text;
    // begin
    //     RunDateTime := CurrentDateTime;
    //     DateTxt := Format(DT2Date(RunDateTime), 0, '<Day,2>-<Month,2>-<Year4>');
    //     TimeTxt := Format(DT2Time(RunDateTime), 0, '<Hours12,2>:<Minutes,2><AM/PM>');

    //     ExcelBuffer.NewRow();
    //     ExcelBuffer.AddColumn('Warehouse wise stock as on ' + DateTxt + ' - run time ' + TimeTxt, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

    //     ExcelBuffer.NewRow();
    //     ExcelBuffer.AddColumn('Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Warehouse', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('GRN No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Batch No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Product Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Product Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Principal', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Item Category 1', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Item Category 2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Primary Category 1', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Primary Category 2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Receipt', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Issue', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Original Purchase Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Depreciated Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('M Expiry Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('HSN Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Bill No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Bill Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Bill of Entry No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Bill of Entry Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('AWB No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('AWB Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('BL No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('BL Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('sNarration', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('sRemark', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    //     ExcelBuffer.AddColumn('Warehouse Bin Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    // end;

    // local procedure CreateExcelBook()
    // begin
    //     ExcelBuffer.CreateNewBook('Warehouse Batchwise Stock');
    //     ExcelBuffer.WriteSheet('Warehouse Batchwise Stock', '', '');
    //     ExcelBuffer.CloseBook();
    //     ExcelBuffer.SetFriendlyFilename('Warehouse Batchwise Stock_' + Format(DT2Date(CurrentDateTime), 0, '<Day,2>-<Month,2>-<Year4>') + '_' + Format(DT2Time(CurrentDateTime), 0, '<Hours24>:<Minutes,2>'));
    //     ExcelBuffer.OpenExcel();
    // end;
    //OLD Code by Guru <---
}