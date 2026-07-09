report 50015 "Service Proforma Invoice"
{
    ApplicationArea = All;
    Caption = 'Service Proforma Invoice';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\04_Reports\Layouts\ServiceSoProformaInvoice.rdlc';
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.";
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyPostCode; companyinfo."Post Code") { }
            column(CompanyPhNo; CompanyInfo."Phone No.") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(CompanyGSTNo; CompanyInfo."GST Registration No.") { }
            column(CompanyPAN; CompanyInfo."P.A.N. No.") { }
            column(CompanyRegdNo; CompanyInfo."Registration No.") { }

            column(CompanyBankName; CompanyInfo."Bank Name") { }
            column(CompanyBankAccountNo; CompanyInfo."Bank Account No.") { }
            column(CompanyBankBranchNo; CompanyInfo."Bank Branch No.") { }
            column(CompanySWIFTCOde; CompanyInfo."SWIFT Code") { }
            column(VirtualAcNo; VirtualAcNo) { }

            column(InvoiceNo; "No.") { }
            column(InvoiceDate; InvoiceDate) { }
            column(Service_Type; ServiceType."Service Name") { }
            column(Region; DimValue.Name) { }
            column(Engineer; "Executive Master") { }
            column(PONo; "External Document No.") { }
            column(PODate; PODate) { }
            column(Contract_Start_Date; Contract_Start_Date) { }
            column(Contract_End_Date; Contract_End_Date) { }
            column(No__of_Visit; "No. of Visit") { }
            column(Visit_Date; Visit_Date) { }
            column(PayTermCode; PTC.Description) { }
            column(BTCNo; BillToCust) { }
            column(BTCName; BilltoCustName) { }
            column(BTCAddress; BilltoAdd) { }
            column(BTCAddress2; BilltoAdd2) { }
            column(BTCCity; BilltoCity) { }
            column(BTCPostCode; BilltoPin) { }
            column(BilltoGSTNo; BilltoGST) { }
            column(Bill_To_State_Name; BTCStateName) { }
            column(Bill_To_State_Code; BTCStateCode) { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(Sell_to_Contact_No_; "Sell-to Phone No.") { }
            //--------------------- Ship-to address
            column(Ship_to_Code; ShiptoCode) { }
            column(Ship_to_Name; ShiptoCustName) { }
            column(Ship_to_Address; ShiptoAdd) { }
            column(Ship_to_Address_2; ShiptoAdd2) { }
            column(Ship_to_City; ShiptoCity) { }
            column(Ship_to_Post_Code; ShiptoPin) { }
            column(Ship_to_GST_Reg__No_; ShiptoGST) { }
            column(Ship_To_State_Name; STCStateName) { }
            column(Ship_To_State_Code; STCStateCode) { }
            column(Service_Description; "Service Description") { }
            column(ExecutionDate; ExecutionDate) { }
            column(ExecutionTime; ExecutionTime) { }
            column(AmountInWords; AmountInWords) { }
            column(PrepaymentAmt; "Prepayment Amount") { }
            column(BalanceAmt; BalanceAmt) { }
            column(SONarration; SONarration) { }
            column(TCSAmount; TCSAmount) { }
            column(RoundOff; RoundOff) { }
            column(RoundOffValue; RoundOffValue) { }
            column(RounndOffRemaining; RounndOffRemaining) { }
            column(LUTNo; LUTNo) { }
            column(LutValue; LutValue) { }
            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Line No.") WHERE("Document Type" = CONST(Order), "Qty. to Ship" = FILTER(<> 0));
                column(Item_Description; Description) { }
                column(Description_2; "Description 2") { }
                column(No_; "No.") { }
                column(Quantity; "Qty. to Ship") { }
                //dt:-02/02/25 cgst,sgst & igst % added
                column(CGST_Percentage; "CGST Percentage") { }
                column(SGST_Percentage; "SGST Percentage") { }
                column(IGST_Percentage; "IGST Percentage") { }
                column(CGST_Amount; CGSTAmount) { }
                column(SGST_Amount; SGSTAmount) { }
                column(IGST_Amount; IGSTAmount) { }
                column(Line_Amount; LineAmount) { }
                column(Inst_SR_No_; "Item Instrument No.") { }
                column(Narration; Narration) { }
                trigger OnAfterGetRecord()
                var
                    SalesCommentLine: Record "Sales Comment Line";
                begin
                    LineAmount := "Qty. to Ship" * "Unit Price";
                    CGSTAmount := ("CGST Amount" / Quantity) * "Qty. to Ship";
                    SGSTAmount := ("SGST Amount" / Quantity) * "Qty. to Ship";
                    IGSTAmount := ("IGST Amount" / Quantity) * "Qty. to Ship";

                    //TBC- 1024 <----
                    if SalesLine.Remark = '' then begin
                        SalesCommentLine.Reset();
                        SalesCommentLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                        SalesCommentLine.SetRange("No.", SalesLine."Document No.");
                        SalesCommentLine.SetRange("Document Line No.", SalesLine."Line No.");
                        if SalesCommentLine.findfirst() then
                            Narration := SalesCommentLine.Comment
                        else
                            Narration := '';
                    end else
                        Narration := SalesLine.Remark;
                    //TBC- 1024 ---->
                end;
            }
            trigger OnAfterGetRecord()
            var
                SLine: Record "Sales Line";
                PostedSalesHeader: Record "Sales Invoice Header";
                PostedSalesLine: Record "Sales Invoice Line";
                State: Record State;
                SalesCommentLine: Record "Sales Comment Line";
                ShiptoAddress: Record "Ship-to Address";
                Customer: Record Customer;
                SOLineAmt: Decimal;
                SOCGST: Decimal;
                SOSGST: Decimal;
                SOIGST: Decimal;
            begin
                ExecutionDate := Format(Today, 0, '<Day,2>/<Month,2>/<Year4>');
                ExecutionTime := Time;
                InvoiceDate := Format("Order Date", 0, '<Day,2>/<Month,2>/<Year4>');
                PODate := Format("Customer PO Date", 0, '<Day,2>/<Month,2>/<Year4>');
                Contract_Start_Date := Format("Contract Start Date", 0, '<Day,2>/<Month,2>/<Year4>');
                Contract_End_Date := Format("Contract End Date", 0, '<Day,2>/<Month,2>/<Year4>');
                Visit_Date := Format("Visit Date", 0, '<Day,2>/<Month,2>/<Year4>');
                // Ship-to Address
                if "SalesHeader"."Custom Ship-to" = "SalesHeader"."Custom Ship-to"::"Default (Sell-to Address)" then begin
                    if Customer.get("Sell-to Customer No.") then begin
                        ShiptoCode := Customer."No.";
                        ShiptoCustName := Customer.Name;
                        ShiptoAdd := Customer.Address;
                        ShiptoAdd2 := Customer."Address 2";
                        ShiptoCity := Customer.City;
                        ShiptoPin := Customer."Post Code";
                        ShiptoGST := Customer."GST Registration No.";
                        State.Reset();
                        if State.Get(Customer."State Code") then begin
                            STCStateName := State.Description;
                            STCStateCode := State."State Code (GST Reg. No.)";
                        end;
                    end;
                end
                else if "SalesHeader"."Custom Ship-to" = "SalesHeader"."Custom Ship-to"::"Alternate Shipping Address" then begin
                    if "SalesHeader"."Ship-to Code" <> '' then
                        if ShiptoAddress.Get("Sell-to Customer No.", "Ship-to Code") then begin
                            ShiptoCode := ShiptoAddress.Code;
                            ShiptoCustName := ShiptoAddress.Name;
                            ShiptoAdd := ShiptoAddress.Address;
                            ShiptoAdd2 := ShiptoAddress."Address 2";
                            ShiptoCity := ShiptoAddress.City;
                            ShiptoPin := ShiptoAddress."Post Code";
                            ShiptoGST := ShiptoAddress."GST Registration No.";
                            State.Reset();
                            if State.Get(ShiptoAddress.State) then begin
                                STCStateName := State.Description;
                                STCStateCode := State."State Code (GST Reg. No.)";
                            end;
                        end;
                end
                else if "SalesHeader"."Custom Ship-to" = "SalesHeader"."Custom Ship-to"::"Custom Address" then begin
                    ShiptoCode := "Ship-to Code";
                    ShiptoCustName := "Ship-to Name";
                    ShiptoAdd := "Ship-to Address";
                    ShiptoAdd2 := "Ship-to Address 2";
                    ShiptoCity := "Ship-to City";
                    ShiptoPin := "Ship-to Post Code";
                    ShiptoGST := "Custom GST No";
                    State.Reset();
                    if State.Get("Custom State") then begin
                        STCStateName := State.Description;
                        STCStateCode := State."State Code (GST Reg. No.)";
                    end;
                end;
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
                    //getting state and state code of bill-to address
                    State.Reset();
                    if State.Get(Customer."State Code") then begin
                        BTCStateName := State.Description;
                        BTCStateCode := State."State Code (GST Reg. No.)";
                    end;
                end;
                if "Shortcut Dimension 2 Code" <> '' then
                    if DimValue.Get('REGION', "Shortcut Dimension 2 Code") then;
                if "Payment Terms Code" <> '' then
                    if PTC.Get(SalesHeader."Payment Terms Code") then;
                SLine.SetRange("Document Type", SalesHeader."Document Type"::Order);
                SLine.SetRange("Document No.", SalesHeader."No.");
                if SLine.FindSet() then begin
                    repeat
                        if SLine.Quantity <> 0 then begin
                            SOLineAmt := SLine."Qty. to Ship" * SLine."Unit Price";
                            SOCGST := (SLine."CGST Amount" / SLine.Quantity) * SLine."Qty. to Ship";
                            SOSGST := (SLine."SGST Amount" / SLine.Quantity) * SLine."Qty. to Ship";
                            SOIGST := (SLine."IGST Amount" / SLine.Quantity) * SLine."Qty. to Ship";
                            BalAmount += SOLineAmt + SOCGST + SOSGST + SOIGST;
                            // BalAmount += SLine."Line Amount" + SLine."IGST Amount" + SLine."SGST Amount" + SLine."CGST Amount";
                        end;
                    until SLine.Next() = 0;

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
                //Sales Order Comments
                SalesCommentLine.SetRange("Document Type", "Document Type"::Order);
                SalesCommentLine.SetRange("No.", "No.");
                SalesCommentLine.SetRange("Document Line No.", 0);
                if SalesCommentLine.findfirst() then
                    SONarration := SalesCommentLine.Comment
                else
                    SONarration := '';
                //service description form service type
                if ServiceType.Get("Service_Type_") then;
                TDSEntry.Reset();
                TDSEntry.SetRange("Document No.", SalesHeader."No.");
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
        ServiceType: Record "ServiceType";
        DimValue: Record "Dimension Value";
        PTC: Record "Payment Terms";
        TDSEntry: Record "TDS Entry";
        InvoiceDate: Text;
        PODate: Text;
        Contract_Start_Date: Text;
        Contract_End_Date: Text;
        Visit_Date: Text;
        ExecutionDate: Text;
        ExecutionTime: time;
        BalAmount: Decimal;
        AmountInWords: Text;
        Narration: Text;
        BalanceAmt: Decimal;
        SONarration: Text;
        BillToCust: Code[20];
        BilltoCustName: Text;
        BilltoAdd: Text;
        BilltoAdd2: Text;
        BilltoCity: Text;
        BilltoPin: Text;
        BilltoGST: Code[20];
        BTCStateName: Text[50];
        BTCStateCode: Code[10];
        ShiptoCode: Code[20];
        ShiptoCustName: Text;
        ShiptoAdd: Text;
        ShiptoAdd2: Text;
        ShiptoCity: Text;
        ShiptoPin: Text;
        ShiptoGST: Code[20];
        STCStateName: Text[50];
        STCStateCode: Code[10];
        VirtualAcNo: Text[50];
        CGSTAmount: Decimal;
        SGSTAmount: Decimal;
        IGSTAmount: Decimal;
        LineAmount: Decimal;
        TCSAmount: Decimal;
        RoundOff: Boolean;
        RoundOffValue: Decimal;
        RounndOffRemaining: Decimal;
        LUTNo: Boolean;  //TBC-934
        LutValue: Text; //TBC-934
        SalesRecSetup: Record "Sales & Receivables Setup";

}