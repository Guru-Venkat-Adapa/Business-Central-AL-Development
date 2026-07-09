report 50001 CustomPurchaseOrder
{
    ApplicationArea = All;
    Caption = 'Purchase Order - Domestic';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\04_Reports\Layouts\CustomPurchaseOrder.rdl';
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Purchase - Order';
            // -------- Field Values
            column(PuchOrderNo_; "No.") { }
            column(PuchOrdPostDt; PostingDateFormat) { }
            column(PuchOrdPayment_Terms_Code; "Payment Term Details") { }
            column(Folio_No_; "Folio No.") { }
            column(VendorName; "Buy-from Vendor Name") { }
            column(VendorNo; "Buy-from Vendor No.") { }
            column(VendorAddress; "Buy-from Address") { }
            column(VendorAddress2; "Buy-from Address 2") { }
            column(VendorCity; "Buy-from City") { }
            column(VendorCounty; "Buy-from County") { }
            column(VendorPostCode; "Buy-from Post Code") { }
            column(VendorGSTNo; VendorGSTNo) { }
            column(VendorPANNo; VendorPANNo) { }
            column(Inco_Terms; "Inco Terms") { } //TBC-1039
            column(StateName; StateName) { }
            column(StateCode; StateCode) { }
            column(CompState; CompState) { }
            column(Expected_Receipt_Date; DeliveryDate) { }
            //Guru Code
            column(TransportationChg; "Transportation Chg.") { }
            column(DeliveryTerms; "Delivery Terms") { }
            column(SupplierQuoteNo; "Supplier Quote No.") { }
            column(SupplierQuoteDate; QuoteDate) { }
            column(Warranty; Warranty) { }
            //--------------  Bill to Details
            //Old Code --->
            // column(LocationName; LocationCode.Name) { }
            // column(LocationAdd; LocationCode.Address) { }
            // column(LocationAdd2; LocationCode."Address 2") { }
            // column(LocationCity; LocationCode.City) { }
            // column(LocationPostCode; LocationCode."Post Code") { }
            // column(LocationGSTNo; LocationCode."GST Registration No.") { }
            // column(LocationState; LocationState."State Code (GST Reg. No.)") { }
            //Old COde <----

            column(LocationName; LocationName) { }
            column(LocationAdd; LocationAdd) { }
            column(LocationAdd2; LocationAdd2) { }
            column(LocationCity; LocationCity) { }
            column(LocationPostCode; LocationPost) { }
            column(LocationGSTNo; LocationGSTNo) { }
            column(LocationState; LocationStateCode) { }

            //----------------- Ship to Details
            column(Ship_to_Name; ShiptoCustName) { }
            column(Ship_to_Address; ShiptoAdd) { }
            column(Ship_to_Address_2; ShiptoAdd2) { }
            column(Ship_to_City; ShiptoCity) { }
            column(Ship_to_Post_Code; ShiptoPin) { }
            column(ShiptoGSTNo; ShiptoGST) { }
            column(Ship_to_AddStateDesc; STCStateCode) { }

            // -------- Labels
            column(VendorDetailLabel; VendorDetailLabel) { }
            column(GSTNoLabel; GSTNoLabel) { }
            column(StateLabel; StateLabel) { }
            column(PANNoLabel; PANNoLabel) { }
            column(StateCodeLabel; StateCodeLabel) { }
            column(PurchaseDetailLabel; PurchaseDetailLabel) { }
            column(PoNoLabel; PoNoLabel) { }
            column(PODateLabel; PODateLabel) { }
            column(OurRefLabel; OurRefLabel) { }
            column(TransportChgLabel; TransportChgLabel) { }
            column(DiliveryTermLabel; DiliveryTermLabel) { }
            column(PaymentTermLabel; PaymentTermLabel) { }
            column(SupplierQtNoLabel; SupplierQtNoLabel) { }
            column(SupplierQtDtLabel; SupplierQtDtLabel) { }
            column(WarrantyLabel; WarrantyLabel) { }
            column(BilltoLabel; BilltoLabel) { }
            column(ShiptoAddressLabel; ShiptoAddressLabel) { }
            column(GSTINLabel; GSTINLabel) { }
            column(SrNoLabel; SrNoLabel) { }
            column(ItemCodeLabel; ItemCodeLabel) { }
            column(DescriptionLabel; DescriptionLabel) { }
            column(HSNLabel; HSNLabel) { }
            column(QtyLabel; QtyLabel) { }
            column(UnitRateLabel; UnitRateLabel) { }
            column(DiscAmtLabel; DiscAmtLabel) { }
            column(TaxableAmtLabel; TaxableAmtLabel) { }
            column(CGSTLabel; CGSTLabel) { }
            column(SGSTLabel; SGSTLabel) { }
            column(IGSTLabel; IGSTLabel) { }
            column(TotalAmtLabel; TotalAmtLabel) { }
            column(AmountInWords; AmountInWords) { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemLinkReference = "Purchase Header";
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(ItemNo; "No.") { }
                column(ItemDescription; Description) { }
                column(Description_2; "Description 2") { }
                column(ItemQuantity; Quantity) { }
                column(ItemUnit_Price; "Direct Unit Cost") { }
                column(ItemLine_Amount; "Line Amount") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(IGST_Percentage; "IGST Percentage") { }
                column(IGST_Amount; "IGST Amount") { }
                column(SGST_Percentage; "SGST Percentage") { }
                column(SGST_Amount; "SGST Amount") { }
                column(CGST_Percentage; "CGST Percentage") { }
                column(CGST_Amount; "CGST Amount") { }
                column(TotalDiscAmt; TotalDiscAmt) { }
                column(TaxableAmt; TaxableAmt) { }
                column(TotalOutstandingAmt; TotalOutstandingAmt) { }

                trigger OnAfterGetRecord()
                begin
                    TotalDiscAmt := "Line Discount Amount" + "Inv. Discount Amount";
                    TaxableAmt := ("Direct Unit Cost" * Quantity) - TotalDiscAmt;
                    TotalOutstandingAmt := TaxableAmt + "CGST Amount" + "SGST Amount" + "IGST Amount";
                end;
            }
            //Footer Values
            column(OrderComments; OrderComments) { }
            column(CurrentDate; CurrentDateFormat) { }
            column(CurrentTime; CurrentTime) { }
            column(FootText1; FootText1) { }
            column(FootText2; FootText2) { }
            column(FootTextCompanyName; FootTextCompanyName) { }
            column(FootTextSignature; FootTextSignature) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyInfoAddress; CompanyInfo.Address) { }
            column(CompanyInfoAddress2; CompanyInfo."Address 2") { }
            column(GSTNo; CompanyInfo."GST Registration No.") { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyStateCode; companyinfo."State Code") { }
            column(CompanyPostCode; companyinfo."Post Code") { }
            column(BankName; CompanyInfo."Bank Name") { }
            column(BankBranch; CompanyInfo."Bank Branch No.") { }
            column(BankAcNo; CompanyInfo."Bank Account No.") { }
            column(IFSCCode; CompanyInfo."SWIFT Code") { }
            trigger OnAfterGetRecord()
            var
                Vendor: Record Vendor;
                State: Record State;
                Ship_to_Add: Record "Ship-to Address";
                PurchaseLine: Record "Purchase Line";
                Ship_to_AddState: Record State;
                CustomerDetail: Record Customer;
            begin
                Clear(PostingDateFormat);
                Clear(VendorGSTNo);
                Clear(VendorPANNo);
                Clear(StateCode);
                Clear(StateName);
                Clear(DeliveryDate);
                Clear(QuoteDate);
                Clear(OrderComments);
                Clear(AmountInWords);
                PostingDateFormat := Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                DeliveryDate := Format("Expected Receipt Date", 0, '<Day,2>/<Month,2>/<Year4>');
                QuoteDate := Format("Supplier Quote Date", 0, '<Day,2>/<Month,2>/<Year4>');
                //getting Vendor Data
                If Vendor.get("Buy-from Vendor No.") then begin
                    VendorGSTNo := Vendor."GST Registration No.";
                    VendorPANNo := Vendor."P.A.N. No.";
                    //Vendor State Details
                    if State.Get(Vendor."State Code") then begin
                        StateName := State.Description;
                        StateCode := State."State Code (GST Reg. No.)";
                    end;
                end;
                // Location Details
                Clear(ShiptoCustName);
                Clear(ShiptoAdd);
                Clear(ShiptoAdd2);
                Clear(ShiptoCity);
                Clear(ShiptoPin);
                Clear(ShiptoGST);
                Clear(STCStateCode);
                //OLD COde --->
                // if LocationCode.Get("Location Code") then;
                // if LocationState.Get(LocationCode."State Code") then;
                //OLd COde <---
                //ship-to address

                //TBC-984 --->
                Clear(LocationName);
                Clear(LocationAdd);
                Clear(LocationAdd2);
                Clear(LocationCity);
                Clear(LocationPost);
                Clear(LocationGSTNo);
                Clear(LocationStateCode);
                if "Purchase Header"."Bill to-Location(POS)" <> '' then begin
                    if LocationCode.Get("Purchase Header"."Bill to-Location(POS)") then begin
                        LocationName := LocationCode.Name;
                        LocationAdd := LocationCode.Address;
                        LocationAdd2 := LocationCode."Address 2";
                        LocationCity := LocationCode.City;
                        LocationPost := LocationCode."Post Code";
                        LocationGSTNo := LocationCode."GST Registration No.";
                        if LocationState.Get(LocationCode."State Code") then;
                        LocationStateCode := LocationState."State Code (GST Reg. No.)";
                    end;
                end else begin
                    // Location Details
                    if LocationCode.Get("Location Code") then begin
                        LocationName := LocationCode.Name;
                        LocationAdd := LocationCode.Address;
                        LocationAdd2 := LocationCode."Address 2";
                        LocationCity := LocationCode.City;
                        LocationPost := LocationCode."Post Code";
                        LocationGSTNo := LocationCode."GST Registration No.";
                        if LocationState.Get(LocationCode."State Code") then;
                        LocationStateCode := LocationState."State Code (GST Reg. No.)";
                    end
                end;
                //TBC-984 <---



                if "Purchase Header"."Custom Ship-to" = "Purchase Header"."Custom Ship-to"::"Default (Company Address)" then begin
                    ShiptoCustName := CompanyInfo.Name;
                    ShiptoAdd := CompanyInfo.Address;
                    ShiptoAdd2 := CompanyInfo."Address 2";
                    ShiptoCity := CompanyInfo.City;
                    ShiptoPin := CompanyInfo."Post Code";
                    ShiptoGST := CompanyInfo."GST Registration No.";
                    State.Reset();
                    if State.Get(CompanyInfo."State Code") then begin
                        // STCStateName := State.Description;
                        STCStateCode := State."State Code (GST Reg. No.)";

                    end;
                end
                else if "Purchase Header"."Custom Ship-to" = "Purchase Header"."Custom Ship-to"::Location then begin
                    if "Purchase Header"."Location Code" <> '' then begin

                        LocationCode.Reset();
                        if LocationCode.Get("Location Code") then begin

                            ShiptoCustName := LocationCode.Name;
                            ShiptoAdd := LocationCode.Address;
                            ShiptoAdd2 := LocationCode."Address 2";
                            ShiptoCity := LocationCode.City;
                            ShiptoPin := LocationCode."Post Code";
                            ShiptoGST := LocationCode."GST Registration No.";
                            State.Reset();
                            if State.Get(LocationCode."State Code") then begin
                                // STCStateName := State.Description;
                                STCStateCode := State."State Code (GST Reg. No.)";
                            end;
                        end;
                    end;
                end
                else if "Purchase Header"."Custom Ship-to" = "Purchase Header"."Custom Ship-to"::"Customer Address" then begin
                    if "Purchase Header"."Sell-to Customer No." <> '' then begin

                        CustomerDetail.Reset();
                        if CustomerDetail.Get("Sell-to Customer No.") then begin

                            ShiptoCustName := CustomerDetail.Name;
                            ShiptoAdd := CustomerDetail.Address;
                            ShiptoAdd2 := CustomerDetail."Address 2";
                            ShiptoCity := CustomerDetail.City;
                            ShiptoPin := CustomerDetail."Post Code";
                            ShiptoGST := CustomerDetail."GST Registration No.";
                            State.Reset();
                            if State.Get(LocationCode."State Code") then begin
                                // STCStateName := State.Description;
                                STCStateCode := State."State Code (GST Reg. No.)";
                            end;
                        end;
                    end;
                end
                else if "Purchase Header"."Custom Ship-to" = "Purchase Header"."Custom Ship-to"::"Custom Address" then begin
                    ShiptoCustName := "Ship-to Name";
                    ShiptoAdd := "Ship-to Address";
                    ShiptoAdd2 := "Ship-to Address 2";
                    ShiptoCity := "Ship-to City";
                    ShiptoPin := "Ship-to Post Code";
                end;

                PurchaseLine.SetRange("Document Type", "Purchase Header"."Document Type"::Order);
                PurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
                if PurchaseLine.FindSet() then
                    repeat
                        BalAmount += (((PurchaseLine."Direct Unit Cost" * PurchaseLine.Quantity) - (PurchaseLine."Line Discount Amount" + PurchaseLine."Inv. Discount Amount")) + PurchaseLine."CGST Amount" + PurchaseLine."SGST Amount" + PurchaseLine."IGST Amount");
                    until PurchaseLine.Next() = 0;

                AmountInWords := AmountInWordsIndian(BalAmount);

                //Comments Related to Purchase Order
                PurchCommentLine.Reset();
                PurchCommentLine.SetRange("Document Type", "Purchase Header"."Document Type");
                PurchCommentLine.SetRange("No.", "Purchase Header"."No.");
                if PurchCommentLine.FindSet() then
                    repeat
                        if OrderComments = '' then
                            OrderComments := PurchCommentLine.Comment
                        else
                            OrderComments := OrderComments + ', ' + PurchCommentLine.Comment;
                    until PurchCommentLine.Next() = 0;

            end;
        }
    }
    trigger OnPreReport()
    var
        State: Record State;
    begin
        Clear(CompState);
        Clear(CurrentDate);
        Clear(CurrentDateFormat);
        Clear(CurrentTime);
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
        If State.Get(CompanyInfo."State Code") then
            CompState := State.Description;
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
        Check: Report Check;
        PurchCommentLine: Record "Purch. Comment Line";
        LocationCode: Record Location;

        LocationState: Record State;
        NoText: array[2] of Text;
        VendorGSTNo: Code[20];
        VendorPANNo: Code[20];
        StateName: Text[50];
        StateCode: Code[10];
        CompState: Text[50];
        AmountTotal: Decimal;
        AmountInWords: Text;
        CurrentDateFormat: Text;
        PostingDateFormat: Text;
        CurrentDate: Date;
        CurrentTime: Time;
        TotalDiscAmt: Decimal;
        TaxableAmt: Decimal;
        TotalOutstandingAmt: Decimal;
        BalAmount: Decimal;
        DeliveryDate: Text;
        QuoteDate: Text;
        OrderComments: Text;
        ShiptoCustName: Text;
        ShiptoAdd: Text;
        ShiptoAdd2: Text;
        ShiptoCity: Text;
        ShiptoPin: Text;
        ShiptoGST: Code[20];
        // STCStateName: Text[50];
        STCStateCode: Text;
        VendorDetailLabel: Label 'Vendor Details';
        GSTNoLabel: Label 'GSTIN No. :';
        StateLabel: Label 'State :';
        PANNoLabel: Label 'PAN NO. :';
        StateCodeLabel: Label 'State Code :';
        PurchaseDetailLabel: Label 'Purchase Details';
        PoNoLabel: Label 'PO No. :';
        PODateLabel: Label 'PO Date :';
        OurRefLabel: Label 'Our Ref :';
        TransportChgLabel: Label 'Transportation Chg :';
        DiliveryTermLabel: Label 'Delivery Terms :';
        PaymentTermLabel: Label 'Payment Terms :';
        SupplierQtNoLabel: Label 'Supplier Quote No. :';
        SupplierQtDtLabel: Label 'Supplier Quote Date :';
        WarrantyLabel: Label 'Warranty :';
        BilltoLabel: Label 'Bill to :';
        ShiptoAddressLabel: Label 'Ship to Address :';
        GSTINLabel: Label 'GSTIN :';
        SrNoLabel: Label 'Sr No.';
        ItemCodeLabel: Label 'Item Code';
        DescriptionLabel: Label 'Description';
        HSNLabel: Label 'HSN/SAC';
        QtyLabel: Label 'Qty';
        UnitRateLabel: Label 'Unit Rate';
        DiscAmtLabel: Label 'Disc Amt';
        TaxableAmtLabel: Label 'Taxable Amount';
        CGSTLabel: Label 'CGST';
        SGSTLabel: Label 'SGST';
        IGSTLabel: Label 'IGST';
        TotalAmtLabel: Label 'Total Amount';
        FootText1: Label 'N.B. : 1) Payment should be made by Cheque / Draft on Mumbai Branch within agreed terms of this Invoice otherwise interest at the rate of 18% p.a shall be charged 2) The Company does not hold itself responsible for any loss or damage which occurs in transit after delivery of packages to the Railway or other carrying Agency except for goods sent under its own indemnity guarantee system 3) Please Notify carries immediately of damage 4) Advice us within SEVEN DAYS if any discrepancies or damages, otherwise no claim will be entertained.';
        FootText2: Label 'We hereby certify that our registration certificate under the GST act 2017 is in force on the date on which the sale of the goods specified in the Tax Invoice is made by us and that the transaction of sale is covered by the tax invoice has been effected by us and it shall be accounted for in the turn over and sales while filing of return and the due tax, if any payable on the sale has been paid or shall be paid.';
        FootTextCompanyName: Label 'For TOSHVIN ANALYTICAL PVT.LTD.';
        FootTextSignature: Label 'Authorized Signatory';
        //TBC-984 --->
        LocationName: Text[100];
        LocationAdd: Text[100];
        LocationAdd2: Text[50];
        LocationCity: Text[30];
        LocationPost: Code[20];
        LocationGSTNo: Code[20];
        LocationStateCode: Code[10];
}