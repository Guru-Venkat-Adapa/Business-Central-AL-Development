report 50111 "Aged Accounts Payable Custom"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'CustomAgedAccountsPayable.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Custom Aged Accounts Payable';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(TodayFormatted; TodayFormatted)
            {
            }
            column(CompanyName; CompanyDisplayName)
            {
            }
            column(NewPagePerVendor; NewPagePerVendor)
            {
            }
            column(AgesAsOfEndingDate; StrSubstNo(Text006, Format(EndingDate, 0, 4)))
            {
            }
            column(SelectAgeByDuePostngDocDt; StrSubstNo(Text007, SelectStr(AgingBy + 1, Text009)))
            {
            }
            column(PrintAmountInLCY; PrintAmountInLCY)
            {
            }
            column(CaptionVendorFilter; TableCaption + ': ' + VendorFilter)
            {
            }
            column(VendorFilter; VendorFilter)
            {
            }
            column(AgingBy; AgingBy)
            {
            }
            column(SelctAgeByDuePostngDocDt1; StrSubstNo(Text004, SelectStr(AgingBy + 1, Text009)))
            {
            }
            column(HeaderText5; HeaderText[5])
            {
            }
            column(HeaderText4; HeaderText[4])
            {
            }
            column(HeaderText3; HeaderText[3])
            {
            }
            column(HeaderText2; HeaderText[2])
            {
            }
            column(HeaderText1; HeaderText[1])
            {
            }
            column(PrintDetails; PrintDetails)
            {
            }
            column(GrandTotalVLE5RemAmtLCY; GrandTotalVLERemaingAmtLCY[5])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE4RemAmtLCY; GrandTotalVLERemaingAmtLCY[4])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE3RemAmtLCY; GrandTotalVLERemaingAmtLCY[3])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE2RemAmtLCY; GrandTotalVLERemaingAmtLCY[2])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE1RemAmtLCY; GrandTotalVLERemaingAmtLCY[1])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE1AmtLCY; GrandTotalVLEAmtLCY)
            {
                AutoFormatType = 1;
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(No_Vendor; "No.")
            {
            }
            column(AgedAcctPayableCaption; AgedAcctPayableCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(AllAmtsinLCYCaption; AllAmtsinLCYCaptionLbl)
            {
            }
            column(AgedOverdueAmsCaption; AgedOverdueAmsCaptionLbl)
            {
            }
            column(GrandTotalVLE5RemAmtLCYCaption; GrandTotalVLE5RemAmtLCYCaptionLbl)
            {
            }
            column(AmountLCYCaption; AmountLCYCaptionLbl)
            {
            }
            column(DueDateCaption; DueDateCaptionLbl)
            {
            }
            column(DocumentNoCaption; DocNoCaption)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(DocumentTypeCaption; DocumentTypeCaptionLbl)
            {
            }
            column(VendorNoCaption; FieldCaption("No."))
            {
            }
            column(VendorNameCaption; FieldCaption(Name))
            {
            }
            column(CurrencyCaption; CurrencyCaptionLbl)
            {
            }
            column(TotalLCYCaption; TotalLCYCaptionLbl)
            {
            }
            column(VendorPhoneNoCaption; FieldCaption("Phone No."))
            {
            }
            column(VendorContactCaption; FieldCaption(Contact))
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code");
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord()
                var
                    VendorLedgEntry: Record "Vendor Ledger Entry";
                begin
                    VendorLedgEntry.SetCurrentKey("Closed by Entry No.");
                    VendorLedgEntry.SetRange("Closed by Entry No.", "Entry No.");
                    VendorLedgEntry.SetRange("Posting Date", 0D, EndingDate);
                    CopyDimFiltersFromVendor(VendorLedgEntry);
                    if VendorLedgEntry.FindSet(false, false) then
                        repeat
                            InsertTemp(VendorLedgEntry);
                        until VendorLedgEntry.Next = 0;

                    if "Closed by Entry No." <> 0 then begin
                        VendorLedgEntry.SetRange("Closed by Entry No.", "Closed by Entry No.");
                        if VendorLedgEntry.FindSet(false, false) then
                            repeat
                                InsertTemp(VendorLedgEntry);
                            until VendorLedgEntry.Next = 0;
                    end;

                    VendorLedgEntry.Reset();
                    VendorLedgEntry.SetRange("Entry No.", "Closed by Entry No.");
                    VendorLedgEntry.SetRange("Posting Date", 0D, EndingDate);
                    CopyDimFiltersFromVendor(VendorLedgEntry);
                    if VendorLedgEntry.FindSet(false, false) then
                        repeat
                            InsertTemp(VendorLedgEntry);
                        until VendorLedgEntry.Next = 0;
                    CurrReport.Skip();
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", EndingDate + 1, DMY2Date(31, 12, 9999));
                    CopyDimFiltersFromVendor("Vendor Ledger Entry");
                end;
            }
            dataitem(OpenVendorLedgEntry; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date", "Currency Code");
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord()
                begin
                    if AgingBy = AgingBy::"Posting Date" then begin
                        CalcFields("Remaining Amt. (LCY)");
                        if "Remaining Amt. (LCY)" = 0 then
                            CurrReport.Skip();
                    end;
                    InsertTemp(OpenVendorLedgEntry);
                    CurrReport.Skip();
                end;

                trigger OnPreDataItem()
                begin
                    if AgingBy = AgingBy::"Posting Date" then begin
                        SetRange("Posting Date", 0D, EndingDate);
                        SetRange("Date Filter", 0D, EndingDate);
                    end;
                    CopyDimFiltersFromVendor(OpenVendorLedgEntry);
                end;
            }
            dataitem(CurrencyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                PrintOnlyIfDetail = true;
                dataitem(TempVendortLedgEntryLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    column(VendorName; Vendor.Name)
                    {
                    }
                    column(VendorNo; Vendor."No.")
                    {
                    }
                    column(VendorPhoneNo; Vendor."Phone No.")
                    {
                    }
                    column(VendorContactName; Vendor.Contact)
                    {
                    }
                    column(VLEEndingDateRemAmtLCY; VendorLedgEntryEndingDate."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVLE6RemAmtLCY; AgedVendorLedgEntry[6]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVLE1RemAmtLCY; AgedVendorLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt2RemAmtLCY; AgedVendorLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt3RemAmtLCY; AgedVendorLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt4RemAmtLCY; AgedVendorLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt5RemAmtLCY; AgedVendorLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndDtAmtLCY; VendorLedgEntryEndingDate."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndDtDueDate; Format(VendorLedgEntryEndingDate."Due Date"))
                    {
                    }
                    column(VendLedgEntryEndDtDocNo; DocumentNo)
                    {
                    }
                    column(VendLedgEntyEndgDtDocType; Format(VendorLedgEntryEndingDate."Document Type"))
                    {
                    }
                    column(VendLedgEntryEndDtPostgDt; Format(VendorLedgEntryEndingDate."Posting Date"))
                    {
                    }
                    column(AgedVendLedgEnt6RemAmt; AgedVendorLedgEntry[6]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt5RemAmt; AgedVendorLedgEntry[5]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt4RemAmt; AgedVendorLedgEntry[4]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt3RemAmt; AgedVendorLedgEntry[3]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt2RemAmt; AgedVendorLedgEntry[2]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt1RemAmt; AgedVendorLedgEntry[1]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VLEEndingDateRemAmt; VendorLedgEntryEndingDate."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndingDtAmt; VendorLedgEntryEndingDate.Amount)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalVendorName; StrSubstNo(Text005, Vendor.Name))
                    {
                    }
                    column(CurrCode_TempVenLedgEntryLoop; CurrencyCode)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    var
                        PeriodIndex: Integer;
                    begin
                        if Number = 1 then begin
                            if not TempVendorLedgEntry.FindSet(false, false) then
                                CurrReport.Break();
                        end else
                            if TempVendorLedgEntry.Next = 0 then
                                CurrReport.Break();

                        VendorLedgEntryEndingDate := TempVendorLedgEntry;
                        DetailedVendorLedgerEntry.SetRange("Vendor Ledger Entry No.", VendorLedgEntryEndingDate."Entry No.");
                        if DetailedVendorLedgerEntry.FindSet(false, false) then
                            repeat
                                if (DetailedVendorLedgerEntry."Entry Type" =
                                    DetailedVendorLedgerEntry."Entry Type"::"Initial Entry") and
                                   (VendorLedgEntryEndingDate."Posting Date" > EndingDate) and
                                   (AgingBy <> AgingBy::"Posting Date")
                                then begin
                                    if VendorLedgEntryEndingDate."Document Date" <= EndingDate then
                                        DetailedVendorLedgerEntry."Posting Date" :=
                                          VendorLedgEntryEndingDate."Document Date"
                                    else
                                        if (VendorLedgEntryEndingDate."Due Date" <= EndingDate) and
                                           (AgingBy = AgingBy::"Due Date")
                                        then
                                            DetailedVendorLedgerEntry."Posting Date" :=
                                              VendorLedgEntryEndingDate."Due Date"
                                end;

                                if (DetailedVendorLedgerEntry."Posting Date" <= EndingDate) or
                                   (TempVendorLedgEntry.Open and
                                    (AgingBy = AgingBy::"Due Date") and
                                    (VendorLedgEntryEndingDate."Due Date" > EndingDate) and
                                    (VendorLedgEntryEndingDate."Posting Date" <= EndingDate))
                                then begin
                                    if DetailedVendorLedgerEntry."Entry Type" in
                                       [DetailedVendorLedgerEntry."Entry Type"::"Initial Entry",
                                        DetailedVendorLedgerEntry."Entry Type"::"Unrealized Loss",
                                        DetailedVendorLedgerEntry."Entry Type"::"Unrealized Gain",
                                        DetailedVendorLedgerEntry."Entry Type"::"Realized Loss",
                                        DetailedVendorLedgerEntry."Entry Type"::"Realized Gain",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Adjustment)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]
                                    then begin
                                        VendorLedgEntryEndingDate.Amount := VendorLedgEntryEndingDate.Amount + DetailedVendorLedgerEntry.Amount;
                                        VendorLedgEntryEndingDate."Amount (LCY)" :=
                                          VendorLedgEntryEndingDate."Amount (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                                    end;
                                    if DetailedVendorLedgerEntry."Posting Date" <= EndingDate then begin
                                        VendorLedgEntryEndingDate."Remaining Amount" :=
                                          VendorLedgEntryEndingDate."Remaining Amount" + DetailedVendorLedgerEntry.Amount;
                                        VendorLedgEntryEndingDate."Remaining Amt. (LCY)" :=
                                          VendorLedgEntryEndingDate."Remaining Amt. (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                                    end;
                                end;
                            until DetailedVendorLedgerEntry.Next = 0;

                        if UseExternalDocNo then
                            DocumentNo := VendorLedgEntryEndingDate."External Document No."
                        else
                            DocumentNo := VendorLedgEntryEndingDate."Document No.";

                        if VendorLedgEntryEndingDate."Remaining Amount" = 0 then
                            CurrReport.Skip();

                        case AgingBy of
                            AgingBy::"Due Date":
                                PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Due Date");
                            AgingBy::"Posting Date":
                                PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Posting Date");
                            AgingBy::"Document Date":
                                begin
                                    if VendorLedgEntryEndingDate."Document Date" > EndingDate then begin
                                        VendorLedgEntryEndingDate."Remaining Amount" := 0;
                                        VendorLedgEntryEndingDate."Remaining Amt. (LCY)" := 0;
                                        VendorLedgEntryEndingDate."Document Date" := VendorLedgEntryEndingDate."Posting Date";
                                    end;
                                    PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Document Date");
                                end;
                        end;
                        Clear(AgedVendorLedgEntry);
                        AgedVendorLedgEntry[PeriodIndex]."Remaining Amount" := VendorLedgEntryEndingDate."Remaining Amount";
                        AgedVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalVendorLedgEntry[PeriodIndex]."Remaining Amount" += VendorLedgEntryEndingDate."Remaining Amount";
                        TotalVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalVLERemaingAmtLCY[PeriodIndex] += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalVendorLedgEntry[1].Amount += VendorLedgEntryEndingDate."Remaining Amount";
                        TotalVendorLedgEntry[1]."Amount (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalVLEAmtLCY += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                    end;


                    trigger OnPostDataItem()
                    begin
                        if not PrintAmountInLCY then
                            UpdateCurrencyTotals;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not PrintAmountInLCY then
                            TempVendorLedgEntry.SetRange("Currency Code", TempCurrency.Code);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(TotalVendorLedgEntry);

                    if Number = 1 then begin
                        if not TempCurrency.FindSet(false, false) then
                            CurrReport.Break();
                    end else
                        if TempCurrency.Next = 0 then
                            CurrReport.Break();

                    if TempCurrency.Code <> '' then
                        CurrencyCode := TempCurrency.Code
                    else
                        CurrencyCode := GLSetup."LCY Code";

                    NumberOfCurrencies := NumberOfCurrencies + 1;
                end;

                trigger OnPreDataItem()
                begin
                    NumberOfCurrencies := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if NewPagePerVendor then
                    PageGroupNo := PageGroupNo + 1;

                TempCurrency.Reset();
                TempCurrency.DeleteAll();
                TempVendorLedgEntry.Reset();
                TempVendorLedgEntry.DeleteAll();
                Clear(GrandTotalVLERemaingAmtLCY);
                GrandTotalVLEAmtLCY := 0;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
            end;
        }
        dataitem(CurrencyTotals; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(Number_CurrencyTotals; Number)
            {
            }
            column(NewPagePerVend_CurrTotal; NewPagePerVendor)
            {
            }
            column(TempCurrency2Code; TempCurrency2.Code)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt6RemAmtLCY5; AgedVendorLedgEntry[6]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt1RemAmtLCY1; AgedVendorLedgEntry[1]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt2RemAmtLCY2; AgedVendorLedgEntry[2]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt3RemAmtLCY3; AgedVendorLedgEntry[3]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt4RemAmtLCY4; AgedVendorLedgEntry[4]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt5RemAmtLCY5; AgedVendorLedgEntry[5]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(CurrencySpecificationCaption; CurrencySpecificationCaptionLbl)
            {
            }
            column(Noofdays; Noofdays)
            { }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                    if not TempCurrency2.FindSet(false, false) then
                        CurrReport.Break();
                end else
                    if TempCurrency2.Next = 0 then
                        CurrReport.Break();

                Clear(AgedVendorLedgEntry);
                TempCurrencyAmount.SetRange("Currency Code", TempCurrency2.Code);
                if TempCurrencyAmount.FindSet(false, false) then
                    repeat
                        if TempCurrencyAmount.Date <> DMY2Date(31, 12, 9999) then
                            AgedVendorLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
                              TempCurrencyAmount.Amount
                        else
                            AgedVendorLedgEntry[6]."Remaining Amount" := TempCurrencyAmount.Amount;
                    until TempCurrencyAmount.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AgedAsOf; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged As Of';
                        ToolTip = 'Specifies the date that you want the aging calculated for.';
                    }
                    field(AgingBy; AgingBy)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aging by';
                        OptionCaption = 'Due Date,Posting Date,Document Date';
                        ToolTip = 'Specifies if the aging will be calculated from the due date, the posting date, or the document date.';
                    }
                    field(PrintAmountInLCY; PrintAmountInLCY)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Amounts in LCY';
                        ToolTip = 'Specifies if you want the report to specify the aging per vendor ledger entry.';
                    }
                    field(PrintDetails; PrintDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Details';
                        ToolTip = 'Specifies if you want the report to show the detailed entries that add up the total balance for each vendor.';
                    }
                    field(SelectRange; SelectRange)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Select Range';
                        trigger OnValidate()
                        begin
                            if selectRange = SelectRange::"30 Days" then begin
                                Days30 := true;
                                Days60 := false;

                                "1-30" := false;
                                "31-60" := false;
                                "61-90" := false;
                                "91-120" := false;
                            end else begin
                                if selectRange = selectRange::"60 Days" then begin
                                    Days60 := true;
                                    Days30 := false;

                                    "1-60" := false;
                                    "61-120" := false;
                                    "121-180" := false;
                                    "181-240" := false;
                                end else begin
                                    Days30 := false;
                                    Days60 := false;
                                end;

                            end;

                        end;
                    }
                    field(HeadingType; HeadingType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Heading Type';
                        OptionCaption = 'Date Interval,Number of Days';
                        ToolTip = 'Specifies if the column heading for the three periods will indicate a date interval or the number of days overdue.';
                    }
                    field(NewPagePerVendor; NewPagePerVendor)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Vendor';
                        ToolTip = 'Specifies if each vendor''s information is printed on a new page if you have chosen two or more vendors to be included in the report.';
                    }
                    field(UseExternalDocNo; UseExternalDocNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Use External Document No.';
                        ToolTip = 'Specifies if you want to print the vendor''s document numbers, such as the invoice number, on all transactions. Clear this check box to print only internal document numbers.';
                    }
                }
                group(days30)
                {
                    caption = 'Range By 30 Days';
                    Visible = days30;
                    field("1-30"; "1-30")
                    {
                        ApplicationArea = All;
                        Caption = '1-30';
                        trigger OnValidate()
                        begin
                            if "1-30" = false then begin
                                "31-60" := false;
                                "61-90" := false;
                                "91-120" := false;
                            end;
                        end;
                    }
                    field("31-60"; "31-60")
                    {
                        Caption = '31-60';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if "31-60" = true then
                                "1-30" := true
                            else
                                if "31-60" = false then begin
                                    "61-90" := false;
                                    "91-120" := false;
                                end;
                        end;
                    }
                    field("61-90"; "61-90")
                    {
                        Caption = '61-90';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if "61-90" = true then begin
                                "1-30" := true;
                                "31-60" := true;
                            end else
                                if "61-90" = false then begin
                                    "91-120" := false;
                                end;
                        end;
                    }
                    field("91-120"; "91-120")
                    {
                        Caption = '91-120';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if "91-120" = true then begin
                                "1-30" := true;
                                "31-60" := true;
                                "61-90" := true;
                            end;
                        end;
                    }
                }
                group(days60)
                {
                    Caption = 'Group by 60 Days';
                    Visible = days60;

                    field("1-60"; "1-60")
                    {
                        ApplicationArea = All;
                        Caption = '1-60';
                        trigger OnValidate()
                        begin
                            if "1-60" = false then begin
                                "61-120" := false;
                                "121-180" := false;

                            end;
                        end;
                    }
                    field("61-120"; "61-120")
                    {
                        Caption = '61-120';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if "61-120" = true then
                                "1-60" := true
                            else
                                if "61-120" = false then begin
                                    "121-180" := false;
                                    "181-240" := false;
                                end;
                        end;
                    }
                    field("121-180"; "121-180")
                    {
                        Caption = '121-180';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if "121-180" = true then begin
                                "1-60" := true;
                                "61-120" := true;
                            end else
                                if "121-180" = false then begin
                                    "181-240" := false;
                                end;
                        end;
                    }
                    field("181-240"; "181-240")
                    {
                        Caption = '181-240';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if "181-240" = true then begin
                                "1-60" := true;
                                "61-120" := true;
                                "121-180" := true;
                            end;
                        end;

                    }

                }

            }

        }
        actions
        {
        }

        trigger OnOpenPage()
        begin
            if EndingDate = 0D then
                EndingDate := WorkDate();
            if Format(PeriodLength) = '' then
                if SelectRange = SelectRange::"30 Days" then
                    Evaluate(PeriodLength, '<30D>')
                else
                    Evaluate(PeriodLength, '<60D>')
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        // Check1 := false;
        // Check2 := false;
        // Check3 := false;
        // Check4 := false;
        // SetRangeDays();
        SetDaysRange();
        VendorFilter := FormatDocument.GetRecordFiltersWithCaptions(Vendor);

        GLSetup.Get();

        CalcDates;
        CreateHeadings;

        TodayFormatted := TypeHelper.GetFormattedCurrentDateTimeInUserTimeZone('f');
        CompanyDisplayName := COMPANYPROPERTY.DisplayName;

        if UseExternalDocNo then
            DocNoCaption := ExternalDocumentNoCaptionLbl
        else
            DocNoCaption := DocumentNoCaptionLbl;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TempVendorLedgEntry: Record "Vendor Ledger Entry" temporary;
        VendorLedgEntryEndingDate: Record "Vendor Ledger Entry";
        TotalVendorLedgEntry: array[5] of Record "Vendor Ledger Entry";
        AgedVendorLedgEntry: array[6] of Record "Vendor Ledger Entry";
        TempCurrency: Record Currency temporary;
        TempCurrency2: Record Currency temporary;
        TempCurrencyAmount: Record "Currency Amount" temporary;
        DetailedVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        TypeHelper: Codeunit "Type Helper";
        GrandTotalVLERemaingAmtLCY: array[5] of Decimal;
        GrandTotalVLEAmtLCY: Decimal;
        VendorFilter: Text;
        PrintAmountInLCY: Boolean;
        EndingDate: Date;
        AgingBy: Option "Due Date","Posting Date","Document Date";
        PeriodLength: DateFormula;
        PrintDetails: Boolean;
        UseExternalDocNo: Boolean;
        HeadingType: Option "Date Interval","Number of Days";
        NewPagePerVendor: Boolean;
        PeriodStartDate: array[5] of Date;
        PeriodEndDate: array[5] of Date;
        HeaderText: array[5] of Text[30];
        Text000: Label 'Not Due';
        BeforeTok: Label '>';
        CurrencyCode: Code[10];
        Text002: Label 'days';
        Text004: Label 'Aged by %1';
        Text005: Label 'Total for %1';
        Text006: Label 'Aged as of %1';
        Text007: Label 'Aged by %1';
        NumberOfCurrencies: Integer;
        Text009: Label 'Due Date,Posting Date,Document Date';
        Text010: Label 'The Date Formula %1 cannot be used. Try to restate it, for example, by using 1M+CM instead of CM+1M.';
        PageGroupNo: Integer;
        EnterDateFormulaErr: Label 'Enter a date formula in the Period Length field.';
        Text027: Label '-%1', Comment = 'Negating the period length: %1 is the period length';
        AgedAcctPayableCaptionLbl: Label 'Aged Accounts Payable';
        CurrReportPageNoCaptionLbl: Label 'Page';
        AllAmtsinLCYCaptionLbl: Label 'All Amounts in LCY';
        AgedOverdueAmsCaptionLbl: Label 'Aged Overdue Amounts';
        GrandTotalVLE5RemAmtLCYCaptionLbl: Label 'Balance';
        AmountLCYCaptionLbl: Label 'Original Amount';
        DueDateCaptionLbl: Label 'Due Date';
        DocumentNoCaptionLbl: Label 'Document No.';
        ExternalDocumentNoCaptionLbl: Label 'External Document No.';
        PostingDateCaptionLbl: Label 'Posting Date';
        DocumentTypeCaptionLbl: Label 'Document Type';
        CurrencyCaptionLbl: Label 'Currency Code';
        TotalLCYCaptionLbl: Label 'Total (LCY)';
        CurrencySpecificationCaptionLbl: Label 'Currency Specification';
        TodayFormatted: Text;
        CompanyDisplayName: Text;
        DocNoCaption: Text;
        DocumentNo: Code[35];
        "1-30": Boolean;
        "31-60": Boolean;
        "61-90": Boolean;
        "91-120": Boolean;
        Noofdays: Integer;
        Demostart: array[5] of Date;
        Demoend: array[5] of Date;
        SelectRange: Option "Select Gap","30 Days","60 Days";
        [InDataSet]
        SelectR, days30, days60 : Boolean;
        "1-60": Boolean;
        "61-120": Boolean;
        "121-180": Boolean;
        "181-240": Boolean;
        Check1: Boolean;
        Check2: Boolean;
        Check3: Boolean;
        Check4: Boolean;

    local procedure CalcDates()
    var
        i: Integer;
        PeriodLength2: DateFormula;
    begin
        Noofdays := GetNoOfDays();
        if not Evaluate(PeriodLength2, StrSubstNo(Text027, PeriodLength)) then
            Error(EnterDateFormulaErr);
        if AgingBy = AgingBy::"Due Date" then begin
            PeriodEndDate[1] := DMY2Date(31, 12, 9999);
            PeriodStartDate[1] := EndingDate + 1;
            Demoend[1] := EndingDate;
            Demostart[1] := CalcDate(PeriodLength2, EndingDate + 1);
        end else begin
            PeriodEndDate[1] := EndingDate;
            PeriodStartDate[1] := CalcDate(PeriodLength2, EndingDate + 1);
        end;
        Demoend[1] := EndingDate;
        Demostart[1] := CalcDate(PeriodLength2, EndingDate + 1);
        for i := 2 to Noofdays do begin

            PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
            PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
            Demoend[i] := Demostart[i - 1] - 1;
            Demostart[i] := CalcDate(PeriodLength2, Demoend[i] + 1);

        end;

        i := Noofdays;

        PeriodStartDate[i] := 0D;

        for i := 1 to Noofdays do
            if PeriodEndDate[i] < PeriodStartDate[i] then
                Error(Text010, PeriodLength);
    end;

    local procedure CreateHeadings()
    var
        i: Integer;
    begin
        i := 1;
        while i < Noofdays do begin
            if HeadingType = HeadingType::"Date Interval" then
                HeaderText[i] := StrSubstNo('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
            else begin
                if AgingBy = AgingBy::"Due Date" then begin
                    if SelectRange = SelectRange::"30 Days" then begin
                        HeaderText[i] := StrSubstNo('%1 - %2 %3', EndingDate - Demoend[i] + 1, EndingDate - Demoend[i + 1], Text002);
                    end else
                        HeaderText[i] := StrSubstNo('%1 - %2 %3', EndingDate - Demoend[i] + 1, EndingDate - Demoend[i + 1], Text002);
                end else begin
                    if SelectRange = SelectRange::"30 Days" then begin
                        HeaderText[i] :=
                                StrSubstNo('%1 - %2 %3', EndingDate - Demoend[i] + 1, EndingDate - Demoend[i + 1], Text002);
                    end else
                        if SelectRange = SelectRange::"60 Days" then begin
                            HeaderText[i] :=
                                        StrSubstNo('%1 - %2 %3', EndingDate - Demoend[i] + 1, EndingDate - Demoend[i + 1], Text002);
                        end;
                end;
            end;
            i := i + 1;
        end;
        if HeadingType = HeadingType::"Date Interval" then begin

            HeaderText[i] := StrSubstNo('%1\%2', BeforeTok, PeriodStartDate[i - 1])

        end else begin
            if AgingBy = AgingBy::"Due Date" then begin
                HeaderText[i] := StrSubstNo('%1 %2 %3', BeforeTok, EndingDate - Demostart[i - 1] + 1, Text002);
            end else
                HeaderText[i] := StrSubstNo('%1 %2 %3', BeforeTok, EndingDate - PeriodStartDate[i - 1] + 1, Text002);
        end;

    end;

    local procedure InsertTemp(var VendorLedgEntry: Record "Vendor Ledger Entry")
    var
        Currency: Record Currency;
    begin
        with TempVendorLedgEntry do begin
            if Get(VendorLedgEntry."Entry No.") then
                exit;
            TempVendorLedgEntry := VendorLedgEntry;
            Insert;
            if PrintAmountInLCY then begin
                Clear(TempCurrency);
                TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
                if TempCurrency.Insert() then;
                exit;
            end;
            if TempCurrency.Get("Currency Code") then
                exit;
            if "Currency Code" <> '' then
                Currency.Get("Currency Code")
            else begin
                Clear(Currency);
                Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
            end;
            TempCurrency := Currency;
            TempCurrency.Insert();
        end;
    end;

    local procedure GetPeriodIndex(Date: Date): Integer
    var
        i: Integer;
    begin
        for i := 1 to Noofdays do
            if Date in [PeriodStartDate[i] .. PeriodEndDate[i]] then
                exit(i);
    end;

    local procedure UpdateCurrencyTotals()
    var
        i: Integer;
    begin
        TempCurrency2.Code := CurrencyCode;
        if TempCurrency2.Insert() then;
        with TempCurrencyAmount do begin
            for i := 1 to Noofdays do begin
                "Currency Code" := CurrencyCode;
                Date := PeriodStartDate[i];
                if Find then begin
                    Amount := Amount + TotalVendorLedgEntry[i]."Remaining Amount";
                    Modify;
                end else begin
                    "Currency Code" := CurrencyCode;
                    Date := PeriodStartDate[i];
                    Amount := TotalVendorLedgEntry[i]."Remaining Amount";
                    Insert;
                end;
            end;
            "Currency Code" := CurrencyCode;
            Date := DMY2Date(31, 12, 9999);
            if Find then begin
                Amount := Amount + TotalVendorLedgEntry[1].Amount;
                Modify;
            end else begin
                "Currency Code" := CurrencyCode;
                Date := DMY2Date(31, 12, 9999);
                Amount := TotalVendorLedgEntry[1].Amount;
                Insert;
            end;
        end;
    end;

    procedure InitializeRequest(NewEndingDate: Date; NewAgingBy: Option; NewPeriodLength: DateFormula; NewPrintAmountInLCY: Boolean; NewPrintDetails: Boolean; NewHeadingType: Option; NewNewPagePerVendor: Boolean)
    begin
        EndingDate := NewEndingDate;
        AgingBy := NewAgingBy;
        PeriodLength := NewPeriodLength;
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintDetails := NewPrintDetails;
        HeadingType := NewHeadingType;
        NewPagePerVendor := NewNewPagePerVendor;
    end;

    local procedure CopyDimFiltersFromVendor(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        if Vendor.GetFilter("Global Dimension 1 Filter") <> '' then
            VendorLedgerEntry.SetFilter("Global Dimension 1 Code", Vendor.GetFilter("Global Dimension 1 Filter"));
        if Vendor.GetFilter("Global Dimension 2 Filter") <> '' then
            VendorLedgerEntry.SetFilter("Global Dimension 2 Code", Vendor.GetFilter("Global Dimension 2 Filter"));
    end;

    local procedure GetNoOfDays(): Integer
    var
        n: Integer;
    begin
        n := 1;
        if SelectRange = SelectRange::"30 Days" then begin
            if "1-30" = true then
                n += 1;
            if "31-60" = true then
                n += 1;
            if "61-90" = true then
                n += 1;
            if "91-120" = true then
                n += 1;
        end else begin
            if "1-60" = true then
                n += 1;
            if "61-120" = true then
                n += 1;
            if "121-180" = true then
                n += 1;
            if "181-240" = true then
                n += 1;
        end;
        // else
        //     Error('Select your option');
        exit(n);
    end;
    //getting the range of days i.e. 30days or 60days using if else condition
    local procedure SetRangeDays()
    begin
        if SelectRange = SelectRange::"30 Days" then begin
            if "1-30" = true then
                Check1 := true;
            if "31-60" = true then
                Check2 := true;
            if "61-90" = true then
                Check3 := true;
            if "91-120" = true then
                Check4 := true;
        end else
            if SelectRange = SelectRange::"60 Days" then begin
                Check1 := true;
                Check2 := true;
                Check3 := true;
                Check4 := true;
            end else begin
                Check1 := false;
                Check2 := false;
                Check3 := false;
                Check4 := false;
            end;
    end;
    //getting the range of days i.e. 30days or 60days using switch case
    local procedure SetDaysRange()
    begin
        case SelectRange of
            selectRange::"Select Gap":
                SetFieldsVisible(false, false, false);
            SelectRange::"30 Days":
                SetFieldsVisible(false, false, false);
            SelectRange::"60 Days":
                SetFieldsVisible(false, false, false);
        end;
    end;

    local procedure SetFieldsVisible(Selectr: Boolean; Days30: Boolean; Days60: Boolean)
    begin
        SelectR := Selectr;
        days30 := Days30;
        days60 := Days60;
    end;
}
