report 50024 "Pending Orders Register"
{
    Caption = 'Pending Orders Register';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.") where("Document Type" = const(Order));

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");// where("Quantity Shipped" = filter(= 0));

                trigger OnAfterGetRecord()
                begin
                    if "Quantity Shipped" >= Quantity then
                        CurrReport.Skip();
                    MakeExcelDataBody();
                end;
            }

            trigger OnPreDataItem()
            begin
                if (StartDate = 0D) or (EndDate = 0D) then
                    Error('From Date and To Date should not be blank.');

                if StartDate > EndDate then
                    Error('From Date should not be greater than To Date.');

                SetRange("Posting Date", StartDate, EndDate);

                if SalesOrdeType <> SalesOrdeType::" " then
                    SetRange("Sales Order Type", Format(SalesOrdeType));

                if LocationCode <> '' then
                    SetRange("Location Code", LocationCode);

                MakeExcelDataHeader();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(DateFilter)
                {
                    Caption = 'Filters';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                    field(SalesOrdeType; SalesOrdeType)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Order Type';
                        OptionCaption = ' ,AMC,CLAIMS,CMC,CONSUMBALE,INSTRUMENT,SPARES,SERVICES';
                    }
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Location Code';
                        TableRelation = Location.Code;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        Clear(SalesType);

        GrandTotalPrepaymentAmount := 0;
        GrandTotalQty := 0;
        GrandTotalLineAmount := 0;
        GrandTotalInvoiceDiscountAmount := 0;
        GrandTotalTaxable := 0;
        GrandTotalCGSTPer := 0;
        GrandTotalSGSTPer := 0;
        GrandTotalIGSTPer := 0;
        GrandTotalCGST := 0;
        GrandTotalSGST := 0;
        GrandTotalIGST := 0;
        GrandTotalInvoiceValue := 0;
        GrandTotalOriginalAmount := 0;
        GrandTotalRoundedAmount := 0;
        GrandTotalRoundOffDiff := 0;
        LineAmount := 0;
        SubTotal := 0;
        GrandTotalRate := 0;
        GrandTotalDisountPercentage := 0;
        GrandTotalReorderLevel := 0;
        GrandTotalClosingStk := 0;
        GrandTotalOrderQty := 0;
        GrandTotalOnHandQty := 0; //TBC - 929
        ExcelBuffer.DELETEALL;
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPostReport()
    begin
        AddGrandTotalRow();
        CreateExcelBook();
    end;

    var
        StartDate: Date;
        EndDate: Date;
        SalesOrdeType: Option " ",AMC,CLAIMS,CMC,CONSUMBALE,INSTRUMENT,SPARES,SERVICES;
        ExcelBuffer: Record "Excel Buffer" temporary;
        ILE: Record "Item Ledger Entry";
        AvailableInventory: Decimal;
        CompanyInfo: Record "Company Information";
        DiscountAmount: Decimal;
        TaxbleAmount: Decimal;
        Dimension: Record "Dimension Value";
        Cust: Record Customer;
        Loc: Record Location;
        RecState: Record State;
        PaymentTerms: Record "Payment Terms";
        ConsigneeAddress: Text;
        SalesCommentLine: Record "Sales Comment Line";
        RecItem: Record Item;
        ItemCategory: Record "Item Category";
        ShiptoAddress: Record "Ship-to Address";
        SalesShipmentLine: Record "Sales Line";

        Narration: Text;
        LineNarration: Text;

        GrandTotalLineAmount: Decimal;

        GrandTotalTaxable: Decimal;
        GrandTotalCGST: Decimal;
        GrandTotalSGST: Decimal;
        GrandTotalIGST: Decimal;
        GrandTotalOriginalAmount: Decimal;
        GrandTotalRoundedAmount: Decimal;
        GrandTotalRoundOffDiff: Decimal;
        GrandTotalQty: Decimal;
        GrandTotalInvoiceValue: Decimal;
        GrandTotalInvoiceDiscountAmount: Decimal;
        GrandTotalPrepaymentAmount: Decimal;
        GrandTotalRate: Decimal;
        GrandTotalCGSTPer: Decimal;
        GrandTotalSGSTPer: Decimal;
        GrandTotalIGSTPer: Decimal;
        GrandTotalDisountPercentage: Decimal;
        OriginalAmount: Decimal;
        RoundedAmount: Decimal;
        RoundOffDiff: Decimal;
        LineAmount: Decimal;
        SubTotal: Decimal;
        SalesType: Text;

        LocationCode: Code[10];
        WarehouseNameHeader: Text;
        GrandTotalFinalAmount: Decimal;
        GrandTotalReorderLevel: Decimal;
        GrandTotalClosingStk: Decimal;
        SalesHeader: Record "Sales Header";
        SL: Record "Sales Line";
        GrandTotalBalQty: Decimal;
        GrandTotalOrderQty: Decimal;
        GrandTotalOnHandQty: Decimal; //TBC - 929
        OnHandQty: Decimal;//TBC - 929

    local procedure MakeExcelDataHeader()
    begin
        // Company Name (centered visually)
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 1
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 2
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 3
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 4
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CompanyInfo.Name, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 5 (center)

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 1
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 2
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 3
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 4
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        SalesType := '';
        if SalesOrdeType = SalesOrdeType::" " then
            SalesType := 'Listing of documents of All Sales Order vs All Delivery Challan'
        else
            SalesType := 'Listing of documents of ' + Format(SalesOrdeType) + ' vs ' + Format(SalesOrdeType) + ' Delivery Challan';

        ExcelBuffer.AddColumn(Format(SalesType), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 1
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 2
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 3
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 4
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        WarehouseNameHeader := '';
        if LocationCode <> '' then
            WarehouseNameHeader := 'Warehouse Name = ' + Format(LocationCode)
        else
            WarehouseNameHeader := 'Warehouse Name = All Warehouse';
        ExcelBuffer.AddColumn(WarehouseNameHeader, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 1
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 2
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 3
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Col 4
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('[ Previous Month ' + Format(StartDate) + ' to ' + Format(EndDate) + ' ]', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();

        // Column headers
        ExcelBuffer.AddColumn('Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn('Voucher', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regional Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regional Office', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regional Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regional Group', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sales Type Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Account Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Account Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Key/Non Key Result', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Executive Master Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Executive Master-2 Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Party PO No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Party PO Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Departments Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Departments', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Principle', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Warehouse Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Warehouse Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Order Qty.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Balance Qty.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('On Hand Stock', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); //TBC - 929
        ExcelBuffer.AddColumn('Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Gross', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Discount %_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Discount Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CGST_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CGST Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SGST_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SGST Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IGST_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IGST Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Final Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Reorder Level', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        //ExcelBuffer.AddColumn('Closing Stock', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Status', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Authorize Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Payment Term Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Consignee.Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Consignee.Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Consignee Address', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Remarks', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Lead Time(In Days)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Approval Ref.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('RDC No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('RDC Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Special Instruction', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody()
    var
        LineAmount: Decimal;
        SubTotal: Decimal;
        RoundedAmount: Decimal;
        RoundOffDiff: Decimal;
        Narration: Text;
        LineNarration: Text;
        DimensionValue: Text;
        CustKeyValue: Text;
        LocationName: Text;
        TotalOrderQty: Decimal;
        BalancyQty: Decimal;
    begin
        ExcelBuffer.NewRow();

        // -----------------------------
        // Header Columns
        // -----------------------------

        ExcelBuffer.AddColumn("Sales Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date); // Date
        ExcelBuffer.AddColumn("Sales Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); // Document No.
        ExcelBuffer.AddColumn("Sales Header"."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        // Shortcut Dimensions
        DimensionValue := '';
        Dimension.Reset();
        Dimension.SetRange(Code, "Sales Header"."Shortcut Dimension 2 Code");
        if Dimension.FindFirst() then
            DimensionValue := Dimension.Name;
        ExcelBuffer.AddColumn(DimensionValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Header"."Shortcut Dimension 3 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        DimensionValue := '';
        Dimension.Reset();
        Dimension.SetRange(Code, "Sales Header"."Shortcut Dimension 3 Code");
        if Dimension.FindFirst() then
            DimensionValue := Dimension.Name;
        ExcelBuffer.AddColumn(DimensionValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Header"."Sales Order Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Header"."Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        if Cust.Get("Sales Header"."Sell-to Customer No.") then begin
            if Cust."KEY/NON KEY(Schimatzu)" = Cust."KEY/NON KEY(Schimatzu)"::Yes then
                CustKeyValue := 'Key'
            else if Cust."KEY/NON KEY(Schimatzu)" = Cust."KEY/NON KEY(Schimatzu)"::No then
                CustKeyValue := 'Non Key'
            else
                CustKeyValue := '';

            ExcelBuffer.AddColumn(CustKeyValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        end else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Header"."Executive Master", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        if "Sales Header"."Executive Master2" <> '' then
            ExcelBuffer.AddColumn("Sales Header"."Executive Master2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Header"."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Header"."Customer PO Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Sales Header"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);

        DimensionValue := '';
        Dimension.Reset();
        Dimension.SetRange(Code, "Sales Header"."Shortcut Dimension 1 Code");
        if Dimension.FindFirst() then
            DimensionValue := Dimension.Name;
        ExcelBuffer.AddColumn(DimensionValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // Principal
        if SL.Get("Sales Line"."Document Type", "Sales Line"."Document No.", "Sales Line"."Line No.") then
            ExcelBuffer.AddColumn(SL.Principal, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        LocationName := '';
        If Loc.Get("Sales Header"."Location Code") then
            LocationName := Loc.Name;
        ExcelBuffer.AddColumn(LocationName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // -----------------------------
        // Item Details
        // -----------------------------
        ExcelBuffer.AddColumn("Sales Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Line"."Description", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //TBC - 929 -->
        Clear(OnHandQty);

        ILE.Reset();
        ILE.SetRange("Item No.", "Sales Line"."No.");
        ILE.SetRange(Open, true);
        ILE.SetFilter("Remaining Quantity", '>%1', 0);
        if LocationCode <> '' then
            ILE.SetRange("Location Code", LocationCode)
        else
            if "Sales Header"."Location Code" <> '' then
                ILE.SetRange("Location Code", "Sales Header"."Location Code");

        if ILE.FindSet() then
            repeat
                OnHandQty += ILE."Remaining Quantity";
            until ILE.Next() = 0;
        //TBC - 929 <--


        ExcelBuffer.AddColumn("Sales Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        BalancyQty := 0;
        BalancyQty := Abs("Sales Line".Quantity - "Sales Line"."Quantity Shipped");
        ExcelBuffer.AddColumn(BalancyQty, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Sales Line"."Quantity", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //TBC - 929 -->
        if OnHandQty <> 0 then
            ExcelBuffer.AddColumn(OnHandQty, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        //TBC - 929 <--

        ExcelBuffer.AddColumn("Sales Line"."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Sales Line"."Quantity" * "Sales Line"."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Sales Line"."Line Discount %", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        DiscountAmount := 0;
        DiscountAmount := ("Sales Line"."Quantity" * "Sales Line"."Unit Price") * "Sales Line"."Line Discount %" / 100;
        ExcelBuffer.AddColumn(DiscountAmount, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        TaxbleAmount := 0;
        TaxbleAmount := ("Sales Line"."Quantity" * "Sales Line"."Unit Price") - DiscountAmount;
        ExcelBuffer.AddColumn(TaxbleAmount, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn("Sales Line"."CGST Percentage", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Sales Line"."CGST Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Sales Line"."SGST Percentage", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Sales Line"."SGST Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Sales Line"."IGST Percentage", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Sales Line"."IGST Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn(TaxbleAmount + "Sales Line"."CGST Amount" + "Sales Line"."SGST Amount" + "Sales Line"."IGST Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Sales Line"."MOQ Quantity", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);

        // AvailableInventory := 0;
        // if RecItem.Get("Sales Line"."No.") then
        //     if RecItem.Type = RecItem.Type::Inventory then begin
        //         RecItem.CalcFields(Inventory);
        //         AvailableInventory := RecItem.Inventory;
        //     end else
        //         AvailableInventory := 0;

        // ExcelBuffer.AddColumn(AvailableInventory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        if PaymentTerms.Get("Sales Header"."Payment Terms Code") then
            ExcelBuffer.AddColumn(PaymentTerms.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Header"."Ship-to Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Header"."Ship-to Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ConsigneeAddress := '';
        ConsigneeAddress := "Sales Header"."Ship-to Address" + '' + "Sales Header"."Ship-to Address 2"
        + ' ' + "Sales Header"."Ship-to City" + ' ' + "Sales Header"."Ship-to County" + ' ' + "Sales Header"."Ship-to Post Code";
        ExcelBuffer.AddColumn(ConsigneeAddress, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // // // Sales Header Comments
        // Clear(Narration);
        // SalesCommentLine.Reset();
        // SalesCommentLine.SetRange("No.", "Sales Header"."No.");
        // SalesCommentLine.SetRange("Document Line No.", 0);
        // if SalesCommentLine.FindSet() then
        //     repeat
        //         if Narration = '' then
        //             Narration := SalesCommentLine.Comment
        //         else
        //             Narration := Narration + ' ' + SalesCommentLine.Comment;
        //     until SalesCommentLine.Next() = 0;
        // ExcelBuffer.AddColumn(Narration, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);


        // // Line Narration
        Clear(LineNarration);
        SalesCommentLine.Reset();
        SalesCommentLine.SetRange("No.", "Sales Header"."No.");
        SalesCommentLine.SetRange("Document Line No.", "Sales Line"."Line No.");
        if SalesCommentLine.FindSet() then
            repeat
                if LineNarration = '' then
                    LineNarration := SalesCommentLine.Comment
                else
                    LineNarration := LineNarration + ' ' + SalesCommentLine.Comment;
            until SalesCommentLine.Next() = 0;
        ExcelBuffer.AddColumn(LineNarration, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Sales Line"."Lead Time Calculation", FALSE, '', FALSE, FALSE, FALSE, '#,##0', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Header"."RDC No", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Header"."RDC Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Sales Header"."Special Instruction", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Grand Total
        GrandTotalPrepaymentAmount += "Sales Header"."Prepayment Amount";
        GrandTotalQty += "Sales Line"."Quantity";
        GrandTotalRate += "Sales Line"."Unit Price";
        GrandTotalLineAmount += "Sales Line"."Quantity" * "Sales Line"."Unit Price";
        GrandTotalDisountPercentage += "Sales Line"."Line Discount %";
        GrandTotalInvoiceDiscountAmount += ("Sales Line"."Quantity" * "Sales Line"."Unit Price") * "Sales Line"."Line Discount %" / 100;
        GrandTotalTaxable += ("Sales Line"."Quantity" * "Sales Line"."Unit Price") - DiscountAmount;
        GrandTotalCGSTPer += "Sales Line"."CGST Percentage";
        GrandTotalSGSTPer += "Sales Line"."SGST Percentage";
        GrandTotalIGSTPer += "Sales Line"."IGST Percentage";
        GrandTotalCGST += "Sales Line"."CGST Amount";
        GrandTotalSGST += "Sales Line"."SGST Amount";
        GrandTotalIGST += "Sales Line"."IGST Amount";
        GrandTotalFinalAmount += TaxbleAmount + "Sales Line"."CGST Amount" + "Sales Line"."SGST Amount" + "Sales Line"."IGST Amount";
        GrandTotalReorderLevel += "Sales Line"."MOQ Quantity";
        //GrandTotalClosingStk += AvailableInventory;
        GrandTotalOrderQty += "Sales Line".Quantity;
        GrandTotalBalQty += BalancyQty;
        GrandTotalOnHandQty += OnHandQty;  //TBC - 929
    end;


    local procedure AddGrandTotalRow()
    begin
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Grand Total', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Date
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Dept
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);                                                                          // … keep empty columns SAME as body until Line Amount
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(GrandTotalOrderQty, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(Abs(GrandTotalBalQty), false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalQty, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalOnHandQty, FALSE, '', true, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);  //TBC - 929
        ExcelBuffer.AddColumn(GrandTotalRate, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalLineAmount, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalDisountPercentage, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalInvoiceDiscountAmount, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalTaxable, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalCGSTPer, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalCGST, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalSGSTPer, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalSGST, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalIGSTPer, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalIGST, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalFinalAmount, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalReorderLevel, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        //ExcelBuffer.AddColumn(GrandTotalClosingStk, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
    end;

    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('Pending Orders Register');
        ExcelBuffer.WriteSheet('Pending Orders Register', '_', UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Pending Orders Register' + '_' + UserId);
        ExcelBuffer.OpenExcel();
    end;
}
