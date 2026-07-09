report 50023 "Order Booking Statement"
{
    Caption = 'Order Booking Statement';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("No.") where("Document Type" = const(Order));

            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Document Type" = field("Document Type"),
                               "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where(Quantity = filter(<> 0));

                trigger OnAfterGetRecord()
                begin

                    MakeExcelDataBody();
                    LineAmount := (SalesLine."Quantity" * SalesLine."Unit Price") - SalesLine."Line Discount Amount";

                    SubTotal := LineAmount + SalesLine."CGST Amount" + SalesLine."SGST Amount" + SalesLine."IGST Amount";

                    RoundedAmount := ROUND(SubTotal, 1, '=');
                    RoundOffDiff := RoundedAmount - SubTotal;

                end;
            }

            trigger OnPreDataItem()
            begin
                // if (StartDate = 0D) or (EndDate = 0D) then
                //     Error('From Date and To Date should not be blank.');

                // if StartDate > EndDate then
                //     Error('From Date should not be greater than To Date.');

                if (StartDate <> 0D) AND (EndDate <> 0D) then
                    SetRange("Posting Date", StartDate, EndDate);

                if (OrderCreatedStartDate <> 0D) AND (OrderCreatedEndDate <> 0D) then
                    SetRange("Order Date", OrderCreatedStartDate, OrderCreatedEndDate);

                if SalesOrdeType <> SalesOrdeType::" " then
                    SetRange("Sales Order Type", Format(SalesOrdeType));

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
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Start Date';

                        trigger OnValidate()
                        begin
                            if (StartDate <> 0D) and
                               ((OrderCreatedStartDate <> 0D) or (OrderCreatedEndDate <> 0D))
                            then
                                Error('You cannot enter Posting Start Date and Order Created Dates at the same time. Please clear Order Created From Date and Order Created To Date.');
                        end;
                    }

                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting End Date';

                        trigger OnValidate()
                        begin
                            if (EndDate <> 0D) and
                               ((OrderCreatedStartDate <> 0D) or (OrderCreatedEndDate <> 0D))
                            then
                                Error('You cannot enter Posting End Date and Order Created Dates at the same time. Please clear Order Created From Date and Order Created To Date.');
                        end;
                    }

                    field(OrderCreatedStartDate; OrderCreatedStartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Order Created Start Date';

                        trigger OnValidate()
                        begin
                            if (OrderCreatedStartDate <> 0D) and
                               ((StartDate <> 0D) or (EndDate <> 0D))
                            then
                                Error('You cannot enter Order Created Start Date and Posting Dates at the same time. Please clear Posting Start Date and Posting End Date.');
                        end;
                    }
                    field(OrderCreatedEndDate; OrderCreatedEndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Order Created End Date';

                        trigger OnValidate()
                        begin
                            if (OrderCreatedEndDate <> 0D) and
                               ((StartDate <> 0D) or (EndDate <> 0D))
                            then
                                Error('You cannot enter Order Created End Date and Posting Dates at the same time. Please clear Posting Start Date and Posting End Date.');
                        end;
                    }
                    field(SalesOrdeType; SalesOrdeType)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Order Type';
                        OptionCaption = ' ,AMC,CLAIMS,CMC,CONSUMBALE,INSTRUMENT,SPARES,SERVICES';
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
        ExcelBuffer.DELETEALL;
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(Picture);

        //TBC-1067 ---->
        // Ensure at least one date pair is entered
        if (StartDate = 0D) and (EndDate = 0D) and
           (OrderCreatedStartDate = 0D) and (OrderCreatedEndDate = 0D)
        then
            Error('Please enter either Posting Date range or Order Created Date range.');

        // Ensure both dates are entered pair wise
        if (StartDate <> 0D) and (EndDate = 0D) then
            Error('Please enter Posting End Date.');

        if (StartDate = 0D) and (EndDate <> 0D) then
            Error('Please enter Posting Start Date.');

        if (OrderCreatedStartDate <> 0D) and (OrderCreatedEndDate = 0D) then
            Error('Please enter Order Created End Date.');

        if (OrderCreatedStartDate = 0D) and (OrderCreatedEndDate <> 0D) then
            Error('Please enter Order Created Start Date.');

        // Ensure Start is not greater than End
        if (StartDate <> 0D) and (StartDate > EndDate) then
            Error('Posting Start Date cannot be greater than Posting End Date.');

        if (OrderCreatedStartDate <> 0D) and (OrderCreatedStartDate > OrderCreatedEndDate) then
            Error('Order Created Start Date cannot be greater than Order Created End Date.');
        //TBC-1067 <----
    end;

    trigger OnPostReport()
    begin
        AddGrandTotalRow();
        CreateExcelBook();
    end;

    var
        StartDate: Date;
        EndDate: Date;
        OrderCreatedStartDate: Date;
        OrderCreatedEndDate: Date;
        SalesOrdeType: Option " ",AMC,CLAIMS,CMC,CONSUMBALE,INSTRUMENT,SPARES,SERVICES;
        ExcelBuffer: Record "Excel Buffer" temporary;
        CompanyInfo: Record "Company Information";
        Dimension: Record "Dimension Value";
        Cust: Record Customer;
        Loc: Record Location;
        RecState: Record State;
        PaymentTerms: Record "Payment Terms";
        SalesCommentLine: Record "Sales Comment Line";
        Item: Record Item;
        ItemCategory: Record "Item Category";
        ShiptoAddress: Record "Ship-to Address";
        SL: Record "Sales Line";

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
        GrandTotalCGSTPer: Decimal;
        GrandTotalSGSTPer: Decimal;
        GrandTotalIGSTPer: Decimal;

        OriginalAmount: Decimal;
        RoundedAmount: Decimal;
        RoundOffDiff: Decimal;
        LineAmount: Decimal;
        SubTotal: Decimal;
        SalesType: Text;

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
        // Spare Sales Order (centered visually)
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

        if SalesOrdeType = SalesOrdeType::" " then
            SalesType := 'All Sales Order'
        else
            SalesType := Format(SalesOrdeType) + ' Sales Order';


        ExcelBuffer.AddColumn(Format(SalesType), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);


        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        // Date Range
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

        ExcelBuffer.AddColumn(
     '[ Previous Month ' + Format(StartDate) + ' to ' + Format(EndDate) + ' ]',
     false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);


        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);



        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();

        // Column headers
        ExcelBuffer.AddColumn('Document No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Order Create Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn('Order Posting Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn('Departments Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regional Office Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regional Group Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('GST Regiona State Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Executive Master Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Executive Master-2 Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sales Type Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Warehouse Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CustomerAC. Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CustomerAC. Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer GSTN No', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Key/Non Key Result', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Consignee.Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Consignee.Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Consignee GSTN No', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Party PO No', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Party PO Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Kind Attn', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Payment Term Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Delivery Terms Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Freight Terms Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Advance Recd Amt', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Narration', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Special Instruction', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Special Remarks - Sez', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('RDC No', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('RDC Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Order Master Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Principle Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HSN Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Unit Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Gross', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Discount %_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Discount Amt', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Pkg_Fwdg', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Insurance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CGST_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CGST Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SGST_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SGST Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IGST_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IGST Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sub Total', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Round Off', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Voucher amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Remarks', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        //TBC - 928 -->
        ExcelBuffer.AddColumn('Primary Category 1', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Primary Category 2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Category 1', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Category 2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        //TBC - 928 <--
        ExcelBuffer.AddColumn('Item Category Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Authorize by', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Authorize Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Lead Time(In Days)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Contact No', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        //TBC - 917
        ExcelBuffer.AddColumn('Email Address', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Service Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
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
    begin
        ExcelBuffer.NewRow();

        // -----------------------------
        // Header Columns
        // -----------------------------
        ExcelBuffer.AddColumn(SalesHeader."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); // Document No.
        ExcelBuffer.AddColumn(SalesHeader."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(SalesHeader."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date); // Date

        // Shortcut Dimensions
        DimensionValue := '';
        Dimension.Reset();
        Dimension.SetRange(Code, SalesHeader."Shortcut Dimension 1 Code");
        if Dimension.FindFirst() then
            DimensionValue := Dimension.Name;
        ExcelBuffer.AddColumn(DimensionValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        DimensionValue := '';
        Dimension.Reset();
        Dimension.SetRange(Code, SalesHeader."Shortcut Dimension 2 Code");
        if Dimension.FindFirst() then
            DimensionValue := Dimension.Name;
        ExcelBuffer.AddColumn(DimensionValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        DimensionValue := '';
        Dimension.Reset();
        Dimension.SetRange(Code, SalesHeader."Shortcut Dimension 3 Code");
        if Dimension.FindFirst() then
            DimensionValue := Dimension.Name;
        ExcelBuffer.AddColumn(DimensionValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // State from Location
        if Loc.Get(SalesHeader."Location Code") then
            if RecState.Get(Loc."State Code") then
                ExcelBuffer.AddColumn(RecState.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // Executives
        ExcelBuffer.AddColumn(SalesHeader."Executive Master", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        if SalesHeader."Executive Master2" <> '' then
            ExcelBuffer.AddColumn(SalesHeader."Executive Master2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('NA', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // Sales Order Info
        ExcelBuffer.AddColumn(SalesHeader."Sales Order Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // Customer Details
        ExcelBuffer.AddColumn(SalesHeader."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        if Cust.Get(SalesHeader."Sell-to Customer No.") then begin
            ExcelBuffer.AddColumn(Cust."GST Registration No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            if Cust."KEY/NON KEY(Schimatzu)" = Cust."KEY/NON KEY(Schimatzu)"::Yes then
                CustKeyValue := 'Key'
            else if Cust."KEY/NON KEY(Schimatzu)" = Cust."KEY/NON KEY(Schimatzu)"::No then
                CustKeyValue := 'Non Key'
            else
                CustKeyValue := '';

            ExcelBuffer.AddColumn(CustKeyValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        end else begin
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        end;

        // Shipping Details
        ExcelBuffer.AddColumn(SalesHeader."Ship-to Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."Ship-to Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ShiptoAddress.Reset();
        ShiptoAddress.SetRange(Code, SalesHeader."Ship-to Code");
        if ShiptoAddress.FindFirst() then
            ExcelBuffer.AddColumn(ShiptoAddress."GST Registration No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // Document & Contact Info
        ExcelBuffer.AddColumn(SalesHeader."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."Customer PO Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(SalesHeader."Sell-to Contact", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        if PaymentTerms.Get(SalesHeader."Payment Terms Code") then
            ExcelBuffer.AddColumn(PaymentTerms.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(SalesHeader."Delivery Term", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."Freight Terms", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."Prepayment Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Sales Header Comments
        Clear(Narration);
        SalesCommentLine.Reset();
        SalesCommentLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesCommentLine.SetRange("No.", SalesHeader."No.");
        SalesCommentLine.SetRange("Document Line No.", 0);
        if SalesCommentLine.FindSet() then
            repeat
                if Narration = '' then
                    Narration := SalesCommentLine.Comment
                else
                    Narration := Narration + ' ' + SalesCommentLine.Comment;
            until SalesCommentLine.Next() = 0;
        ExcelBuffer.AddColumn(Narration, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(SalesHeader."Special Instruction", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."Special Remark-Sez", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // RDC
        ExcelBuffer.AddColumn(SalesHeader."RDC No", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."RDC Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);

        // Order Master Name
        ExcelBuffer.AddColumn(SalesHeader."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // Principal
        if SL.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.") then
            ExcelBuffer.AddColumn(SL.Principal, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // -----------------------------
        // Item Details
        // -----------------------------
        ExcelBuffer.AddColumn(SalesLine."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine."Description", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine."HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine."Quantity", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SalesLine."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SalesLine."Quantity" * SalesLine."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SalesLine."Line Discount %", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SalesLine."Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Packing & Insurance
        ExcelBuffer.AddColumn(SalesHeader."Packing & Forwarding", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."Insurance", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // Taxable & Taxes
        LineAmount := (SalesLine."Quantity" * SalesLine."Unit Price") - SalesLine."Line Discount Amount";
        ExcelBuffer.AddColumn(LineAmount, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn(SalesLine."CGST Percentage", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SalesLine."CGST Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SalesLine."SGST Percentage", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SalesLine."SGST Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SalesLine."IGST Percentage", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SalesLine."IGST Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        SubTotal := LineAmount + SalesLine."CGST Amount" + SalesLine."SGST Amount" + SalesLine."IGST Amount";
        RoundedAmount := ROUND(SubTotal, 1, '=');
        RoundOffDiff := Abs(RoundedAmount - SubTotal);

        ExcelBuffer.AddColumn(SubTotal, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        if RoundOffDiff <> 0 then
            ExcelBuffer.AddColumn(RoundOffDiff, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn(RoundedAmount, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        // Line Narration
        Clear(LineNarration);
        SalesCommentLine.Reset();
        SalesCommentLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesCommentLine.SetRange("No.", SalesHeader."No.");
        SalesCommentLine.SetRange("Document Line No.", SalesLine."Line No.");
        if SalesCommentLine.FindSet() then
            repeat
                if LineNarration = '' then
                    LineNarration := SalesCommentLine.Comment
                else
                    LineNarration := LineNarration + ' ' + SalesCommentLine.Comment;
            until SalesCommentLine.Next() = 0;
        ExcelBuffer.AddColumn(LineNarration, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //TBC - 928 ---->
        // Item Category
        if Item.Get(SalesLine."No.") then begin

            if Item."Primary Category 1" <> '' then
                ExcelBuffer.AddColumn(Item."Primary Category 1", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

            if Item."Primary Category 2" <> '' then
                ExcelBuffer.AddColumn(Item."Primary Category 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

            if Item."Item Category 1" <> '' then
                ExcelBuffer.AddColumn(Item."Item Category 1", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

            if Item."Item Category 2" <> '' then
                ExcelBuffer.AddColumn(Item."Item Category 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        end;
        //TBC - 928 <----


        ItemCategory.Reset();
        ItemCategory.SetRange(Code, SalesLine."Item Category Code");
        if ItemCategory.FindFirst() then
            ExcelBuffer.AddColumn(ItemCategory.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(SalesHeader."Custom Assigned User ID", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(SalesLine."Lead Time Calculation", FALSE, '', FALSE, FALSE, FALSE, '#,##0', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SalesHeader."Sell-to Phone No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //TBC - 917 -->
        if SalesHeader."Sell-to E-Mail" <> '' then
            ExcelBuffer.AddColumn(SalesHeader."Sell-to E-Mail", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        //TBC - 971 <--

        //TBC-970 --->
        if SalesHeader.Service_Type_ <> '' then
            ExcelBuffer.AddColumn(SalesHeader.Service_Type_, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        //TBC-970 <---

        //Grand Total
        GrandTotalPrepaymentAmount += SalesHeader."Prepayment Amount";
        GrandTotalQty += SalesLine."Quantity";
        GrandTotalLineAmount += SalesLine.Quantity * SalesLine."Unit Price";
        GrandTotalInvoiceDiscountAmount += SalesLine."Line Discount Amount";
        GrandTotalTaxable += (SalesLine."Line Amount" - SalesLine."Line Discount Amount");
        GrandTotalCGSTPer += SalesLine."CGST Percentage";
        GrandTotalSGSTPer += SalesLine."SGST Percentage";
        GrandTotalIGSTPer += SalesLine."IGST Percentage";
        GrandTotalCGST += SalesLine."CGST Amount";
        GrandTotalSGST += SalesLine."SGST Amount";
        GrandTotalIGST += SalesLine."IGST Amount";
        GrandTotalInvoiceValue +=
            ((SalesLine."Quantity" * SalesLine."Unit Price") - SalesLine."Line Discount Amount") + (SalesLine."CGST Amount" + SalesLine."SGST Amount" + SalesLine."IGST Amount");

        //Round Off
        // GrandTotalOriginalAmount += ((SalesLine."Quantity" * SalesLine."Unit Price") - SalesLine."Line Discount Amount") + (SalesLine."CGST Amount" + SalesLine."SGST Amount" + SalesLine."IGST Amount");
        // GrandTotalRoundedAmount += ROUND(OriginalAmount, 1, '=');
        // GrandTotalRoundOffDiff += Abs(RoundedAmount - OriginalAmount);

        GrandTotalOriginalAmount += SubTotal;          // Actual value
        GrandTotalRoundedAmount += RoundedAmount;      // Rounded value
        GrandTotalRoundOffDiff += RoundOffDiff;         // Difference

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
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(GrandTotalPrepaymentAmount, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

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
        ExcelBuffer.AddColumn(GrandTotalQty, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);


        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(GrandTotalLineAmount, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(GrandTotalInvoiceDiscountAmount, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(GrandTotalCGSTPer, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalCGST, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalSGSTPer, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalSGST, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalIGSTPer, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalIGST, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalInvoiceValue, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalRoundOffDiff, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalRoundedAmount, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
    end;

    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('Sales Order Booking Statement');
        ExcelBuffer.WriteSheet('Sales Order Booking Statement', '_', UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Sales Order Booking Statement' + '_' + UserId);
        ExcelBuffer.OpenExcel();

    end;
}
