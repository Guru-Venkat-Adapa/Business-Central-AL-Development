report 50017 "Service Sales Order"
{
    ApplicationArea = All;
    Caption = 'Service Sales Order';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\04_Reports\Layouts\ServiceSalesOrder.rdlc';
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = SORTING("No.") WHERE("Document Type" = CONST(Order));
            column(SO_No; "No.") { }
            column(Posting_Date; PostingDate) { }
            column(Region; DimValue.Name) { }
            column(Service_Type; "Service_Type_") { }
            column(Engineer; "Executive Master") { }
            column(PO_No_; "External Document No.") { }
            column(Customer_PO_Date; PODate) { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(Sell_to_Contact_No_; "Sell-to Phone No.") { }
            column(SellToEmail; "Sell-to E-Mail") { }
            column(PayTermCode; PTC.Description) { }
            column(BTCNo; "Bill-to Customer No.") { }
            column(BTCName; "Bill-to Name") { }
            column(BTCAddress; "Bill-to Address") { }
            column(BTCAddress2; "Bill-to Address 2") { }
            column(BTCCity; "Bill-to City") { }
            column(BTCPostCode; "Bill-to Post Code") { }
            column(BilltoGSTNo; Cust."GST Registration No.") { }
            column(Bill_To_State_Name; BTCStateName) { }
            column(Bill_To_State_Code; BTCStateCode) { }
            column(Ship_to_Code; ShiptoCode) { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(Ship_to_GST_Reg__No_; "Ship-to GST Reg. No.") { }
            column(Ship_To_State_Name; STCStateName) { }
            column(Ship_To_State_Code; STCStateCode) { }
            column(Service_Description; "Service Description") { }
            column(ExecutionDate; ExecutionDate) { }
            column(ExecutionTime; ExecutionTime) { }
            column(AmountInWords; AmountInWords) { }
            column(Prepayment_Amount; "Prepayment Amount") { }
            column(Contract_Start_Date; Contract_Start_Date) { }
            column(Contract_End_Date; Contract_End_Date) { }
            column(No__of_Visit; "No. of Visit") { }
            column(Visit_Date; Visit_Date) { }
            column(PrepaymentAmt; PrepaymentAmt) { }
            column(RoundOff; RoundOff) { }
            column(RoundOffValue; RoundOffValue) { }
            column(RounndOffRemaining; RounndOffRemaining) { }
            //Lables
            column(RegionLbl; RegionLbl) { }
            column(DetailsLbl; DetailsLbl) { }
            column(SOFNoLbl; SOFNoLbl) { }
            column(SOFDateLbl; SOFDateLbl) { }
            column(ServiceTypeLbl; ServiceTypeLbl) { }
            column(EngineerLbl; EngineerLbl) { }
            column(CustDetailsLbl; CustDetailsLbl) { }
            column(PONoLbl; PONoLbl) { }
            column(PODateLbl; PODateLbl) { }
            column(KindAttnLbl; KindAttnLbl) { }
            column(ContactNoLbl; ContactNoLbl) { }
            column(EmailLbl; EmailLbl) { }
            column(PaymentTermsLbl; PaymentTermsLbl) { }
            column(BillToAddCapLbl; BillToAddCapLbl) { }
            column(ShipToAddCaplbl; ShipToAddCaplbl) { }
            column(GSTINNoLbl; GSTINNoLbl) { }
            column(StateLbl; StateLbl) { }
            column(StateCodeLbl; StateCodeLbl) { }
            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Line No.") WHERE("Document Type" = CONST(Order));
                column(Item_Description; Description) { }
                column(No_; "No.") { }
                column(Quantity; Quantity) { }
                column(CGST_Amount; "CGST Amount") { }
                column(SGST_Amount; "SGST Amount") { }
                column(IGST_Amount; "IGST Amount") { }
                column(Line_Amount; "Line Amount") { }
                column(Inst_SR_No_; "Item Instrument No.") { }
            }
            trigger OnAfterGetRecord()
            var
                SLine: Record "Sales Line";
                PostedSalesHeader: Record "Sales Invoice Header";
                PostedSalesLine: Record "Sales Invoice Line";
                State: Record State;
            begin
                Clear(ExecutionDate);
                Clear(ExecutionTime);
                Clear(PostingDate);
                Clear(PODate);
                Clear(Contract_Start_Date);
                Clear(Contract_End_Date);
                Clear(Visit_Date);
                ExecutionDate := Format(Today, 0, '<Day,2>/<Month,2>/<Year4>');
                ExecutionTime := Time;
                PostingDate := Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                PODate := Format("Customer PO Date", 0, '<Day,2>/<Month,2>/<Year4>');
                Contract_Start_Date := Format("Contract Start Date", 0, '<Day,2>/<Month,2>/<Year4>');
                Contract_End_Date := Format("Contract End Date", 0, '<Day,2>/<Month,2>/<Year4>');
                Visit_Date := Format("Visit Date", 0, '<Day,2>/<Month,2>/<Year4>');
                if "Shortcut Dimension 2 Code" <> '' then
                    if DimValue.Get('REGION', "Shortcut Dimension 2 Code") then;
                if "Payment Terms Code" <> '' then
                    if PTC.Get(SalesHeader."Payment Terms Code") then;
                if Cust.Get(SalesHeader."Bill-to Customer No.") then;
                // State and State Code for Billing Address from state table
                if State.Get(SalesHeader."Bill-to County") then begin
                    BTCStateName := State.Description;
                    BTCStateCode := State."State Code (GST Reg. No.)";
                end;
                // State and State Code for Shipping Address from state table
                if State.Get(SalesHeader."Ship-to County") then begin
                    STCStateName := State.Description;
                    STCStateCode := State."State Code (GST Reg. No.)";
                end;
                SLine.SetRange("Document Type", SalesHeader."Document Type"::Order);
                SLine.SetRange("Document No.", SalesHeader."No.");
                if SLine.FindSet() then begin
                    repeat
                        if SLine.Quantity <> 0 then
                            BalAmount += SLine."Line Amount" + SLine."IGST Amount" + SLine."SGST Amount" + SLine."CGST Amount";
                    until SLine.Next() = 0;
                    // AmountInWords := AmountInWordsIndian(BalAmount);
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
                    // prepayment Values
                    Clear(PrepaymentAmt);
                    PostedSalesHeader.Reset();
                    PostedSalesHeader.SetRange("Prepayment Order No.", SalesHeader."No.");
                    PostedSalesHeader.SetRange(Closed, true);
                    if PostedSalesHeader.FindFirst() then begin
                        PostedSalesLine.Reset();
                        PostedSalesLine.SetRange("Document No.", PostedSalesHeader."No.");
                        if PostedSalesLine.FindFirst() then
                            PrepaymentAmt := PostedSalesLine."Line Amount";
                    end;
                end;
                //TBC-1029 --->
                Clear(ShiptoCode);
                if "SalesHeader"."Custom Ship-to" = "SalesHeader"."Custom Ship-to"::"Default (Sell-to Address)" then begin
                    if Customer.get("Sell-to Customer No.") then
                        ShiptoCode := Customer."No.";
                end
                else if "SalesHeader"."Custom Ship-to" = "SalesHeader"."Custom Ship-to"::"Alternate Shipping Address" then begin
                    if "SalesHeader"."Ship-to Code" <> '' then
                        if ShiptoAddress.Get("Sell-to Customer No.", "Ship-to Code") then
                            ShiptoCode := ShiptoAddress.Code;
                end
                else if "SalesHeader"."Custom Ship-to" = "SalesHeader"."Custom Ship-to"::"Custom Address" then
                    ShiptoCode := "Ship-to Code";
                //TBC-1029 <---
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
        Cust: Record Customer;
        // BillToState: Record State;
        // ShipToState: Record State;
        PTC: Record "Payment Terms";
        DimValue: Record "Dimension Value";
        PostingDate: Text;
        PODate: Text;
        ExecutionDate: Text;
        ExecutionTime: time;
        BalAmount: Decimal;
        AmountInWords: Text;
        BilltoGSTNo: Code[20];
        Contract_Start_Date: Text;
        Contract_End_Date: Text;
        //TBC-1029 --->
        ShiptoAddress: Record "Ship-to Address";
        ShiptoCode: Code[20];
        Customer: Record Customer;
        //TBC-1029 <---
        Visit_Date: Text;
        PrepaymentAmt: Decimal;
        BTCStateName: Text[50];
        BTCStateCode: Code[10];
        STCStateName: Text[50];
        STCStateCode: Code[10];
        RoundOff: Boolean;
        RoundOffValue: Decimal;
        RounndOffRemaining: Decimal;
        RegionLbl: Label 'Region :';
        DetailsLbl: Label 'Details';
        CustDetailsLbl: Label 'Customer Details';
        SOFNoLbl: Label 'SOF No.:';
        SOFDateLbl: Label 'SOF Date:';
        ServiceTypeLbl: Label 'Service Type:';
        EngineerLbl: Label 'Engineer:';
        PONoLbl: Label 'PO No.:';
        PODateLbl: Label 'PO Date:';
        KindAttnLbl: Label 'kind Attn.:';
        ContactNoLbl: Label 'Contact No.:';
        EmailLbl: Label 'Email:';
        PaymentTermsLbl: Label 'Payment Terms: ';
        BillToAddCapLbl: Label 'Bill to Address';
        ShipToAddCaplbl: Label 'Ship to Address';
        GSTINNoLbl: Label 'GSTIN No.:';
        StateLbl: Label 'State:';
        StateCodeLbl: Label 'State Code:';
}
