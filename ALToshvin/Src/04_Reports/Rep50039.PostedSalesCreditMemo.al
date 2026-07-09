report 50039 "Posted Sales Credit Memo"
{
    //TBC-949 Sales Credit Note print --->
    ApplicationArea = All;
    Caption = 'Posted Sales Credit Memo';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\Reports\Layouts\PostedSalesCreditMemo.rdlc';
    dataset
    {
        dataitem(Header; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "No.";
            //Customer Details Tab
            DataItemTableView = SORTING("No.");
            column(CreditNoteNo; "No.") { }
            column(Credit_Posting_Date; PostingDate) { }
            column(Your_Reference; "Your Reference") { }
            column(Sell_to_Contact_No_; SellToContact.Name) { }
            column(SellToEmail; SellToContact."E-Mail") { }
            column(Invoice_No; "Applies-to Doc. No.") { }
            column(PSIDate; PSIDate) { }
            //Details Tab
            column(Customer_PO_No; "External Document No.") { }
            column(Customer_PO_Date; "Posting Date") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(EncodeStr; EncodeStr) { }
            column(Payment_Terms_Description; "Payment Terms Code") { }
            column(Narration; Narration) { }
            column(ShippingAgentName; ShippingAgentName) { }
            column(RoundOff; RoundOff) { }
            column(RoundOffTotalOutstanding; RoundOffTotalOutstanding) { }
            //Bill-to Address Tab 
            column(Bill_to_Customer_No_; BillToCustomer) { }
            column(Bill_to_Name; BillToName) { }
            column(Bill_to_Address; BillToAddress) { }
            column(Bill_to_Address_2; BillToAddress2) { }
            column(Bill_to_City; BillToCity) { }
            column(Bill_to_Post_Code; BillToPostCode) { }
            column(Bill_to_Country_Region_Code; BillToCountryRegionCode) { }
            column(Bill_to_County; BillToCounty) { }
            column(Bill_To_GST_No; Cust."GST Registration No.") { }
            column(Bill_To_PAN_No; Cust."P.A.N. No.") { }
            column(Bill_To_State_Name; BillToState.Description) { }
            column(Bill_To_State_Code; BillToState."State Code (GST Reg. No.)") { }
            //Ship-to Address Tab
            column(Ship_To_Code; ShipToCode) { }
            column(Ship_to_Name; ShipToName) { }
            column(Ship_to_Address; ShipToAddress) { }
            column(Ship_to_Address_2; ShipToAddress2) { }
            column(Ship_to_City; ShipToCity) { }
            column(Ship_to_Post_Code; ShipToPostCode) { }
            column(Ship_to_Country_Region_Code; ShipToCountryRegionCode) { }
            column(Ship_to_County; ShipToCounty) { }
            column(Ship_To_State_Name; ShipToState.Description) { }
            column(Ship_To_State_Code; STCStateCode) { }
            //Company Information Tab
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyPostCode; companyinfo."Post Code") { }
            column(CompanyGSTNo; CompanyInfo."GST Registration No.") { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(CurrentDate; CurrentDateFormat) { }
            column(CompanyInfoCINNo; CompanyInfo."CIN No.") { }
            column(CurrentTime; CurrentTime) { }
            //Labels
            column(CreditNoteLbl; CreditNoteLbl) { }
            column(CustomerDetailLbl; CustomerDetailLbl) { }
            column(DetailLbl; DetailLbl) { }
            column(CreditNoteNoLbl; CreditNoteNoLbl) { }
            column(CreditNoteDtLbl; CreditNoteDtLbl) { }
            column(InvoiceNoLbl; InvoiceNoLbl) { }
            column(InvoiceDtLbl; InvoiceDtLbl) { }
            column(OurRefLbl; OurRefLbl) { }
            column(KindAttnLbl; KindAttnLbl) { }
            column(EmailLbl; EmailLbl) { }
            column(PartyPONoLbl; PartyPONoLbl) { }
            column(PartyPODtLbl; PartyPODtLbl) { }
            column(PaymentTermLbl; PaymentTermLbl) { }
            column(BilltoLbl; BilltoLbl) { }
            column(ShiptoLbl; ShiptoLbl) { }
            column(GSTNoLbl; GSTNoLbl) { }
            column(PANNoLbl; PANNoLbl) { }
            column(StateLbl; StateLbl) { }
            column(StateCodeLbl; StateCodeLbl) { }
            column(Acknowledgement_No_; "Acknowledgement No.") { }
            column(IRN_Hash; "IRN Hash") { }
            column(QR_Code; "QR Code") { }
            column(AmountInWords; AmountInWords) { }
            column(RoundOffValue; RoundOffValue) { }
            column(Work_Description; WorkDescriptionTxt) { }
            dataitem(Location; Location)
            {
                DataItemLink = Code = field("Location Code");
                DataItemLinkReference = Header;
                DataItemTableView = sorting(Code);

                column(Name; Name) { }
                column(Address; Address) { }
                column(Address_2; "Address 2") { }
                column(City; City) { }
                column(County; County) { }
                column(Post_Code; "Post Code") { }
                column(Country_Region_Code; "Country/Region Code") { }
                column(GST_Registration_No_; "GST Registration No.") { }
                column(CompanyInfo_PAN_No; CompanyInfo."P.A.N. No.") { }


            }
            dataitem(Lines; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Line No.") where(Type = filter(Item | "G/L Account"));
                column(No_; "No.") { }
                column(Item_Description; Description) { }
                column(HSN_SAC_Code; HSNSACCode) { }
                column(Quantity; Quantity) { }
                column(Unit_Price; "Unit Price") { }
                column(TaxableAmt; TaxableAmt) { }
                column(TotalDiscAmt; TotalDiscAmt) { }
                column(CGSTper; CGSTper) { }
                column(CGSTAmt; CGSTAmt) { }
                column(SGSTper; SGSTper) { }
                column(SGSTAmt; SGSTAmt) { }
                column(IGSTper; IGSTper) { }
                column(IGSTAmt; IGSTAmt) { }
                column(TotalOutstandingAmt; TotalOutstandingAmt) { }
                column(SrNo; SrNo) { }
                trigger OnAfterGetRecord()
                var
                    DetailGSTEntry: Record "Detailed GST Ledger Entry";
                begin
                    Clear(HSNSACCode);

                    if Lines.Type = Lines.Type::Item then begin
                        if ItemMaster.Get(Lines."No.") then
                            HSNSACCode := ItemMaster."HSN/SAC Code";
                    end;

                    Clear(IGSTper);
                    Clear(IGSTAmt);
                    Clear(CGSTper);
                    Clear(CGSTAmt);
                    Clear(SGSTper);
                    Clear(SGSTAmt);
                    Clear(TotalDiscAmt);
                    Clear(TaxableAmt);
                    Clear(TotalOutstandingAmt);
                    SrNo += 1;
                    TotalDiscAmt := "Line Discount Amount" + "Inv. Discount Amount";
                    TaxableAmt := ("Unit Price" * Quantity) - TotalDiscAmt;

                    DetailGSTEntry.SetRange("Document No.", Lines."Document No.");
                    DetailGSTEntry.SetRange("Document Line No.", Lines."Line No.");
                    if DetailGSTEntry.FindFirst() then
                        if DetailGSTEntry."GST Component Code" = 'IGST' then begin
                            IGSTper := DetailGSTEntry."GST %";
                            IGSTAmt := DetailGSTEntry."GST Amount";
                        end
                        else if (DetailGSTEntry."GST Component Code" = 'SGST') or (DetailGSTEntry."GST Component Code" = 'CGST') then begin
                            SGSTper := DetailGSTEntry."GST %";
                            SGSTAmt := DetailGSTEntry."GST Amount";
                            CGSTper := DetailGSTEntry."GST %";
                            CGSTAmt := DetailGSTEntry."GST Amount";
                        end;

                    TotalOutstandingAmt := TaxableAmt + CGSTAmt + SGSTAmt + IGSTAmt;

                    Clear(RoundOffTotalOutstanding);
                    if RoundOff then
                        RoundOffTotalOutstanding := Round(TotalOutstandingAmt, 1, '=')
                    else
                        RoundOffTotalOutstanding := TotalOutstandingAmt;
                end;
            }
            trigger OnAfterGetRecord()
            var
                PoSalesCrMemoLine: Record "Sales Cr.Memo Line";
                BarcodeSym: Enum "Barcode Symbology 2D";
                BarcodeProvider: Interface "Barcode Font Provider 2D";
                DetailGSTEntry: Record "Detailed GST Ledger Entry";
                PSI: Record "Sales Invoice Header";
                SalesCommentLine: Record "Sales Comment Line";
                TotalUnitPrice: Decimal;
                TotalGST: Decimal;
            begin
                Header.CalcFields("QR Code");
                Clear(TotalUnitPrice);
                Clear(TotalGST);
                Clear(BalAmount);
                PostingDate := Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                SellToContact.GetOrClear(Header."Sell-to Contact No.");
                if "Payment Terms Code" <> '' then
                    PaymentTerms.Get(Header."Payment Terms Code");
                Cust.Get(Header."Bill-to Customer No.");
                BillToState.Get(Header."GST Bill-to State Code");
                // if Header."Ship-to GST Reg. No." <> '' then
                //     ShipToState.Get(Header."Ship-to GST Reg. No.");


                PoSalesCrMemoLine.SetRange("Document No.", Header."No.");
                if PoSalesCrMemoLine.FindSet() then
                    repeat
                        TotalUnitPrice += ((PoSalesCrMemoLine.Quantity * PoSalesCrMemoLine."Unit Price") - (PoSalesCrMemoLine."Line Discount Amount" + PoSalesCrMemoLine."Inv. Discount Amount"));
                        DetailGSTEntry.SetRange("Document No.", PoSalesCrMemoLine."Document No.");
                        DetailGSTEntry.SetRange("Document Line No.", PoSalesCrMemoLine."Line No.");
                        if DetailGSTEntry.FindSet() then
                            repeat
                                TotalGST += DetailGSTEntry."GST Amount";
                            until DetailGSTEntry.Next() = 0;
                    until PoSalesCrMemoLine.Next() = 0;

                BalAmount := Round(TotalUnitPrice + TotalGST, 0.01);
                // Round Off Value
                clear(RoundOffValue);
                if RoundOff then
                    RoundOffValue := Round(BalAmount, 1, '=')
                else
                    RoundOffValue := BalAmount;
                RoundOffValue := ROUND(RoundOffValue, 0.01);
                AmountInWords := AmountInWordsIndian(RoundOffValue);

                // QR Code
                EncodeStr := Format(Header."No.");
                BarcodeProvider := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                BarcodeSym := Enum::"Barcode Symbology 2D"::"QR-Code";
                EncodeStr := BarcodeProvider.EncodeFont(EncodeStr, BarcodeSym);
                // get Posted Sales Invoice Date
                if Header."Applies-to Doc. No." <> '' then
                    if PSI.get(Header."Applies-to Doc. No.") then
                        PSIDate := Format(PSI."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');

                // comments/narration values from Sales Comment Line table
                SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::"Posted Credit Memo");
                SalesCommentLine.SetRange("No.", Header."No.");
                SalesCommentLine.SetRange("Document Line No.", 0);
                if SalesCommentLine.FindSet() then
                    repeat
                        if Narration = '' then
                            Narration := SalesCommentLine.Comment
                        else
                            Narration := Narration + ', ' + SalesCommentLine.Comment;
                    until SalesCommentLine.Next() = 0;

                Clear(ShippingAgentName);
                if ShippingAgent.Get(Header."Shipping Agent Code") then
                    ShippingAgentName := ShippingAgent.Name;

                Clear(ShipToName);
                Clear(ShipToAddress);
                Clear(ShipToAddress2);
                Clear(ShipToCity);
                Clear(ShipToPostCode);
                Clear(ShipToCounty);
                Clear(ShipToCountryRegionCode);
                Clear(BillToName);
                Clear(BillToAddress);
                Clear(BillToAddress2);
                Clear(BillToCity);
                Clear(BillToPostCode);
                Clear(BillToCounty);
                Clear(BillToCountryRegionCode);
                Clear(BillToCustomer);
                Clear(ShipToCode);
                if Header."Applies-to Doc. No." <> '' then begin
                    SalesInvHeader.Reset();
                    SalesInvHeader.SetRange("No.", Header."Applies-to Doc. No.");
                    if SalesInvHeader.FindFirst() then begin
                        ShipToName := SalesInvHeader."Ship-to Name";
                        ShipToAddress := SalesInvHeader."Ship-to Address";
                        ShipToAddress2 := SalesInvHeader."Ship-to Address 2";
                        ShipToCity := SalesInvHeader."Ship-to City";
                        ShipToPostCode := SalesInvHeader."Ship-to Post Code";
                        ShipToCounty := SalesInvHeader."Ship-to County";
                        ShipToCountryRegionCode := SalesInvHeader."Ship-to Country/Region Code";
                        BillToCustomer := SalesInvHeader."Bill-to Customer No.";
                        BillToName := SalesInvHeader."Bill-to Name";
                        BillToAddress := SalesInvHeader."Bill-to Address";
                        BillToAddress2 := SalesInvHeader."Bill-to Address 2";
                        BillToCity := SalesInvHeader."Bill-to City";
                        BillToPostCode := SalesInvHeader."Bill-to Post Code";
                        BillToCounty := SalesInvHeader."Bill-to County";
                        BillToCountryRegionCode := SalesInvHeader."Bill-to Country/Region Code";

                        if SalesInvHeader."Custom Ship-to" = SalesInvHeader."Custom Ship-to"::"Default (Sell-to Address)" then begin
                            if Customer.Get("Sell-to Customer No.") then begin
                                ShipToCode := Customer."No.";
                                if ShipToState.Get(Customer."State Code") then
                                    STCStateCode := ShipToState."State Code (GST Reg. No.)";
                            end;
                        end else
                            if SalesInvHeader."Custom Ship-to" = SalesInvHeader."Custom Ship-to"::"Alternate Shipping Address" then begin
                                if SalesInvHeader."Ship-to Code" <> '' then
                                    if RecShiptoAddress.Get("Sell-to Customer No.", "Ship-to Code") then begin
                                        ShipToCode := RecShiptoAddress.Code;
                                        ShipToState.Reset();
                                        if ShipToState.Get(RecShiptoAddress."State") then
                                            STCStateCode := ShipToState."State Code (GST Reg. No.)";
                                    end;
                            end
                            else if SalesInvHeader."Custom Ship-to" = SalesInvHeader."Custom Ship-to"::"Custom Address" then begin
                                ShiptoCode := SalesInvHeader."Ship-to Code";
                                if ShipToState.Get(SalesInvHeader."GST Ship-to State Code") then
                                    STCStateCode := ShipToState."State Code (GST Reg. No.)";
                            end;
                    end;
                end else begin
                    ShipToCode := Header."Ship-to Code";
                    ShipToName := Header."Ship-to Name";
                    ShipToAddress := Header."Ship-to Address";
                    ShipToAddress2 := Header."Ship-to Address 2";
                    ShipToCity := Header."Ship-to City";
                    ShipToPostCode := Header."Ship-to Post Code";
                    ShipToCounty := Header."Ship-to County";
                    ShipToCountryRegionCode := Header."Ship-to Country/Region Code";
                    BillToCustomer := Header."Bill-to Customer No.";
                    BillToName := Header."Bill-to Name";
                    BillToAddress := Header."Bill-to Address";
                    BillToAddress2 := Header."Bill-to Address 2";
                    BillToCity := Header."Bill-to City";
                    BillToPostCode := Header."Bill-to Post Code";
                    BillToCounty := Header."Bill-to County";
                    BillToCountryRegionCode := Header."Bill-to Country/Region Code";
                    if Header."GST Ship-to State Code" <> '' then
                        if ShipToState.Get(Header."GST Ship-to State Code") then
                            STCStateCode := ShipToState."State Code (GST Reg. No.)";
                end;

                Clear(WorkDescriptionTxt);
                Header.CalcFields("Work Description");
                if Header."Work Description".HasValue then begin
                    Header."Work Description".CreateInStream(InStr);
                    InStr.ReadText(WorkDescriptionTxt);
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = '';

                    field(RoundOff; RoundOff)
                    {
                        ApplicationArea = All;
                        Caption = 'Round Off';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
        CurrentDate := DT2Date(CurrentDateTime);
        CurrentDateFormat := Format(CurrentDate, 0, '<Day,2>/<Month,2>/<Year4>');
        CurrentTime := DT2Time(CurrentDateTime);
    end;

    local procedure AmountInWordsIndian(Number: Decimal): Text[250]
    var
        WholePart: Integer;
        FractionPart: Integer;
        Words: Text[250];
    begin
        WholePart := Round(Number, 1, '<');  // Get rupees
        FractionPart := Round(Abs(Number - WholePart) * 100, 1, '>');  // Get paise

        if FractionPart = 100 then begin
            WholePart += 1;
            FractionPart := 0;
        end;
        Words := NumberToIndianWordsSafe(WholePart) + ' Rupees';
        if FractionPart > 0 then
            Words += ' And ' + NumberToIndianWordsSafe(FractionPart) + ' Paise';
        exit(Words + ' Only');
    end;

    local procedure NumberToIndianWordsSafe(Number: Integer): Text[250]
    var
        Units: array[20] of Text[20];
        Tens: array[10] of Text[20];
        Words: Text[250];
        TensPart: Integer;
        UnitsPart: Integer;
    begin
        // Initialize Units (index 1 to 20 for 0 to 19)
        Units[1] := 'Zero';
        Units[2] := 'One';
        Units[3] := 'Two';
        Units[4] := 'Three';
        Units[5] := 'Four';
        Units[6] := 'Five';
        Units[7] := 'Six';
        Units[8] := 'Seven';
        Units[9] := 'Eight';
        Units[10] := 'Nine';
        Units[11] := 'Ten';
        Units[12] := 'Eleven';
        Units[13] := 'Twelve';
        Units[14] := 'Thirteen';
        Units[15] := 'Fourteen';
        Units[16] := 'Fifteen';
        Units[17] := 'Sixteen';
        Units[18] := 'Seventeen';
        Units[19] := 'Eighteen';
        Units[20] := 'Nineteen';
        // Initialize Tens from 2 to 9 => indices 1 to 8 (safe indexing)
        // We'll shift indices to 1-based from 2-based to avoid out of range
        Tens[1] := 'Twenty';
        Tens[2] := 'Thirty';
        Tens[3] := 'Forty';
        Tens[4] := 'Fifty';
        Tens[5] := 'Sixty';
        Tens[6] := 'Seventy';
        Tens[7] := 'Eighty';
        Tens[8] := 'Ninety';
        if Number = 0 then
            exit('Zero');
        Words := '';
        // Crores
        if Number >= 10000000 then begin
            Words += NumberToIndianWordsSafe(Number DIV 10000000) + ' Crore ';
            Number := Number MOD 10000000;
        end;
        // Lakhs
        if Number >= 100000 then begin
            Words += NumberToIndianWordsSafe(Number DIV 100000) + ' Lakh ';
            Number := Number MOD 100000;
        end;
        // Thousands
        if Number >= 1000 then begin
            Words += NumberToIndianWordsSafe(Number DIV 1000) + ' Thousand ';
            Number := Number MOD 1000;
        end;
        // Hundreds
        if Number >= 100 then begin
            Words += NumberToIndianWordsSafe(Number DIV 100) + ' Hundred ';
            Number := Number MOD 100;
        end;
        // Last two digits
        if Number > 0 then begin
            if StrLen(Words) > 0 then
                Words += 'and ';
            if Number < 20 then
                Words += Units[Number + 1]  // Number 0..19 maps to Units[1..20]
            else begin
                TensPart := Number DIV 10;
                UnitsPart := Number MOD 10;
                // TensPart 2..9 maps to Tens[1..8]
                if (TensPart >= 2) and (TensPart <= 9) then
                    Words += Tens[TensPart - 1];  // Subtract 1 for correct index
                if UnitsPart > 0 then
                    Words += ' ' + Units[UnitsPart + 1];
            end;
        end;
        exit(DelChr(Words, '<>', ' '));
    end;

    var
        CompanyInfo: Record "Company Information";
        SellToContact: Record Contact;
        PaymentTerms: Record "Payment Terms";
        Cust: Record Customer;
        BillToState: Record State;
        ShipToState: Record State;
        AmountInWords: Text;
        TotalDiscAmt: Decimal;
        TaxableAmt: Decimal;
        HSNSACCode: Code[10];
        ItemMaster: Record Item;
        SrNo: Integer;
        TotalOutstandingAmt: Decimal;
        PostingDate: Text;
        WorkDescription: Text;
        CGSTper: Decimal;
        CGSTAmt: Decimal;
        SGSTper: Decimal;
        InStr: InStream;
        WorkDescriptionTxt: Text;
        SGSTAmt: Decimal;
        IGSTper: Decimal;
        IGSTAmt: Decimal;
        BalAmount: Decimal;
        EncodeStr: Text;
        CurrentDate: Date;
        CurrentDateFormat: Text;
        CurrentTime: Time;
        PSIDate: Text;
        Narration: Text;
        CreditNoteLbl: Label 'Credit Note';
        CustomerDetailLbl: Label 'Customer Detail';
        DetailLbl: Label 'Detail';
        CreditNoteNoLbl: Label 'Credit Note No.:';
        CreditNoteDtLbl: Label 'Credit Note Date:';
        InvoiceNoLbl: Label 'Invoice No.:';
        InvoiceDtLbl: Label 'Invoice Date:';
        OurRefLbl: Label 'Our Ref.:';
        KindAttnLbl: Label 'Kind Attn.:';
        EmailLbl: Label 'Email:';
        PartyPONoLbl: Label 'Party PO No.:';
        PartyPODtLbl: Label 'Party PO Date:';
        PaymentTermLbl: Label 'Payment Terms:';
        BilltoLbl: Label 'Bill to Address';
        ShiptoLbl: Label 'Ship to Address';
        GSTNoLbl: Label 'GSTIN No.:';
        PANNoLbl: Label 'PAN No.:';
        StateLbl: Label 'State:';
        StateCodeLbl: Label 'State Code:';
        ShippingAgent: Record "Shipping Agent";
        ShippingAgentName: Text;
        RoundOffValue: Decimal;
        RoundOffTotalOutstanding: Decimal;
        RoundOff: Boolean;
        SalesInvHeader: Record "Sales Invoice Header";
        STCStateCode: Code[10];
        RecShiptoAddress: Record "Ship-to Address";
        Customer: Record Customer;
        ShipToCode: Text;
        ShipToName: Text;
        ShipToAddress: Text;
        ShipToAddress2: Text;
        ShipToCity: Text;
        ShipToPostCode: Text;
        ShipToCounty: Text;
        ShipToCountryRegionCode: Text;
        BillToName: Text;
        BillToAddress: Text;
        BillToAddress2: Text;
        BillToCity: Text;
        BillToPostCode: Text;
        BillToCounty: Text;
        BillToCountryRegionCode: Text;
        BillToCustomer: Code[20];
}
