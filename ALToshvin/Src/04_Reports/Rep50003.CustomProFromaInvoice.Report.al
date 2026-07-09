report 50003 "Custom Pro Froma Invoice"
{
    ApplicationArea = All;
    Caption = 'Custom Pro Froma Invoice';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\04_Reports\Layouts\CustomProFormaInvoice.rdlc';
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.";
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyGSTNo; CompanyInfo."GST Registration No.") { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyPostCode; companyinfo."Post Code") { }
            column(BankName; CompanyInfo."Bank Name") { }
            column(BankBranch; CompanyInfo."Bank Branch No.") { }
            column(BankAcNo; CompanyInfo."Bank Account No.") { }
            column(IFSCCode; CompanyInfo."SWIFT Code") { }
            column(VirtualAcNo; VirtualAcNo) { }
            column(ProFormaHeadingLbl; ProFormaHeadingLbl) { }

            column(SalesOrderNo; "No.") { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(PoNo; "External Document No.") { }
            column(PoDate; PoDate) { }
            column(Narration; Narration) { }
            column(PrepaymentAmt; "Prepayment Amount") { }
            column(BalanceAmt; BalanceAmt) { }
            // column(Payment_Term_Details; "Payment Term Details") { }
            column(Payment_Term_Details; Payment_Term_Value) { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            //<-------------  Bill to details       ------------->
            column(BTCNo; BillToCust) { }
            column(BTCName; BilltoCustName) { }
            column(BTCAddress; BilltoAdd) { }
            column(BTCAddress2; BilltoAdd2) { }
            column(BTCCity; BilltoCity) { }
            column(BTCPostCode; BilltoPin) { }
            column(BilltoGST; BilltoGST) { }
            column(BilltoPAN; BilltoPAN) { }
            column(BTCStateName; BTCStateName) { }
            column(BTCStateCode; BTCStateCode) { }
            //  <----------------     Ship to details      --------->
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
            //------------------
            column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
            column(Sell_to_E_Mail; "Sell-to E-Mail") { }
            column(Shortcut_Dimension_2_Code; DimensionValueName) { }
            column(Order_Date; Orderdate) { }
            column(Executive_Master; "Executive Master") { }
            column(AmountInWords; AmountInWords) { }
            column(RoundOff; RoundOff) { }
            column(RoundOffValue; RoundOffValue) { }
            column(RounndOffRemaining; RounndOffRemaining) { }
            column(FreightAmt; FreightAmt) { }
            column(Prepayment_Amount; "Prepayment Amount") { }
            column(DeemedExportValue; DeemedExportValue) { }
            // <-------------    Lables Captions     ------------->
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
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemLinkReference = "Sales Header";
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where(Type = const(Item), "Qty. to Ship" = FILTER(<> 0));
                column(ItemNo; "No.") { }
                column(ItemDescription; Description) { }
                column(Description_2; "Description 2") { }
                column(ItemQuantity; "Qty. to Ship") { }
                column(ItemUnit_Price; "Unit Price") { }
                column(ItemLine_Amount; LineAmount) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(IGST_Percentage; "IGST Percentage") { }
                column(IGST_Amount; IGSTAmount) { }
                column(SGST_Percentage; "SGST Percentage") { }
                column(SGST_Amount; SGSTAmount) { }
                column(CGST_Percentage; "CGST Percentage") { }
                column(CGST_Amount; CGSTAmount) { }
                column(TotalDiscAmt; TotalDiscAmt) { }
                column(TaxableAmt; TaxableAmt) { }
                column(TotalOutstandingAmt; TotalOutstandingAmt) { }
                trigger OnAfterGetRecord()
                var
                    LineDiscAmount: Decimal;
                    invDiscAmount: Decimal;
                begin
                    if Quantity = 0 then begin
                        Message('Please update quantity on sales line');
                        exit;
                    end else begin
                        LineAmount := "Qty. to Ship" * "Unit Price";
                        LineDiscAmount := ("Line Discount Amount" / Quantity) * "Qty. to Ship";
                        invDiscAmount := ("Inv. Discount Amount" / Quantity) * "Qty. to Ship";
                        TotalDiscAmt := LineDiscAmount + invDiscAmount;
                        TaxableAmt := LineAmount - TotalDiscAmt;
                        IGSTAmount := ("IGST Amount" / Quantity) * "Qty. to Ship";
                        SGSTAmount := ("SGST Amount" / Quantity) * "Qty. to Ship";
                        CGSTAmount := ("CGST Amount" / Quantity) * "Qty. to Ship";
                        TotalOutstandingAmt := (TaxableAmt + IGSTAmount + SGSTAmount + CGSTAmount);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if not IncludeAllLines then begin
                        SetFilter("Unit Price", '<>%1', 0);
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            var
                SalesPerson: Record "Salesperson/Purchaser";
                Salesline: Record "Sales Line";
                Customer: Record Customer;
                DimensionVal: Record "Dimension Value";
                PaymentTerm: Record "Payment Terms";
                SalesCommentLine: Record "Sales Comment Line";
                PostedSalesHeader: Record "Sales Invoice Header";
                PostedSalesLine: Record "Sales Invoice Line";
                State: Record State;
                ShiptoAddress: Record "Ship-to Address";
                SoLineDiscAmount: Decimal;
                SOinvDiscAmount: Decimal;
                SOTotalDiscAmt: Decimal;
                SOTaxableAmt: Decimal;
                SOIGSTAmount: Decimal;
                SOSGSTAmount: Decimal;
                SOCGSTAmount: Decimal;
            begin
                Clear(Orderdate);
                Clear(PoDate);
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
                Clear(DimensionValueName);
                Clear(SoLineDiscAmount);
                Clear(SOinvDiscAmount);
                Clear(SOTotalDiscAmt);
                Clear(SOTaxableAmt);
                Clear(SOIGSTAmount);
                Clear(SOSGSTAmount);
                Clear(SOCGSTAmount);
                Clear(SOTotalOutstandingAmt);
                Clear(BalAmount);
                Clear(AmountInWords);
                Clear(FreightAmt);
                Clear(Narration);
                Clear(Payment_Term_Value);
                if "Sales Header"."Sales Order Type" = 'INSTRUMENT' then
                    Payment_Term_Value := "Sales Header"."Payment Term Details"
                else begin
                    if "Payment Terms Code" <> '' then
                        if PaymentTerm.Get("Sales Header"."Payment Terms Code") then
                            Payment_Term_Value := PaymentTerm.Description;
                end;
                Orderdate := Format("Order Date", 0, '<Day,2>/<Month,2>/<Year4>');
                PoDate := Format("Customer PO Date", 0, '<Day,2>/<Month,2>/<Year4>');
                // Ship-to Address
                if "Sales Header"."Custom Ship-to" = "Sales Header"."Custom Ship-to"::"Default (Sell-to Address)" then begin
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
                else if "Sales Header"."Custom Ship-to" = "Sales Header"."Custom Ship-to"::"Alternate Shipping Address" then begin
                    if "Sales Header"."Ship-to Code" <> '' then
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
                else if "Sales Header"."Custom Ship-to" = "Sales Header"."Custom Ship-to"::"Custom Address" then begin
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
                // GST No., PAN No. and virtual Value from Customer table
                if Customer.get("Sell-to Customer No.") then begin
                    VirtualAcNo := Customer."Virtual Account";
                    // Bill-to Address
                    BillToCust := Customer."No.";
                    BilltoCustName := Customer.Name;
                    BilltoAdd := Customer.Address;
                    BilltoAdd2 := Customer."Address 2";
                    BilltoCity := Customer.City;
                    BilltoPin := Customer."Post Code";
                    BilltoGST := Customer."GST Registration No.";
                    BilltoPAN := Customer."P.A.N. No.";
                    //getting state and state code of bill-to address
                    State.Reset();
                    if State.Get(Customer."State Code") then begin
                        BTCStateName := State.Description;
                        BTCStateCode := State."State Code (GST Reg. No.)";
                    end;
                end;
                // Dimension Description from Dimension table
                If "Sales Header"."Shortcut Dimension 2 Code" <> '' then begin
                    DimensionVal.SetFilter(Code, "Shortcut Dimension 2 Code");
                    if DimensionVal.FindFirst() then
                        DimensionValueName := DimensionVal.Name;
                end;
                // Getting the total in words of the sales lines from sales lines table
                Salesline.SetRange("Document Type", "Sales Header"."Document Type"::Order);
                Salesline.SetRange("Document No.", "Sales Header"."No.");
                if Salesline.FindSet() then begin
                    repeat
                        if Salesline.Quantity = 0 then begin
                            Message('Please update quantity on sales line');
                            exit;
                        end else begin
                            SoLineDiscAmount := (Salesline."Line Discount Amount" / Salesline.Quantity) * Salesline."Qty. to Ship";
                            SOinvDiscAmount := (Salesline."Inv. Discount Amount" / Salesline.Quantity) * Salesline."Qty. to Ship";
                            SOTotalDiscAmt := SoLineDiscAmount + SOinvDiscAmount;
                            SOTaxableAmt := (Salesline."Qty. to Ship" * Salesline."Unit Price") - SOTotalDiscAmt;
                            SOIGSTAmount := (Salesline."IGST Amount" / Salesline.Quantity) * Salesline."Qty. to Ship";
                            SOSGSTAmount := (Salesline."SGST Amount" / Salesline.Quantity) * Salesline."Qty. to Ship";
                            SOCGSTAmount := (Salesline."CGST Amount" / Salesline.Quantity) * Salesline."Qty. to Ship";
                            SOTotalOutstandingAmt := (SOTaxableAmt + SOCGSTAmount + SOSGSTAmount + SOIGSTAmount);

                        end;
                        BalAmount += SOTotalOutstandingAmt;
                        // AmountInWords := AmountInWordsIndian(BalAmount);
                        if Salesline."No." = 'S-FREIGHT' then
                            FreightAmt += Salesline."Line Amount";
                    until Salesline.Next() = 0;
                    BalAmount := ROUND(BalAmount, 0.01);
                    // Round Off Value
                    clear(RoundOffValue);
                    Clear(RounndOffRemaining);
                    if RoundOff then begin
                        RoundOffValue := Round(BalAmount, 1, '=');
                        RounndOffRemaining := RoundOffValue - BalAmount;
                        RounndOffRemaining := ROUND(RounndOffRemaining, 0.01);
                    end
                    else
                        RoundOffValue := BalAmount;
                    RoundOffValue := ROUND(RoundOffValue, 0.01);
                    AmountInWords := AmountInWordsIndian(RoundOffValue);
                end;
                // comments/narration values from Sales Comment Line table
                SalesCommentLine.SetRange("Document Type", "Sales Header"."Document Type"::Order);
                SalesCommentLine.SetRange("No.", "Sales Header"."No.");
                SalesCommentLine.SetRange("Document Line No.", 0);
                if SalesCommentLine.FindSet() then
                    repeat
                        if Narration = '' then
                            Narration := SalesCommentLine.Comment
                        else
                            Narration := Narration + ', ' + SalesCommentLine.Comment;
                    until SalesCommentLine.Next() = 0;
                // Deemed Export value  start of ticket no.- 918 on 30/03/26
                Clear(DeemedExportValue);
                if "Sales Header"."Deemed Export" then
                    DeemedExportValue := 'This Sale is under “Deemed Export “against Form A ' + "Sales Header"."Deemed Export Instruction"
                else
                    DeemedExportValue := 'THIS IS COMPUTER GENERATED INVOICE HENCE, NO SIGNATURE REQUIRED.';
                // end of ticket no.- 918

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
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(IncludeAllLines; IncludeAllLines)
                    {
                        ApplicationArea = All;
                        Caption = 'Include All Sale Lines';
                        ToolTip = 'Specifies to show all the sales lines of sales order.';
                    }
                    field(RoundOff; RoundOff)
                    {
                        ApplicationArea = All;
                        Caption = 'Round Off';

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
        LineAmount: Decimal;
        NoText: array[2] of Text;
        AmountTotal: Decimal;
        AmountInWords: Text;
        VirtualAcNo: Text[50];
        DimensionValueName: Text[50];
        PoDate: Text;
        Orderdate: Text;
        Narration: Text;
        BalanceAmt: Decimal;
        TotalDiscAmt: Decimal;
        TaxableAmt: Decimal;
        TotalOutstandingAmt: Decimal;
        BalAmount: Decimal;
        FreightAmt: Decimal;
        IncludeAllLines: Boolean;
        SOTotalOutstandingAmt: Decimal;
        CGSTAmount: Decimal;
        IGSTAmount: Decimal;
        SGSTAmount: Decimal;
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
        RoundOff: Boolean;
        RoundOffValue: Decimal;
        RounndOffRemaining: Decimal;
        Payment_Term_Value: Text;
        DeemedExportValue: Text;
        ProFormaHeadingLbl: Label 'PROFORMA INVOICE';
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
        PayTremsLbl: Label 'Pay. Terms: ';
        BranchLbl: Label 'Branch: ';
        PINoLbl: Label 'PI NO.: ';
        PIDateLbl: Label 'PI Date: ';
        AmtRecdLbl: Label 'Adv. Amt.: ';
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
        LUTNo: Boolean;  //TBC-934
        LutValue: Text; //TBC-934
        SalesRecSetup: Record "Sales & Receivables Setup";
}
