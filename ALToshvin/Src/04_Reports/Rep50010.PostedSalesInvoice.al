report 50010 "Custom Posted Sales Invoice"
{
    Caption = 'Posted Sales/Tax Invoice';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Src\Reports\Layouts\CustomPostedSalesInvoice.rdl';
    dataset
    {
        dataitem(Header; "Sales Invoice Header")
        {
            // DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Posted Sales Invoice';
            /*  <-------------              Company Info               ---------------->*/
            column(Order_No_; "Order No.") { }
            column(SEZ_Instruction; "SEZ Instruction") { }
            column(SezValue; SezValue) { }
            column(ShippingAgentName; ShippingAgentName) { }
            column(CompanyDisplayName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }

            column(BankName; CompanyInfo."Bank Name") { }
            column(BankBranch; CompanyInfo."Bank Branch No.") { }
            column(BankAcNo; CompanyInfo."Bank Account No.") { }
            column(IFSCCode; CompanyInfo."SWIFT Code") { }
            column(CompanyPhNo; CompanyInfo."Phone No.") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(VirtualAcNo; VirtualAcNo) { }
            column(CompanyPANNo; CompanyInfo."P.A.N. No.") { }
            // <--------------------                       Invoice Detail           --------------------->
            column(Shortcut_Dimension_2_Code; DimensionValueName) { }
            column(SalesInvoiceNo_; "No.") { }
            column(Orderdate; InvoiceDate) { }
            column(ChallanNo; ChallanNo) { }
            column(ChallanDate; ChallanDate) { }
            column(EngName; EngName) { }
            column(JobWork; JobWork) { }
            column(Mode_of_Transport; "Mode of Transport") { }
            column(Transport_Method; TransportMethod.Description) { }
            column(AmountInWords; AmountInWords) { }
            column(FreightAmt; FreightAmt) { }
            column(EncodeStr; EncodeStr) { }
            column(LRNo; "LR/RR No.") { }
            column(LRDate; LRDate) { }
            column(IRN_Hash; "IRN Hash") { }
            column(QR_Code; "QR Code") { }


            //<-------------  Bill to details       ------------->
            column(BTCNo; BillToCust) { }
            column(BTCName; BilltoCustName) { }
            column(BTCAddress; BilltoAdd) { }
            column(BTCAddress2; BilltoAdd2) { }
            column(BTCCity; BilltoCity) { }
            column(BTCPostCode; BilltoPin) { }
            column(BTCStateName; BTCStateName) { }
            column(BTCStateCode; BTCStateCode) { }
            column(GSTNo; BilltoGST) { }
            column(PANNo; BilltoPAN) { }
            //  <----------------     Ship to Address Details      --------->
            column(STCCode; ShiptoCode) { }
            column(STCName; ShiptoCustName) { }
            column(STCAddress; ShiptoAdd) { }
            column(STCAddress2; ShiptoAdd2) { }
            column(STCCity; ShiptoCity) { }
            column(STCPostCode; ShiptoPin) { }
            column(ShiptoGST; ShiptoGST) { }
            column(ShiptoPAN; ShiptoPAN) { }
            column(STCStateName; STCStateName) { }
            column(STCStateCode; STCStateCode) { }

            /*  <--------------              Customer Details         ----------------------------*/
            column(Customer_Name; "Sell-to Customer Name") { }
            column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
            column(Sell_to_E_Mail; "Sell-to E-Mail") { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(Payment_Terms_Code; Payment_Term_Value) { }
            column(Narration; Narration) { }
            column(PoNo; "External Document No.") { }
            column(PoDate; PoDate) { }
            column(RoundOff; RoundOff) { }
            column(RoundOffTotalOutstanding; RoundOffTotalOutstanding) { }
            column(Prepayment_Amount; "Prepayment Amount") { }
            column(TCSAmount; TCSAmount) { }
            column(CompanyLogo; CompanyLogo) { }
            /*  <------------------                  Labels              ----------------------------->*/
            column(ProformaInvLbl; ProformaInvLbl) { }
            column(TaxInvoiceOriginalLbl; TaxInvoiceOriginalLbl) { }
            column(RegdNoLbl; RegdNoLbl) { }
            column(GSTINLbl; GSTINLbl) { }
            column(BTALbl; BTALbl) { }
            column(STALbl; STALbl) { }
            column(CustomerDetailLbl; CustomerDetailLbl) { }
            column(OurDetailsLbl; OurDetailsLbl) { }
            column(StateLbl; StateLbl) { }
            column(StateCodeLbl; StateCodeLbl) { }
            column(GSTNoLbl; GSTNoLbl) { }
            column(PANNoLbl; PANNoLbl) { }
            column(PONoLbl; PONoLbl) { }
            column(PODateLbl; PODateLbl) { }
            column(KindAttLbl; KindAttLbl) { }
            column(ContactNoLbl; ContactNoLbl) { }
            column(EmailLbl; EmailLbl) { }
            column(PayTremsLbl; PayTremsLbl) { }
            column(SplTermLbl; SplTermLbl) { }
            column(BranchLbl; BranchLbl) { }
            column(PINoLbl; PINoLbl) { }
            column(PIDateLbl; PIDateLbl) { }
            column(AmtRecdLbl; AmtRecdLbl) { }
            column(BalAmtLbl; BalAmtLbl) { }
            column(EngNameLbl; EngNameLbl) { }
            column(NarrationLbl; NarrationLbl) { }
            column(SrNoLbl; SrNoLbl) { }
            column(ProductDescLbl; ProductDescLbl) { }
            column(CodeLbl; CodeLbl) { }
            column(HSNSACLbl; HSNSACLbl) { }
            column(QtyLbl; QtyLbl) { }
            column(UnitRateLbl; UnitRateLbl) { }
            column(AmountLbl; AmountLbl) { }
            column(DiscAmtLbl; DiscAmtLbl) { }
            column(TaxableAmtLbl; TaxableAmtLbl) { }
            column(CGSTLbl; CGSTLbl) { }
            column(SGSTLbl; SGSTLbl) { }
            column(IGSTLbl; IGSTLbl) { }
            column(TotalAmtLbl; TotalAmtLbl) { }
            column(FreightAmtLbl; FreightAmtLbl) { }
            column(PackFwdLbl; PackFwdLbl) { }

            column(LUTNo; LUTNo) { }
            column(LutValue; LutValue) { }

            dataitem(Location; Location)
            {
                DataItemLink = Code = field("Location Code");
                DataItemLinkReference = Header;
                DataItemTableView = sorting(Code);
                column(Loc_Add; Address) { }
                column(Loc_Add2; "Address 2") { }
                column(Loc_Post_Code; "Post Code") { }
                column(CompanyGSTNo; "GST Registration No.") { }
            }
            dataitem(Line; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = CONST(Item), Quantity = FILTER(<> 0));

                column(ItemNo; "No.") { }
                column(ItemDescription; Description) { }
                column(Description_2; "Description 2") { }
                column(ItemQuantity; Quantity) { }
                column(ItemUnit_Price; "Unit Price") { }
                column(ItemLine_Amount; Line_Amount) { }
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
                column(SrNo; SrNo) { }

                dataitem("Sales Comment Line"; "Sales Comment Line")
                {
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.");
                    DataItemLink = "No." = field("Document No."), "Document Line No." = field("Line No.");
                    DataItemLinkReference = Line;
                    column(Remark; Comment) { }

                }
                trigger OnAfterGetRecord()
                begin
                    Clear(Line_Amount);
                    Clear(TotalDiscAmt);
                    Clear(TaxableAmt);
                    Clear(TotalOutstandingAmt);
                    Line_Amount := "Unit Price" * Quantity;
                    TotalDiscAmt := "Line Discount Amount" + "Inv. Discount Amount";
                    TaxableAmt := ("Unit Price" * Quantity) - TotalDiscAmt;
                    TotalOutstandingAmt := TaxableAmt + "CGST Amount" + "SGST Amount" + "IGST Amount";
                    SrNo += 1;
                    Clear(RoundOffTotalOutstanding);
                    if RoundOff then
                        RoundOffTotalOutstanding := Round(TotalOutstandingAmt, 1, '=')
                    else
                        RoundOffTotalOutstanding := TotalOutstandingAmt;
                end;
            }

            trigger OnAfterGetRecord()
            var
                State: Record State;
                Customer: Record Customer;
                PaymentTerm: Record "Payment Terms";
                SalesCommentLine: Record "Sales Comment Line";
                DimensionVal: Record "Dimension Value";
                Employee: Record "Employee";
                Contact: Record Contact;
                Salesline: Record "Sales Invoice Line";
                PurchaseLine: Record "Purchase Line";
                BarcodeSym: Enum "Barcode Symbology 2D";
                BarcodeProvider: Interface "Barcode Font Provider 2D";
                PostedSalesShipment: Record "Sales Shipment Header";
                PostedSaleInvoice: Record "Sales Invoice Line";
                ShiptoAddress: Record "Ship-to Address";
            begin
                Clear(InvoiceDate);
                Clear(PoDate);
                Clear(LRDate);
                Clear(ShiptoCode);
                Clear(ShiptoCustName);
                Clear(ShiptoAdd);
                Clear(ShiptoAdd2);
                Clear(ShiptoCity);
                Clear(ShiptoPin);
                Clear(ShiptoGST);
                Clear(ShiptoPAN);
                Clear(STCStateName);
                Clear(STCStateCode);
                Clear(BillToCust);
                Clear(BilltoCustName);
                Clear(BilltoAdd);
                Clear(BilltoAdd2);
                Clear(BilltoCity);
                Clear(BilltoPin);
                Clear(BilltoGST);
                Clear(BilltoPAN);
                Clear(BTCStateName);
                Clear(BTCStateCode);
                InvoiceDate := Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                PoDate := Format("Customer PO Date", 0, '<Day,2>/<Month,2>/<Year4>');
                LRDate := Format("Header"."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');
                Header.CalcFields("QR Code");
                if Header."Custom Ship-to" = Header."Custom Ship-to"::"Default (Sell-to Address)" then begin
                    if Customer.get("Sell-to Customer No.") then begin
                        ShiptoCode := Customer."No.";
                        ShiptoCustName := Customer.Name;
                        ShiptoAdd := Customer.Address;
                        ShiptoAdd2 := Customer."Address 2";
                        ShiptoCity := Customer.City;
                        ShiptoPin := Customer."Post Code";
                        ShiptoGST := Customer."GST Registration No.";
                        ShiptoPAN := Customer."P.A.N. No.";
                        State.Reset();
                        if State.Get(Customer."State Code") then begin
                            STCStateName := State.Description;
                            STCStateCode := State."State Code (GST Reg. No.)";
                        end;
                    end;
                end
                else if Header."Custom Ship-to" = Header."Custom Ship-to"::"Alternate Shipping Address" then begin
                    if Header."Ship-to Code" <> '' then
                        if ShiptoAddress.Get("Sell-to Customer No.", "Ship-to Code") then begin
                            ShiptoCode := ShiptoAddress.Code;
                            ShiptoCustName := ShiptoAddress.Name;
                            ShiptoAdd := ShiptoAddress.Address;
                            ShiptoAdd2 := ShiptoAddress."Address 2";
                            ShiptoCity := ShiptoAddress.City;
                            ShiptoPin := ShiptoAddress."Post Code";
                            ShiptoGST := ShiptoAddress."GST Registration No.";
                            if Customer.get("Sell-to Customer No.") then
                                ShiptoPAN := Customer."P.A.N. No.";
                            State.Reset();
                            if State.Get(ShiptoAddress.State) then begin
                                STCStateName := State.Description;
                                STCStateCode := State."State Code (GST Reg. No.)";
                            end;
                        end;
                end
                else if Header."Custom Ship-to" = Header."Custom Ship-to"::"Custom Address" then begin
                    ShiptoCode := "Ship-to Code";
                    ShiptoCustName := "Ship-to Name";
                    ShiptoAdd := "Ship-to Address";
                    ShiptoAdd2 := "Ship-to Address 2";
                    ShiptoCity := "Ship-to City";
                    ShiptoPin := "Ship-to Post Code";
                    ShiptoGST := "Custom GST No";
                    ShiptoPAN := "Custom PAN No.";
                    State.Reset();
                    if State.Get("Custom State") then begin
                        STCStateName := State.Description;
                        STCStateCode := State."State Code (GST Reg. No.)";
                    end;
                end;
                if Customer.get(Header."Sell-to Customer No.") then begin
                    // Bill-to Address
                    BillToCust := Customer."No.";
                    BilltoCustName := Customer.Name;
                    BilltoAdd := Customer.Address;
                    BilltoAdd2 := Customer."Address 2";
                    BilltoCity := Customer.City;
                    BilltoPin := Customer."Post Code";
                    BilltoGST := Customer."GST Registration No.";
                    BilltoPAN := Customer."P.A.N. No.";
                    VirtualAcNo := Customer."Virtual Account";
                    //getting state and state code of bill-to address
                    State.Reset();
                    if State.Get(Customer."State Code") then begin
                        BTCStateName := State.Description;
                        BTCStateCode := State."State Code (GST Reg. No.)";
                    end;
                    if Header."Sell-to Phone No." = '' then
                        PhoneNo := Customer."Phone No." else
                        PhoneNo := Header."Sell-to Phone No.";
                    // if Header."Sell-to E-Mail" = '' then
                    //     Email := Customer."E-Mail" else
                    //     Email := Header."Sell-to E-Mail";
                end;
                // Payment Term Description from Payment Terms table
                // Payment Term Description from Payment Terms table
                Clear(Payment_Term_Value);
                if Header."Sales Order Type" = 'INSTRUMENT' then
                    Payment_Term_Value := Header."Payment Term Details"
                else begin
                    if "Payment Terms Code" <> '' then
                        if PaymentTerm.Get(Header."Payment Terms Code") then
                            Payment_Term_Value := PaymentTerm.Description;
                end;
                // comments/narration values from Sales Comment Line table
                SalesCommentLine.SetRange("No.", "Header"."No.");
                SalesCommentLine.SetRange("Document Line No.", 0);
                if SalesCommentLine.FindSet() then
                    repeat
                        if Narration = '' then
                            Narration := SalesCommentLine.Comment
                        else
                            Narration := Narration + ', ' + SalesCommentLine.Comment;
                    until SalesCommentLine.Next() = 0;
                // Dimension Description from Dimension table
                If "Header"."Shortcut Dimension 2 Code" <> '' then begin
                    DimensionVal.Reset();
                    DimensionVal.SetFilter(Code, "Shortcut Dimension 2 Code");
                    if DimensionVal.FindFirst() then
                        DimensionValueName := DimensionVal.Name;
                end;
                Clear(SezValue);

                if Header."GST Customer Type" = Header."GST Customer Type"::"SEZ Unit" then
                    SezValue :=
                        'Supply meant for SEZ unit for authorized operations under Bond or Letter of Undertaking without payment of Integrated Tax '
                        + Header."SEZ Instruction"
                else
                    if Header."Deemed Export" then
                        SezValue := 'This Sale is under “Deemed Export “against Form A ' + "Header"."Deemed Export Instruction"
                    else
                        SezValue := 'THIS IS COMPUTER GENERATED INVOICE HENCE, NO SIGNATURE REQUIRED.';

                // Employee Name
                Clear(JobWork);
                Clear(EngName);
                if Header."Instrument Order" then
                    EngName := Header."Executive Master"
                else
                    if Header."Spare Order" then
                        EngName := "Executive Master";
                Employee.Reset();
                Employee.SetRange("No.", "Header"."Employee No.");
                if Employee.FindFirst() then begin
                    JobWork := Employee."Job Title";
                end;
                // Getting the total in words of the sales lines from sales lines table
                Clear(BalAmount);
                Salesline.Reset();
                Salesline.SetRange("Document No.", "Header"."No.");
                if Salesline.FindSet() then begin
                    repeat
                        BalAmount += (((Salesline."Unit Price" * Salesline.Quantity) - (Salesline."Line Discount Amount" + Salesline."Inv. Discount Amount")) + Salesline."CGST Amount" + Salesline."SGST Amount" + Salesline."IGST Amount");
                        if Salesline."No." = 'S-FREIGHT' then
                            FreightAmt += Salesline."Line Amount";
                    until Salesline.Next() = 0;
                end;
                BalAmount := ROUND(BalAmount, 0.01);
                // Round Off Value
                clear(RoundOffValue);
                if RoundOff then
                    RoundOffValue := Round(BalAmount, 1, '=')
                else
                    RoundOffValue := BalAmount;
                RoundOffValue := ROUND(RoundOffValue, 0.01);
                AmountInWords := AmountInWordsIndian(RoundOffValue);
                //Get Mobile No.
                // if Contact.Get("Sell-to Contact No.") then
                //     PhoneNo := Contact."Mobile Phone No.";
                //QR Code
                EncodeStr := Format(Header."QR Code");
                BarcodeProvider := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                BarcodeSym := Enum::"Barcode Symbology 2D"::"QR-Code";
                EncodeStr := BarcodeProvider.EncodeFont(EncodeStr, BarcodeSym);
                // Posted Sales Shipment No.
                Clear(ChallanDate);
                Clear(ChallanNo);
                if Header."Order No." <> '' then begin
                    PostedSalesShipment.Reset();
                    PostedSalesShipment.SetRange("Order No.", Header."Order No.");
                    if PostedSalesShipment.FindLast() then begin
                        ChallanNo := PostedSalesShipment."No.";
                        ChallanDate := Format(PostedSalesShipment."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                    end;
                end else begin
                    PostedSaleInvoice.Reset();
                    PostedSaleInvoice.SetRange("Document No.", Header."No.");
                    PostedSaleInvoice.SetRange(Type, PostedSaleInvoice.type::Item);
                    if PostedSaleInvoice.FindLast() then begin
                        ChallanNo := PostedSaleInvoice."Shipment No.";
                        ChallanDate := Format(PostedSaleInvoice."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                    end;
                end;

                if TransportMethod.Get("Transport Method") then;
                Clear(ShippingAgentName);
                if ShippingAgent.Get(Header."Shipping Agent Code") then
                    ShippingAgentName := ShippingAgent.Name;

                //TDS Amount
                TDSEntry.Reset();
                TDSEntry.SetRange("Document No.", header."No.");
                if TDSEntry.FindFirst() then begin
                    TCSAmount := TDSEntry."TDS Amount"
                end
                else
                    TCSAmount := 0;

                //TBC-934 --->
                Clear(LutValue);
                SalesRecSetup.Get();
                if not LUTNo then
                    LutValue := SalesRecSetup."New LUT No."
                else
                    LutValue := SalesRecSetup."Old LUT No.";
                //TBC-934 <---
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
                    field(CompanyLogo; CompanyLogo)
                    {
                        ApplicationArea = All;
                        Caption = 'Without Company Logo';
                    }
                    field(LUTNo; LUTNo)
                    {
                        ApplicationArea = All;
                        Caption = 'LUT No. (Old)';
                    }
                }
            }
        }

    }
    trigger OnPreReport()

    begin
        CompanyInfo.get();
        if not CompanyLogo then
            CompanyInfo.CalcFields(Picture);
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
        TransportMethod: Record "Transport Method";
        TDSEntry: Record "TDS Entry";
        BilltoCount: Integer;
        ShiptoCount: Integer;
        Check: Report Check;
        SrNo: Integer;
        GSTNo: Text[20];
        PANNo: Text[20];
        PayTermName: Text[100];
        Narration: Text;
        DimensionValueName: Text[50];
        InvoiceDate: Text;
        EngName: Text[100];
        PoDate: Text;
        BalAmount: Decimal;
        RoundOffValue: Decimal;
        NoText: array[2] of Text;
        AmountTotal: Text[250];
        AmountInWords: Text;
        Line_Amount: Decimal;
        TotalDiscAmt: Decimal;
        TaxableAmt: Decimal;
        TotalOutstandingAmt: Decimal;
        VirtualAcNo: Text[50];
        EncodeStr: Text;
        FreightAmt: Decimal;
        PhoneNo: Text[30];
        LRDate: Text;
        BillToCust: Code[20];
        BilltoCustName: Text;
        BilltoAdd: Text;
        BilltoAdd2: Text;
        BilltoCity: Text;
        BilltoPin: Text;
        BilltoGST: Code[20];
        BilltoPAN: Code[20];
        BTCStateName: Text[50];
        BTCStateCode: Code[10];
        ShiptoCode: Code[20];
        ShiptoCustName: Text;
        ShiptoAdd: Text;
        ShiptoAdd2: Text;
        ShiptoCity: Text;
        ShiptoPin: Text;
        ShiptoGST: Code[20];
        ShiptoPAN: Code[20];
        STCStateName: Text[50];
        STCStateCode: Code[10];
        TCSAmount: Decimal;
        CompanyLogo: Boolean;
        ProformaInvLbl: Label 'TAX INVOICE';
        TaxInvoiceOriginalLbl: Label 'ORIGINAL FOR RECIPIENT/DUPLICATE/TRIPLICATE';
        RegdNoLbl: Label 'Regd. No.:';
        GSTINLbl: Label 'GSTIN:';
        BTALbl: Label 'Bill to Address';
        STALbl: Label 'Ship to Address';
        CustomerDetailLbl: Label 'Customers Details';
        OurDetailsLbl: Label 'Our Details';
        StateLbl: Label 'State: ';
        StateCodeLbl: Label 'State Code: ';
        GSTNoLbl: Label 'GST No.: ';
        PANNoLbl: Label 'PAN No.: ';
        PONoLbl: Label 'PO NO.: ';
        PODateLbl: Label 'PO Date: ';
        KindAttLbl: Label 'Kind Attn.: ';
        ContactNoLbl: Label 'Contact No.: ';
        EmailLbl: Label 'Email: ';
        PayTremsLbl: Label 'Payment Terms: ';
        SplTermLbl: Label 'Spl. Terms: ';
        BranchLbl: Label 'Branch: ';
        PINoLbl: Label 'Inv No.: ';
        PIDateLbl: Label 'Inv Date: ';
        AmtRecdLbl: Label 'AMT Recd.: ';
        BalAmtLbl: Label 'Bal. Amt: ';
        EngNameLbl: Label 'Eng. Name: ';
        NarrationLbl: Label 'Narration: ';
        SrNoLbl: Label 'Sr. No.';
        ProductDescLbl: Label 'Product Description';
        CodeLbl: Label 'Code';
        HSNSACLbl: Label 'HSN/SAC';
        QtyLbl: Label 'Qty';
        UnitRateLbl: Label 'Unit Rate';
        AmountLbl: Label 'Amount';
        DiscAmtLbl: Label 'Disc Amt';
        TaxableAmtLbl: Label 'Taxable Amt';
        CGSTLbl: Label 'CGST';
        SGSTLbl: Label 'SGST';
        IGSTLbl: Label 'IGST';
        TotalAmtLbl: Label 'Total Amount';
        FreightAmtLbl: Label 'Freight Amt :';
        PackFwdLbl: Label 'Pack & Fwd :';
        JobWork: Text;
        ChallanNo: Code[20];
        ChallanDate: Text;
        RoundOff: Boolean;
        RoundOffTotalOutstanding: Decimal;
        Re: Report 408;
        SezValue: Text;
        ShippingAgent: Record "Shipping Agent";
        ShippingAgentName: Text;
        Payment_Term_Value: Text;
        LUTNo: Boolean;  //TBC-934
        LutValue: Text; //TBC-934
        SalesRecSetup: Record "Sales & Receivables Setup";
}
