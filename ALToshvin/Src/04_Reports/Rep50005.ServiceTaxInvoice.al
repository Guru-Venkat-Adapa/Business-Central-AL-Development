report 50005 "Service Tax Invoice"
{
    Caption = 'Service Tax Invoices';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Src\Reports\Layouts\ServiceTaxInvoice.rdl';
    dataset
    {
        dataitem(Header; "Sales Invoice Header")
        {
            // DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Posted Sales Invoice';
            /*  <-------------              Company Info               ---------------->*/
            column(CompanyDisplayName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyGSTNo; CompanyInfo."GST Registration No.") { }
            column(BankName; CompanyInfo."Bank Name") { }
            column(BankBranch; CompanyInfo."Bank Branch No.") { }
            column(BankAcNo; CompanyInfo."Bank Account No.") { }
            column(IFSCCode; CompanyInfo."SWIFT Code") { }
            column(CompanyPhNo; CompanyInfo."Phone No.") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(VirtualAcNo; VirtualAcNo) { }
            column(CompanyPANNo; CompanyInfo."P.A.N. No.") { }
            column(Contract_Start_Date; ContractFromDate) { }
            column(Contract_End_Date; ContractToDate) { }
            column(Order_No_; "Order No.") { }
            column(Service_Type_; Service_Type_) { }
            column(No__of_visits; "No. of Visit") { }
            column(Visit_Date; VisitDate) { }
            column(Service_Description; "Service Description") { }
            column(ServiceName; ServiceName) { }
            column(Header_Remark; Narration) { }
            column(QR_Code; "QR Code") { }
            column(SezValue; SezValue) { }

            // <--------------------                       Invoice Detail           --------------------->
            column(Shortcut_Dimension_2_Code; DimensionValueName) { }
            column(SalesInvoiceNo_; "No.") { }
            column(Orderdate; InvoiceDate) { }
            column(EngName; "Executive Master") { }
            column(JobWork; JobWork) { }
            column(Mode_of_Transport; "Mode of Transport") { }
            column(Transport_Method; "Transport Method") { }
            column(AmountInWords; AmountInWords) { }
            column(FreightAmt; FreightAmt) { }
            column(EncodeStr; EncodeStr) { }

            column(LRNo; Header."LR/RR No.") { }
            column(LRDate; LRDate) { }
            //<-------------  Bill to details       ------------->
            column(BTCNo; "Bill-to Customer No.") { }
            column(BTCName; "Bill-to Name") { }
            column(BTCAddress; "Bill-to Address") { }
            column(BTCAddress2; "Bill-to Address 2") { }
            column(BTCCity; "Bill-to City") { }
            column(BTCPostCode; "Bill-to Post Code") { }
            column(BTCStateName; BTCStateName) { }
            column(BTCStateCode; BTCStateCode) { }
            column(Bill_to_Contact_No_; "Sell-to Phone No.") { }
            column(Bill_to_Contact_Email; "Sell-to E-Mail") { }
            column(Bill_to_Contact; "Sell-to Contact") { }
            column(GSTNo; GSTNo) { }
            column(ShipToGSTNo; ShipToGSTNo) { }  //TBC-1065
            column(PANNo; PANNo) { }
            //  <----------------     Ship to Address Details      --------->
            column(STCCode; "Ship-to Code") { }
            column(STCName; "Ship-to Name") { }
            column(STCAddress; "Ship-to Address") { }
            column(STCAddress2; "Ship-to Address 2") { }
            column(STCCity; "Ship-to City") { }
            column(STCPostCode; "Ship-to Post Code") { }
            column(STCStateName; STCStateName) { }
            column(STCStateCode; STCStateCode) { }
            /*  <--------------              Customer Details         ----------------------------*/
            column(Sell_to_Phone_No_; PhoneNo) { }
            column(Sell_to_E_Mail; "Sell-to E-Mail") { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(Payment_Terms_Code; PayTermName) { }
            column(Narration; Narration) { }
            column(PoNo; "External Document No.") { }
            column(PoDate; PoDate) { }
            column(IRN_Hash; "IRN Hash") { }
            column(Prepayment_Amount; "Prepayment Amount") { }
            column(TDSAmt; TDSAmt) { }
            column(RoundOff; RoundOff) { }
            column(RoundOffTotalOutstanding; RoundOffTotalOutstanding) { }
            column(CustState; CustState) { }
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
                column(Loc_Name; Code) { }
                column(Loc_Add; Address) { }
                column(Loc_Add2; "Address 2") { }
                column(Loc_City; City) { }
                column(Loc_Post_Code; "Post Code") { }
                column(GST_Registration_No_; "GST Registration No.") { }
            }
            // dataitem("Header_Sales Comment Line"; "Sales Comment Line")
            // {
            //     DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.");
            //     DataItemLink = "No." = field("No.");
            //     DataItemLinkReference = Header;

            // }
            dataitem(Line; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = const(Item));
                column(ItemNo; "No.") { }
                column(ItemDescription; Description) { }
                column(Description_2; "Description 2") { }
                column(ItemQuantity; Quantity) { }
                column(ItemUnit_Price; "Unit Price") { }
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
                column(SrNo; SrNo) { }
                column(Inst_SR_No_; "Item Instrument No.") { }
                column(Remark; Comment) { }


                trigger OnAfterGetRecord()
                begin
                    Clear(TotalDiscAmt);
                    Clear(TaxableAmt);
                    Clear(TotalOutstandingAmt);
                    TotalDiscAmt := "Line Discount Amount" + "Inv. Discount Amount";
                    TaxableAmt := ("Unit Price" * Quantity) - TotalDiscAmt;
                    TotalOutstandingAmt := TaxableAmt + "CGST Amount" + "SGST Amount" + "IGST Amount";
                    SrNo += 1;
                    Clear(RoundOffTotalOutstanding);
                    if RoundOff then
                        RoundOffTotalOutstanding := Round(TotalOutstandingAmt, 1, '=')
                    else
                        RoundOffTotalOutstanding := TotalOutstandingAmt;

                    //TBC-1022 ---->
                    Clear(Comment);
                    if Line.Remark = '' then begin
                        SalesCommentLine.Reset();
                        SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::"Posted Invoice");
                        SalesCommentLine.SetRange("No.", Line."Document No.");
                        SalesCommentLine.SetRange("Document Line No.", Line."Line No.");
                        if SalesCommentLine.findfirst() then
                            Comment := SalesCommentLine.Comment
                        else
                            Comment := '';
                    end else
                        Comment := Line.Remark;

                    //TBC-1022 <----
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
            begin
                Clear(InvoiceDate);
                Clear(PoDate);
                Clear(ContractFromDate);
                Clear(ContractToDate);
                Clear(LRDate);
                InvoiceDate := Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>');
                PoDate := Format("Customer PO Date", 0, '<Day,2>/<Month,2>/<Year4>');
                ContractFromDate := Format("Contract Start Date", 0, '<Day,2>/<Month,2>/<Year4>');
                ContractToDate := Format("Contract End Date", 0, '<Day,2>/<Month,2>/<Year4>');
                VisitDate := Format("Visit Date", 0, '<Day,2>/<Month,2>/<Year4>');
                LRDate := Format("Header"."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');
                BillToContact.GetOrClear(Header."Bill-to Contact No.");
                Clear(BTCStateName);
                Clear(BTCStateCode);
                if State.Get("Header"."Bill-to County") then begin
                    BTCStateName := State.Description;
                    BTCStateCode := State."State Code (GST Reg. No.)";
                end;
                // State and State Code for Billing Address from state table
                Clear(STCStateName);
                Clear(STCStateCode);
                if State.Get("Header"."Ship-to County") then begin
                    STCStateName := State.Description;
                    STCStateCode := State."State Code (GST Reg. No.)";
                end;

                //TBC-1065 --->
                Clear(ShipToGSTNo);
                if Header."Ship-to Code" <> '' then begin
                    if ShipToAddress.Get(Header."Sell-to Customer No.", Header."Ship-to Code") then begin
                        if ShipToAddress."GST Registration No." <> '' then
                            ShipToGSTNo := ShipToAddress."GST Registration No."
                        else
                            ShipToGSTNo := '';
                    end;
                end else
                    if Customer.Get("Sell-to Customer No.") then begin
                        ShipToGSTNo := Customer."GST Registration No.";
                    end;
                //TBC-1065 <---



                // GST No., PAN No. and virtual Value from Customer table
                Clear(GSTNo);
                Clear(PANNo);
                Clear(VirtualAcNo);
                if Customer.get("Sell-to Customer No.") then begin
                    GSTNo := Customer."GST Registration No.";
                    PANNo := Customer."P.A.N. No.";
                    VirtualAcNo := Customer."Virtual Account";
                    if State.Get(Customer."State Code") then begin
                        CustState := State.Description;
                    end;
                end;
                Clear(PaymentTerm);
                // Payment Term Description from Payment Terms table
                if PaymentTerm.Get("Header"."Payment Terms Code") then
                    PayTermName := PaymentTerm.Description;
                // comments/narration values from Sales Comment Line table
                Clear(Narration);
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
                Clear(DimensionValueName);
                If "Header"."Shortcut Dimension 2 Code" <> '' then begin
                    DimensionVal.SetFilter(Code, "Shortcut Dimension 2 Code");
                    if DimensionVal.FindFirst() then
                        DimensionValueName := DimensionVal.Name;
                end;
                // Employee Name
                Clear(JobWork);
                Clear(EngName);
                if Header."Service Order" then
                    EngName := Header."Executive Master"
                else
                    EngName := '';

                Employee.Reset();
                Employee.SetRange("No.", "Header"."Employee No.");
                if Employee.FindFirst() then begin
                    JobWork := Employee."Job Title";
                end;
                // Getting the total in words of the sales lines from sales lines table
                Clear(BalAmount);
                CLear(FreightAmt);
                Salesline.SetRange("Document No.", "Header"."No.");
                if Salesline.FindSet() then begin
                    repeat
                        // TotalAmt += Salesline."Outstanding Amount";
                        BalAmount += (((Salesline."Unit Price" * Salesline.Quantity) - (Salesline."Line Discount Amount" + Salesline."Inv. Discount Amount")) + Salesline."CGST Amount" + Salesline."SGST Amount" + Salesline."IGST Amount");
                        if Salesline."No." = 'S-FREIGHT' then
                            FreightAmt += Salesline."Line Amount";
                    until Salesline.Next() = 0;
                end;

                //Service Type NAme
                Clear(ServiceName);
                ServiceType.Reset();
                ServiceType.SetRange(Code, Header.Service_Type_);
                if ServiceType.FindFirst() then
                    ServiceName := ServiceType."Service Name";

                BalAmount := ROUND(BalAmount, 0.01);
                // Amount In Words
                Clear(AmountInWords);
                // Round Off Value
                clear(RoundOffValue);
                if RoundOff then
                    RoundOffValue := Round(BalAmount, 1, '=')
                else
                    RoundOffValue := BalAmount;
                AmountInWords := AmountInWordsIndian(BalAmount);
                //Get Mobile No.
                if Contact.Get("Sell-to Contact No.") then
                    PhoneNo := Contact."Mobile Phone No.";
                //QR Code
                Header.CalcFields("QR Code");
                EncodeStr := Format(Header."QR Code");
                BarcodeProvider := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                BarcodeSym := Enum::"Barcode Symbology 2D"::"QR-Code";
                EncodeStr := BarcodeProvider.EncodeFont(EncodeStr, BarcodeSym);
                //TDS Amount
                TDSEntry.Reset();
                TDSEntry.SetRange("Document No.", header."No.");
                if TDSEntry.FindFirst() then begin
                    TDSAmt := TDSEntry."TDS Amount"
                end
                else
                    TDSAmt := 0;

                Clear(Narration);
                SalesCommentLine.Reset();
                SalesCommentLine.SetRange("No.", Header."No.");
                SalesCommentLine.SetRange("Document Line No.", 0);
                if SalesCommentLine.FindSet() then
                    repeat
                        if Narration = '' then
                            Narration := SalesCommentLine.Comment
                        else
                            Narration := Narration + ' ' + SalesCommentLine.Comment;
                    until SalesCommentLine.Next() = 0;
                // Sez Instruction
                Clear(SezValue);
                if Header."GST Customer Type" = Header."GST Customer Type"::"SEZ Unit" then
                    SezValue :=
                        'Supply meant for SEZ unit for authorized operations under Bond or Letter of Undertaking without payment of Integrated Tax '
                        + Header."SEZ Instruction";

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
                    // field(CompanyLogo; CompanyLogo)
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Company Logo';
                    // }
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
        Check: Report Check;
        TDSEntry: Record "TDS Entry";
        SalesCommentLine: Record "Sales Comment Line";
        BTCStateName: Text[50];
        BTCStateCode: Code[10];
        STCStateName: Text[50];
        SrNo: Integer;
        STCStateCode: Code[10];
        BillToContact: Record Contact;
        GSTNo: Text[50];
        PANNo: Text[50];
        PayTermName: Text[100];
        Narration: Text;
        DimensionValueName: Text[50];
        InvoiceDate: Text;
        EngName: Text[50];
        ContractFromDate: Text;
        ContractToDate: Text;
        VisitDate: text;
        PoNo: Code[20];
        PoDate: Text;
        BalAmount: Decimal;
        NoText: array[2] of Text;
        AmountTotal: Text[250];
        AmountInWords: Text;
        TotalDiscAmt: Decimal;
        TaxableAmt: Decimal;
        TotalOutstandingAmt: Decimal;
        VirtualAcNo: Text[50];
        EncodeStr: Text;
        FreightAmt: Decimal;
        PhoneNo: Text;
        LRNo: Code[20];
        LRDate: Text;
        TDSAmt: Decimal;
        CustState: Text;
        CompanyLogo: Boolean;
        SezValue: Text;
        ProformaInvLbl: Label 'TAX INVOICE';
        TaxInvoiceOriginalLbl: Label 'ORIGINAL FOR RECIPIENT/DUPLICATE/TRIPLICATE';
        RegdNoLbl: Label 'Regd. No.:';
        GSTINLbl: Label 'GSTIN:';
        BTALbl: Label 'Bill to Address';
        STALbl: Label 'Ship to Address';
        CustomerDetailLbl: Label 'Our Details';
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
        EngNameLbl: Label 'Engineers Name: ';
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
        RoundOffValue: Decimal;
        RoundOff: Boolean;
        RoundOffTotalOutstanding: Decimal;
        //ServiceType: Record "Service Type";
        ServiceType: Record "ServiceType";
        ServiceName: Text[250];
        LUTNo: Boolean;  //TBC-934
        LutValue: Text; //TBC-934
        SalesRecSetup: Record "Sales & Receivables Setup";
        Comment: Text;
        ShipToGSTNo: Text[50]; //TBC-1065
        ShipToAddress: Record "Ship-to Address";//TBC-1065
}


