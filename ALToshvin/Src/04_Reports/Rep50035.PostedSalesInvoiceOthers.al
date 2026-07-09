report 50035 "Posted Sales Invoice - Others"
{
    ApplicationArea = All;
    Caption = 'Posted Sales Invoice - Others';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\Reports\Layouts\PostedSalesInvoiceOthers.rdlc';
    dataset
    {
        dataitem(Header; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Posted Sales Invoice';
            // Company Information Details
            column(CompanyDisplayName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyCity; CompanyInfo.City) { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }
            column(CompanyGSTNo; CompanyInfo."GST Registration No.") { }
            column(BankName; CompanyInfo."Bank Name") { }
            column(BankBranch; CompanyInfo."Bank Branch No.") { }
            column(BankAcNo; CompanyInfo."Bank Account No.") { }
            column(IFSCCode; CompanyInfo."SWIFT Code") { }
            column(CompanyPhNo; CompanyInfo."Phone No.") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(CompanyPANNo; CompanyInfo."P.A.N. No.") { }
            column(CurrentDate; CurrentDateFormat) { }
            column(CurrentTime; CurrentTime) { }
            // Customer & Invoice Details
            column(Invoice_No; "No.") { }
            column(InvoiceDate; InvoiceDate) { }
            column(Invoice_Contact_No; "Sell-to Phone No.") { }
            column(Invoice_Email; "Sell-to E-Mail") { }
            column(Invoice_Kind_Attn; "Sell-to Contact") { }
            column(Ack_No; "Acknowledgement No.") { }
            column(IRN_Hash; "IRN Hash") { }
            column(PO_No; "External Document No.") { }
            column(PO_Date; PODate) { }
            column(Payment_Term; PaymentTerms.Description) { }
            column(LR_No; "LR/RR No.") { }
            column(LR_Date; LRDate) { }
            column(Transporter; TransportMethod.Description) { }
            column(Narration; Narration) { }
            column(EncodeStr; EncodeStr) { }
            column(QR_Code; "QR Code") { }
            column(WorkDescriptionTxt; WorkDescriptionTxt) { }
            column(AmountInWords; AmountInWords) { }
            column(RounndOffRemaining; RounndOffRemaining) { }
            column(RoundOffTotalOutstanding; RoundOffTotalOutstanding) { }
            // Bill-to address Details
            column(BTCNo; Customer."No.") { }
            column(BTCName; Customer.Name) { }
            column(BTCAddress; Customer.Address) { }
            column(BTCAddress2; Customer."Address 2") { }
            column(BTCCity; Customer.City) { }
            column(BTCPostCode; Customer."Post Code") { }
            column(BTCStateName; BTCStateName) { }
            column(BTCStateCode; BTCStateCode) { }
            column(Bill_to_GST; Customer."GST Registration No.") { }
            column(Bill_to_PAN; Customer."P.A.N. No.") { }
            // Ship -to Address Details
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
                trigger OnAfterGetRecord()
                begin
                    Clear(TotalDiscAmt);
                    Clear(TaxableAmt);
                    Clear(TotalOutstandingAmt);
                    TotalDiscAmt := "Line Discount Amount" + "Inv. Discount Amount";
                    TaxableAmt := ("Unit Price" * Quantity) - TotalDiscAmt;
                    TotalOutstandingAmt := TaxableAmt + "CGST Amount" + "SGST Amount" + "IGST Amount";
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
                Salesline: Record "Sales Invoice Line";
                SalesCommentLine: Record "Sales Comment Line";
                BarcodeSym: Enum "Barcode Symbology 2D";
                BarcodeProvider: Interface "Barcode Font Provider 2D";
                ShiptoAddress: Record "Ship-to Address";
            begin
                Clear(InvoiceDate);
                Clear(PODate);
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
                InvoiceDate := Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>');
                PODate := Format("Customer PO Date", 0, '<Day,2>/<Month,2>/<Year4>');
                LRDate := Format("LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');
                // Getting bill -to state name and state GST code
                Clear(BTCStateName);
                Clear(BTCStateCode);
                if State.Get("Header"."Bill-to County") then begin
                    BTCStateName := State.Description;
                    BTCStateCode := State."State Code (GST Reg. No.)";
                end;
                // Getting Ship -to state name and state GST code
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
                // Getting customer GST and PAN No.
                if Header."Sell-to Customer No." <> '' then
                    if Customer.Get(Header."Sell-to Customer No.") then;
                // Getting Pamnet Terms Details
                if Header."Payment Terms Code" <> '' then
                    if PaymentTerms.Get(Header."Payment Terms Code") then;
                // Getting Transporter Details
                if Header."Transport Method" <> '' then
                    if TransportMethod.Get(Header."Transport Method") then;

                //QR Code Detail
                Header.CalcFields("QR Code");
                // Commenst/ Narration Detail
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
                // Amount In Word Value Detail along with Rounding Off
                Clear(BalAmount);
                Salesline.SetRange("Document No.", "Header"."No.");
                if Salesline.FindSet() then begin
                    repeat
                        BalAmount += (((Salesline."Unit Price" * Salesline.Quantity) - (Salesline."Line Discount Amount" + Salesline."Inv. Discount Amount")) + Salesline."CGST Amount" + Salesline."SGST Amount" + Salesline."IGST Amount");
                    until Salesline.Next() = 0;
                end;
                // Round Off & Amount in words Value
                Clear(AmountInWords);
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

                //TBC-1021  ---->
                Clear(WorkDescriptionTxt);
                Header.CalcFields("Work Description");
                if Header."Work Description".HasValue then begin
                    Header."Work Description".CreateInStream(InStr);
                    InStr.ReadText(WorkDescriptionTxt);
                end;
                //TBC-1021 <----
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
        CurrentTime := Time;
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
        Customer: Record Customer;
        PaymentTerms: Record "Payment Terms";
        TransportMethod: Record "Transport Method";
        BTCStateCode: Code[10];
        BTCStateName: Text[50];
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
        InvoiceDate: Text;
        PODate: Text;
        LRDate: Text;
        EncodeStr: Text;
        Narration: Text;
        RoundOffValue: Decimal;
        RoundOff: Boolean;
        RoundOffTotalOutstanding: Decimal;
        AmountInWords: Text;
        RounndOffRemaining: Decimal;
        BalAmount: Decimal;
        TotalDiscAmt: Decimal;
        TaxableAmt: Decimal;
        TotalOutstandingAmt: Decimal;
        CurrentDate: Date;
        CurrentDateFormat: Text;
        CurrentTime: Time;
        InStr: InStream;
        WorkDescriptionTxt: Text;
}