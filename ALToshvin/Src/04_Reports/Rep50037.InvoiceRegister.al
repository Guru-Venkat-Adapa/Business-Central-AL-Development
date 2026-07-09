report 50037 "Invoice Register"
{
    ApplicationArea = All;
    Caption = 'Invoice Register';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = const(Item));

                trigger OnAfterGetRecord()
                begin
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

                //TBC-1014 --->
                if Region <> '' then
                    SetRange("Shortcut Dimension 2 Code", Region);
                //TBC-1014 <---

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
                    //TBC-1014 --->
                    field(Region; Region)
                    {
                        ApplicationArea = All;
                        Caption = 'Region';
                        TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
                    }
                    //TBC-1014 <---
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        Clear(SalesType);
        Clear(TotalTaxableInv);
        Clear(TotalTaxableCrMemo);
        Clear(PurchReceiptNo);
        Clear(FinalTaxableTotal);
        Clear(TotalInvIGSTAmt);
        Clear(TotalCrMemoIGSTAmt);
        Clear(FinalIGSTAmt);
        Clear(TotalInvCGSTAmt);
        Clear(TotalCrMemoCGSTAmt);
        Clear(FinalCGSTAmt);
        Clear(TotalInvSGSTAmt);
        Clear(TotalCrMemoSGSTAmt);
        Clear(FinalSGSTAmt);
        Clear(TotalInvAmt);
        Clear(TotalCrMemoAmt);
        Clear(GrnadTotal);
        Clear(ItemCategoryCode);
        Clear(PrimaryCategory1);
        Clear(PrimaryCategory2);
        Clear(ItemCategory1);
        Clear(ItemCategory2);
        Clear(DiscountAmount);
        Clear(TaxbleAmount);
        Clear(PurchaseValue);
        Clear(PurchaseRate);
        Clear(LineNarration);
        Clear(GrandTotalRate);
        Clear(GrandTotalQty);
        Clear(GrandTotalLineAmount);
        Clear(GrandDiscountPer);
        Clear(GrandTotalInvoiceDiscountAmount);
        Clear(GrandTotalTaxable);
        Clear(TotalIncIGSTPer);
        Clear(TotalIncCGSTPer);
        Clear(TotalIncSGSTPer);
        Clear(TotalInvCGSTAmt);
        Clear(TotalInvIGSTAmt);
        Clear(TotalInvSGSTAmt);
        Clear(GrandSubTotal);
        Clear(GrandPurchaseValue);
        Clear(GrandMarginValue);
        Clear(GrandPurchaseRate);
        ExcelBuffer.DELETEALL;
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPostReport()
    begin
        AddGrandTotalRow();
        CreateExcelBook();
    end;

    local procedure MakeExcelDataHeader()
    begin
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

        SalesType := 'Sales & Service Invoice Register';

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
        ExcelBuffer.AddColumn('[ Date Range ' + Format(StartDate) + ' to ' + Format(EndDate) + ' ]', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();

        // Column headers
        ExcelBuffer.AddColumn('Document No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn('Department Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regional Office Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('GST Regiona State Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Service Doc Series Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regional Group Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sales AC Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Principle Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Order Master Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer AC. Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer AC. Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer AC. Address', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer AC. Business Types', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer AC. GSTIN', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer AC.State Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer AC. State Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Key / Non Key Result', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer AC.Type of Tax payers', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Category Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Primary Category 1', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Primary Category 2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('Item Category 1', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Category 2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Gross', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Discount %', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Discount Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CGST_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CGST Value_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SGST_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SGST Value_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IGST_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IGST Value_Input', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sub Total', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Margin Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Rate', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Party PO No', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Party PO Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Payment Term Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Base Link Doc Number', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Executive Master Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Executive Master-2 Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Remarks', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Narration', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Place of Supply Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Service Type Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Service Description Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Kind Attn.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Description 1', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Contract Start Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Contract End Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Visit Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('No Of Visits', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Contract Peiod From', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Contract Peiod To', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Consignee Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Consignee Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Consignee PIN', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Consignee Add1', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Consignee GSTN No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IRN Number', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('EINV Cancel Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Transporter', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Docket Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Docket No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor BL No', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Contact No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HSN Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item.Default Base Unit', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody()
    var
        DimensionValue: Text;
    begin
        ExcelBuffer.NewRow();

        //Doc NO.
        ExcelBuffer.AddColumn("Sales Invoice Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        //Posting Date
        ExcelBuffer.AddColumn("Sales Invoice Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);

        //Department Name
        DimensionValue := '';
        Dimension.Reset();
        Dimension.SetRange(Code, "Sales Invoice Header"."Shortcut Dimension 1 Code");
        if Dimension.FindFirst() then
            DimensionValue := Dimension.Name;
        ExcelBuffer.AddColumn(DimensionValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Regional Office.Name
        DimensionValue := '';
        Dimension.Reset();
        Dimension.SetRange(Code, "Sales Invoice Header"."Shortcut Dimension 2 Code");
        if Dimension.FindFirst() then
            DimensionValue := Dimension.Name;
        ExcelBuffer.AddColumn(DimensionValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //GST Regiona State.Name
        if Loc.Get("Sales Invoice Header"."Location Code") then
            if RecState.Get(Loc."State Code") then
                ExcelBuffer.AddColumn(RecState.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Service Doc Series.Code
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Regional Group.Name
        DimensionValue := '';
        Dimension.Reset();
        Dimension.SetRange(Code, "Sales Invoice Header"."Shortcut Dimension 3 Code");
        if Dimension.FindFirst() then
            DimensionValue := Dimension.Name;
        ExcelBuffer.AddColumn(DimensionValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //SalesAC.Name
        Clear(GLName);
        if GenPostingSetup.Get(
            "Sales Invoice Line"."Gen. Bus. Posting Group",
            "Sales Invoice Line"."Gen. Prod. Posting Group")
        then begin
            GLEntry.Reset();
            GLEntry.SetRange("Document Type", GLEntry."Document Type"::Invoice);
            GLEntry.SetRange("Document No.", "Sales Invoice Header"."No.");
            GLEntry.SetRange("G/L Account No.", GenPostingSetup."Sales Account");
            if GLEntry.FindFirst() then
                if GLAccount.Get(GLEntry."G/L Account No.") then
                    GLName := GLAccount.Name;
        end;

        if GLName <> '' then
            ExcelBuffer.AddColumn(GLName, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Principle.Name

        If ItemMaster.Get("Sales Invoice Line"."No.") then begin
            if ItemMaster.Principal <> '' then
                ExcelBuffer.AddColumn(ItemMaster.Principal, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ItemCategoryCode := ItemMaster."Item Category Code";
            PrimaryCategory1 := ItemMaster."Primary Category 1";
            PrimaryCategory2 := ItemMaster."Primary Category 2";
            ItemCategory1 := ItemMaster."Item Category 1";
            ItemCategory2 := ItemMaster."Item Category 2";
        end;

        //Order Master.Name
        if "Sales Invoice Header"."Order No." <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Order No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //CustomerAC.Code
        ExcelBuffer.AddColumn("Sales Invoice Header"."Sell-to Customer No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //CustomerAC.Name
        ExcelBuffer.AddColumn("Sales Invoice Header"."Sell-to Customer Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //CustomerAC.Address
        ExcelBuffer.AddColumn("Sales Invoice Header"."Sell-to Address" + "Sales Invoice Header"."Sell-to Address 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //CustomerAC.Business Types
        ExcelBuffer.AddColumn("Sales Invoice Header"."Nature of Supply", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //CustomerAC.GSTIN
        if Cust.Get("Sales Invoice Header"."Sell-to Customer No.") then begin
            ExcelBuffer.AddColumn(Cust."GST Registration No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

            //CustomerAC.State Name
            if RecState.Get(Cust."State Code") then
                ExcelBuffer.AddColumn(RecState.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

            //CustomerAC.State Code
            ExcelBuffer.AddColumn(Cust."State Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

            //Key / Non Key Result
            if Cust."KEY/NON KEY(Schimatzu)" = Cust."KEY/NON KEY(Schimatzu)"::Yes then
                ExcelBuffer.AddColumn('Key', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
            else
                if Cust."KEY/NON KEY(Schimatzu)" = Cust."KEY/NON KEY(Schimatzu)"::No then
                    ExcelBuffer.AddColumn('Non Key', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
                else
                    if Cust."KEY/NON KEY(Schimatzu)" = Cust."KEY/NON KEY(Schimatzu)"::" " then
                        ExcelBuffer.AddColumn(' ', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end;

        //CustomerAC.Type of Tax payers
        ExcelBuffer.AddColumn("Sales Invoice Header"."GST Customer Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Item.Code
        ExcelBuffer.AddColumn("Sales Invoice Line"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        //Item.Name
        ExcelBuffer.AddColumn("Sales Invoice Line".Description + "Sales Invoice Line"."Description 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Item.Category New
        if ItemCategoryCode <> '' then
            ExcelBuffer.AddColumn(ItemCategoryCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //PrimaryCategory1
        if PrimaryCategory1 <> '' then
            ExcelBuffer.AddColumn(PrimaryCategory1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //PrimaryCategory2
        if PrimaryCategory2 <> '' then
            ExcelBuffer.AddColumn(PrimaryCategory2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //ItemCategory1
        if ItemCategory1 <> '' then
            ExcelBuffer.AddColumn(ItemCategory1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //ItemCategory2
        if ItemCategory2 <> '' then
            ExcelBuffer.AddColumn(ItemCategory2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Rate
        ExcelBuffer.AddColumn("Sales Invoice Line"."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Quantity
        if "Sales Invoice Line".Quantity <> 0 then
            ExcelBuffer.AddColumn("Sales Invoice Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Gross
        ExcelBuffer.AddColumn("Sales Invoice Line"."Unit Price" * "Sales Invoice Line"."Quantity", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Discount %
        ExcelBuffer.AddColumn("Sales Invoice Line"."Line Discount %", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Discount Amt
        DiscountAmount := 0;
        DiscountAmount := ("Sales Invoice Line"."Unit Price" * "Sales Invoice Line"."Quantity") * "Sales Invoice Line"."Line Discount %" / 100;
        ExcelBuffer.AddColumn(DiscountAmount, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Taxable Value
        TaxbleAmount := 0;
        TaxbleAmount := ("Sales Invoice Line"."Unit Price" * "Sales Invoice Line"."Quantity") - DiscountAmount;
        ExcelBuffer.AddColumn(TaxbleAmount, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //CGST_Input|CGST Value_Input|SGST_Input|SGST Value|IGST_Input|IGST Value
        Clear(IGSTAmt);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        Clear(IGSTPer);
        Clear(CGSTPer);
        Clear(SGSTPer);
        DetGSTLedgerEntry.Reset();
        DetGSTLedgerEntry.SetRange("Document No.", "Sales Invoice Header"."No.");
        DetGSTLedgerEntry.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
        DetGSTLedgerEntry.SetRange("Document Type", DetGSTLedgerEntry."Document Type"::Invoice);
        if DetGSTLedgerEntry.FindSet() then
            repeat
                case DetGSTLedgerEntry."GST Component Code" of
                    'IGST':
                        begin
                            IGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            IGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                    'CGST':
                        begin
                            CGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            CGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                    'SGST':
                        begin
                            SGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                            SGSTPer := DetGSTLedgerEntry."GST %";
                        end;
                end;
            until DetGSTLedgerEntry.Next() = 0;

        ExcelBuffer.AddColumn(CGSTPer, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(CGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SGSTPer, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(SGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(IGSTPer, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(IGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Sub Total
        ExcelBuffer.AddColumn("Sales Invoice Line".Amount + CGSTAmt + SGSTAmt + IGSTAmt, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Purchase Value
        Clear(PurchaseValue);
        ValueEntry.Reset();
        ValueEntry.SetRange("Document No.", "Sales Invoice Header"."No.");
        ValueEntry.SetRange("Item No.", "Sales Invoice Line"."No.");
        if ValueEntry.FindSet() then
            repeat
                PurchaseValue += Abs(ValueEntry."Cost Amount (Actual)");
                PurchaseRate += ValueEntry."Cost per Unit";
            until ValueEntry.Next() = 0;

        if PurchaseValue <> 0 then
            ExcelBuffer.AddColumn(PurchaseValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Text);

        //Margin Value
        ExcelBuffer.AddColumn(TaxbleAmount - PurchaseValue, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

        //Purchase Rate
        if PurchaseRate <> 0 then
            ExcelBuffer.AddColumn(PurchaseRate, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Text);

        //Party PO No
        if "Sales Invoice Header"."External Document No." <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Party PO Date
        if "Sales Invoice Header"."Customer PO Date" <> 0D then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Customer PO Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Payment Term.Name
        if "Sales Invoice Header"."Payment Terms Code" <> '' then begin
            if PaymentTerms.Get("Sales Invoice Header"."Payment Terms Code") then
                ExcelBuffer.AddColumn(PaymentTerms.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        end else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Base Link doc. number
        ExcelBuffer.AddColumn("Sales Invoice Line"."Shipment No.", false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Text);

        //Executive Master.Name
        if "Sales Invoice Header"."Executive Master" <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Executive Master", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Executive Master-2.Name
        if "Sales Invoice Header"."Executive Master2" <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Executive Master2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Remarks
        Clear(LineNarration);
        SalesCommentLine.Reset();
        SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::"Posted Invoice");
        SalesCommentLine.SetRange("No.", "Sales Invoice Header"."No.");
        SalesCommentLine.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
        if SalesCommentLine.FindSet() then
            repeat
                if LineNarration = '' then
                    LineNarration := SalesCommentLine.Comment
                else
                    LineNarration := LineNarration + ' ' + SalesCommentLine.Comment;
            until SalesCommentLine.Next() = 0;

        if LineNarration <> '' then
            ExcelBuffer.AddColumn(LineNarration, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Narration
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Place of Supply.Name
        if Cust.Get("Sales Invoice Header"."Sell-to Customer No.") then
            if Cust."State Code" <> '' then begin
                if RecState.Get(Cust."State Code") then
                    ExcelBuffer.AddColumn(RecState.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            end else
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Service Type.Code
        if "Sales Invoice Header".Service_Type_ <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header".Service_Type_, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Service Description.Name
        if "Sales Invoice Header"."Service Description" <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Service Description", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Kind Attn
        if "Sales Invoice Header"."Sell-to Contact" <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Sell-to Contact", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Description 1
        if "Sales Invoice Line"."Description 2" <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Line"."Description 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Contract Start Date
        if "Sales Invoice Header"."Contract Start Date" <> 0D then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Contract Start Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);


        //Contract End Date
        if "Sales Invoice Header"."Contract End Date" <> 0D then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Contract End Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Visit Date
        if "Sales Invoice Header"."Visit Date" <> 0D then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Visit Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //No Of Visits
        if "Sales Invoice Header"."No. of visit" <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."No. of visit", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Contract Peiod From
        if "Sales Invoice Line"."CMC/AMC Start Date" <> 0D then
            ExcelBuffer.AddColumn("Sales Invoice Line"."CMC/AMC Start Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Contract Peiod To
        if "Sales Invoice Line"."CMC/AMC End Date" <> 0D then
            ExcelBuffer.AddColumn("Sales Invoice Line"."CMC/AMC End Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Consignee.Code
        if "Sales Invoice Header"."Ship-to Code" <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Ship-to Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Consignee.Name
        ExcelBuffer.AddColumn("Sales Invoice Header"."Ship-to Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Consignee.PIN
        ExcelBuffer.AddColumn("Sales Invoice Header"."Ship-to Post Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);

        //Consignee.Add1
        ExcelBuffer.AddColumn("Sales Invoice Header"."Ship-to Address" + "Sales Invoice Header"."Ship-to Address 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Consignee GSTN No  
        if "Sales Invoice Header"."Ship-to GST Reg. No." <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Ship-to GST Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //IRN Number
        if "Sales Invoice Header"."IRN Hash" <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."IRN Hash", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //EINV CancelDt
        ExcelBuffer.AddColumn("Sales Invoice Header"."E-Inv. Cancelled Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        if "Sales Invoice Header"."Shipping Agent Code" <> '' then begin
            if ShippingAgent.Get("Sales Invoice Header"."Shipping Agent Code") then
                ExcelBuffer.AddColumn(ShippingAgent.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
            else
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        end else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //Docket Date
        if "Sales Invoice Header"."LR/RR Date" <> 0D then
            ExcelBuffer.AddColumn("Sales Invoice Header"."LR/RR Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Docket No.
        if "Sales Invoice Header"."LR/RR No." <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."LR/RR No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Vendor Bill No.
        //Vendor Bill No.
        ILE.Reset();
        ILE.SetRange("Entry Type", ILE."Entry Type"::Sale);
        ILE.SetRange("Document Type", ILE."Document Type"::"Sales Shipment");
        ILE.SetRange("Document No.", "Sales Invoice Line"."Shipment No.");
        ILE.SetRange("Document Line No.", "Sales Invoice Line"."Shipment Line No.");
        if ILE.FindFirst() then begin
            ItemAppEntry.Reset();
            ItemAppEntry.SetRange("Outbound Item Entry No.", ILE."Entry No.");
            if ItemAppEntry.FindSet() then
                repeat
                    if AppliedILE.Get(ItemAppEntry."Inbound Item Entry No.") then
                        if AppliedILE."Document Type" = AppliedILE."Document Type"::"Purchase Receipt" then begin
                            PurchReceiptNo := AppliedILE."Document No.";
                            exit;
                        end;
                until ItemAppEntry.Next() = 0;
        end;

        if PurchReceiptNo <> '' then begin
            if PurchRcptHeader.Get(PurchReceiptNo) then begin
                if PurchRcptHeader."Vendor Bill No." <> '' then
                    ExcelBuffer.AddColumn(CopyStr(PurchRcptHeader."Vendor Bill No.", 1, 250), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
                else
                    ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            end else
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        end else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);



        //Contact No
        if "Sales Invoice Header"."Sell-to Phone No." <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Header"."Sell-to Phone No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        //HSN Code
        if "Sales Invoice Line"."HSN/SAC Code" <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Line"."HSN/SAC Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //Item.Default Base Unit
        if "Sales Invoice Line"."Unit of Measure Code" <> '' then
            ExcelBuffer.AddColumn("Sales Invoice Line"."Unit of Measure Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
        else
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        //GrandTotal
        GrandTotalRate += "Sales Invoice Line"."Unit Price";
        GrandTotalQty += "Sales Invoice Line"."Quantity";
        GrandTotalLineAmount += "Sales Invoice Line"."Unit Price" * "Sales Invoice Line".Quantity;
        GrandDiscountPer += "Sales Invoice Line"."Line Discount %";
        GrandTotalInvoiceDiscountAmount += "Sales Invoice Line"."Line Discount Amount";
        GrandTotalTaxable += ("Sales Invoice Line"."Line Amount" - "Sales Invoice Line"."Line Discount Amount");
        TotalInvIGSTAmt += IGSTAmt;
        TotalInvCGSTAmt += CGSTAmt;
        TotalInvSGSTAmt += SGSTAmt;
        TotalIncCGSTPer += CGSTPer;
        TotalIncSGSTPer += SGSTPer;
        TotalIncIGSTPer += IGSTPer;
        GrandSubTotal += "Sales Invoice Line".Amount + CGSTAmt + SGSTAmt + IGSTAmt;
        GrandPurchaseValue += PurchaseValue;
        GrandMarginValue += TaxbleAmount - PurchaseValue;
        GrandPurchaseRate += PurchaseRate;
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
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Date
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Dept
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);                                                                          // … keep empty columns SAME as body until Line Amount
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Date
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); // Dept
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);                                                                          // … keep empty columns SAME as body until Line Amount
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(GrandTotalRate, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalQty, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalLineAmount, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandDiscountPer, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalInvoiceDiscountAmount, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandTotalTaxable, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(TotalIncCGSTPer, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(TotalInvCGSTAmt, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(TotalIncSGSTPer, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(TotalInvSGSTAmt, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(TotalIncIGSTPer, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(TotalInvIGSTAmt, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandSubTotal, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandPurchaseValue, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandMarginValue, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(GrandPurchaseRate, false, '', true, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);

    end;

    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('Invoice Register');
        ExcelBuffer.WriteSheet('Invoice Register', '_', UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Invoice Register' + '_' + UserId);
        ExcelBuffer.OpenExcel();
    end;



    var
        StartDate: Date;
        EndDate: Date;
        Dimension: Record "Dimension Value";
        TotalIncCGSTPer: Decimal;
        SalesOrdeType: Option " ",AMC,CLAIMS,CMC,CONSUMBALE,INSTRUMENT,SPARES,SERVICES;
        LocationCode: Code[10];
        GrandPurchaseValue: Decimal;
        GrandMarginValue: Decimal;
        ExcelBuffer: Record "Excel Buffer" temporary;
        SalesType: Text;
        TotalIncIGSTPer: Decimal;
        GrandSubTotal: Decimal;

        DiscountAmount: Decimal;
        TotalIncSGSTPer: Decimal;
        GrandPurchaseRate: Decimal;
        PaymentTerms: Record "Payment Terms";
        SalesCommentLine: Record "Sales Comment Line";
        TaxbleAmount: Decimal;
        GrandTotalRate: Decimal;
        GrandTotalTaxable: Decimal;
        GrandTotalInvoiceDiscountAmount: Decimal;
        GrandDiscountPer: Decimal;
        GrandTotalLineAmount: Decimal;
        GrandTotalQty: Decimal;
        LineNarration: Text;
        ShipmentMethod: Record "Shipment Method";
        ItemCategoryCode: Code[20];
        ItemMaster: Record Item;
        CompanyInfo: Record "Company Information";
        Loc: Record Location;
        RecState: Record State;
        PrimaryCategory1: Text;
        PrimaryCategory2: Text;
        ItemCategory1: Text;
        ItemCategory2: Text;
        Cust: Record Customer;
        TransactionType: Text;
        BillToStateName: Text;
        ShipToStateName: Text;
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        GLName: Text[100];
        ValueEntry: Record "Value Entry";
        PurchaseValue: Decimal;
        PurchaseRate: Decimal;
        BaseGLAccount: Code[20];
        DetGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        SGSTPer: Decimal;
        SalesInvHeader: Record "Sales Invoice Header";
        ShipToCountyLen: Integer;
        BillToCountyLen: Integer;
        WarehouseNameHeader: Text;
        WorkDescStream: InStream;
        Reason: Text;
        BillStateDesc: Text;
        ShipStateDesc: Text;
        TotalTaxableInv: Decimal;
        TotalTaxableCrMemo: Decimal;
        FinalTaxableTotal: Decimal;
        TotalInvIGSTAmt: Decimal;
        TotalCrMemoIGSTAmt: Decimal;
        FinalIGSTAmt: Decimal;
        TotalInvCGSTAmt: Decimal;
        TotalCrMemoCGSTAmt: Decimal;
        FinalCGSTAmt: Decimal;
        TotalInvSGSTAmt: Decimal;
        TotalCrMemoSGSTAmt: Decimal;
        FinalSGSTAmt: Decimal;
        TotalInvAmt: Decimal;
        TotalCrMemoAmt: Decimal;
        GrnadTotal: Decimal;
        GenPostingSetup: Record "General Posting Setup";
        ShippingAgent: Record "Shipping Agent";
        ILE: Record "Item Ledger Entry";
        VendorBillNo: Code[20];
        PurchReceiptNo: Code[20];
        ItemAppEntry: Record "Item Application Entry";
        AppliedILE: Record "Item Ledger Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        Region: Code[20];


}
