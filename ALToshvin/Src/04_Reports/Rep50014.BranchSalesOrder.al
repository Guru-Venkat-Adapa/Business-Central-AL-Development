report 50014 "Branch Sales Order"
{
    ApplicationArea = All;
    Caption = 'Branch Sales Order';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\Reports\Layouts\BranchSalesOrder.rdl';
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = SORTING("No.") WHERE("Document Type" = CONST(Order));
            column(OrderNo; "No.") { }
            column(Order_Posting_Date; "Posting Date") { }
            column(Your_Reference; "Your Reference") { }
            column(External_Document_No_; "External Document No.") { }
            column(Customer_PO_Date; PODate) { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(Payment_Terms_Code; Payment_Term_Value) { }
            column(Mode_of_Transport; "Mode of Transport") { }
            column(Payment_Terms_Description; Payment_Term_Value) { }
            column(Prepayment_Amount; "Prepayment Amount") { }
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
            column(Comments; Comments) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyPostCode; companyinfo."Post Code") { }
            column(CompanyGSTNo; CompanyInfo."GST Registration No.") { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(CompanyBankName; CompanyInfo."Bank Name") { }
            column(CompanyBankAccountNo; CompanyInfo."Bank Account No.") { }
            column(CompanyBankBranchNo; CompanyInfo."Bank Branch No.") { }
            column(CompanySWIFTCOde; CompanyInfo."SWIFT Code") { }
            column(ExecutionDate; ExecutionDate) { }
            column(ExecutionTime; ExecutionTime) { }
            column(Executive_Master; "Executive Master") { }
            column(PhoneNo; PhoneNo) { }
            column(Email; Email) { }
            column(PrepaymentAmt; PrepaymentAmt) { }
            column(BalanceAmt; BalanceAmt) { }
            column(CRM_Quote_No_; "CRM Quote No.") { }
            column(Location; Loc.Name) { }
            column(DeemedExportValue; DeemedExportValue) { }
            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Line No.") WHERE("Document Type" = CONST(Order));

                column(SrNo; SrNo) { }
                column(Item_Description; Description) { }
                column(No_; "No.") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Quantity; Quantity) { }
                column(Unit_Price; "Unit Price") { }
                column(Amount; Amount) { }
                column(Line_Discount_Percent; "Line Discount %") { }
                column(Discount_Amount; "Discount Amount") { }
                column(CGST_Percentage; "CGST Percentage") { }
                column(CGST_Amount; "CGST Amount") { }
                column(SGST_Percentage; "SGST Percentage") { }
                column(SGST_Amount; "SGST Amount") { }
                column(IGST_Percentage; "IGST Percentage") { }
                column(IGST_Amount; "IGST Amount") { }
                column(TaxableAmt; TaxableAmt) { }
                column(TotalDiscAmt; TotalDiscAmt) { }
                column(TotalOutstandingAmt; TotalOutstandingAmt) { }
                column(BalAmount; TotalInclGST) { }
                column(AmountInWords; AmountInWords) { }
                column(Line_Amount; "Line Amount") { }
                column(RoundOff; RoundOff) { }
                column(RoundOffValue; RoundOffValue) { }
                column(RounndOffRemaining; RounndOffRemaining) { }
                trigger OnAfterGetRecord()
                begin
                    Clear(TotalInclGST);
                    Clear(TotalDiscAmt);
                    Clear(TaxableAmt);
                    Clear(TotalOutstandingAmt);
                    SrNo += 1;
                    TotalDiscAmt := "Line Discount Amount" + "Inv. Discount Amount";
                    TaxableAmt := ("Unit Price" * Quantity) - TotalDiscAmt;
                    TotalOutstandingAmt := TaxableAmt + "CGST Amount" + "SGST Amount" + "IGST Amount";

                    Line.Reset();

                    // Amount In Words

                end;
            }
            trigger OnAfterGetRecord()
            var
                PostedSalesHeader: Record "Sales Invoice Header";
                PostedSalesLine: Record "Sales Invoice Line";
                PaymentTerm: Record "Payment Terms";
                Customer: Record Customer;
                State: Record State;
                ShiptoAddress: Record "Ship-to Address";
            begin

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
                Clear(PhoneNo);
                Clear(Email);
                Clear(Comments);
                Clear(ExecutionDate);
                Clear(ExecutionTime);
                Clear(AmountInWords);
                Clear(GSTAmount);
                Clear(BalAmount);
                Clear(PrepaymentAmt);
                Clear(BalanceAmt);
                Clear(PayTermName);
                PODate := Format("Customer PO Date", 0, '<Day,2>/<Month,2>/<Year4>');
                if SalesHeader."Custom Ship-to" = SalesHeader."Custom Ship-to"::"Default (Sell-to Address)" then begin
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
                else if SalesHeader."Custom Ship-to" = SalesHeader."Custom Ship-to"::"Alternate Shipping Address" then begin
                    if SalesHeader."Ship-to Code" <> '' then
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
                else if SalesHeader."Custom Ship-to" = SalesHeader."Custom Ship-to"::"Custom Address" then begin
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
                if Customer.get(SalesHeader."Sell-to Customer No.") then begin
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
                    if SalesHeader."Sell-to Phone No." = '' then
                        PhoneNo := Customer."Phone No." else
                        PhoneNo := SalesHeader."Sell-to Phone No.";
                    if SalesHeader."Sell-to E-Mail" = '' then
                        Email := Customer."E-Mail" else
                        Email := SalesHeader."Sell-to E-Mail";
                end;
                SellToContact.GetOrClear(SalesHeader."Sell-to Contact No.");
                if PaymentTerms.Get(SalesHeader."Payment Terms Code") then;
                SalesCommentLine.Reset();
                SalesCommentLine.SetRange("Document Type", SalesHeader."Document Type"::Order);
                SalesCommentLine.SetRange("No.", SalesHeader."No.");
                if SalesCommentLine.FindFirst() then
                    repeat
                        if Comments = '' then
                            Comments += SalesCommentLine.Comment
                        else
                            Comments += Comments + ' ' + SalesCommentLine.Comment;
                    until SalesCommentLine.Next() = 0;
                ExecutionDate := Today;
                ExecutionTime := Time;
                SalesHeader.CalcFields(Amount);
                SalesHeader.CalcFields("GST Amount");
                AmountInWords := AmountInWordsIndian(SalesHeader.Amount + SalesHeader."GST Amount");

                SalesHeader.CalcFields("Sales Order Amount");
                GSTAmount := SalesHeader."GST Amount";
                BalAmount := SalesHeader."Sales Order Amount" + GSTAmount;
                PostedSalesHeader.Reset();
                PostedSalesHeader.SetRange("Prepayment Order No.", SalesHeader."No.");
                PostedSalesHeader.SetRange(Closed, true);
                if PostedSalesHeader.FindFirst() then begin
                    PostedSalesLine.Reset();
                    PostedSalesLine.SetRange("Document No.", PostedSalesHeader."No.");
                    if PostedSalesLine.FindFirst() then
                        PrepaymentAmt := PostedSalesLine."Line Amount";
                end;
                BalanceAmt := BalAmount - PrepaymentAmt;
                BalanceAmt := ROUND(BalanceAmt, 0.01);
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
                Clear(Payment_Term_Value);
                if SalesHeader."Sales Order Type" = 'INSTRUMENT' then
                    Payment_Term_Value := SalesHeader."Payment Term Details"
                else begin
                    if "Payment Terms Code" <> '' then
                        if PaymentTerm.Get(SalesHeader."Payment Terms Code") then
                            Payment_Term_Value := PaymentTerm.Description;
                end;
                if SalesHeader."Location Code" <> '' then
                    Loc.Get(SalesHeader."Location Code");

                // Deemed Export value  start of ticket no.- 918 on 30/03/26
                Clear(DeemedExportValue);
                if SalesHeader."Deemed Export" then
                    DeemedExportValue := 'This Sale is under “Deemed Export “against Form A ' + SalesHeader."Deemed Export Instruction";
                // end of ticket no.- 918
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
        SalesCommentLine: Record "Sales Comment Line";
        Loc: Record Location;
        Comments: Text;
        AmountInWords: Text;
        TotalDiscAmt: Decimal;
        TaxableAmt: Decimal;
        TotalOutstandingAmt: Decimal;
        TotalInclGST: Decimal;
        ExecutionDate: Date;
        ExecutionTime: time;
        SrNo: Integer;
        PrepaymentAmt: Decimal;
        BalAmount: Decimal;
        BalanceAmt: Decimal;
        GSTAmount: Decimal;
        PODate: Text;
        PayTermName: Text[100];
        Line: Record "Sales Line";
        PhoneNo: Text[30];
        Email: Text[80];
        Location: Text;
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
}
