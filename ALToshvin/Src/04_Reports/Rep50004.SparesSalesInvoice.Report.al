report 50004 SparesSalesInvoice
{
    Caption = 'Sales Proforma Invoice';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Invoice));
            RequestFilterFields = "No.";
            /*  <-------------              Company Info               ---------------->*/
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyGSTNo; CompanyInfo."GST Registration No.") { }
            column(BankName; CompanyInfo."Bank Name") { }
            column(BankBranch; CompanyInfo."Bank Branch No.") { }
            column(BankAcNo; CompanyInfo."Bank Account No.") { }
            column(IFSCCode; CompanyInfo."SWIFT Code") { }
            column(VirtualAcNo; VirtualAcNo) { }
            // <--------------------                       Invoice Detail           --------------------->
            column(Shortcut_Dimension_2_Code; DimensionValueName) { }
            column(SalesInvoiceNo_; "No.") { }
            column(Orderdate; InvoiceDate) { }
            column(EngName; "Executive Master") { }
            column(PrepaymentAmt; "Prepayment Amount") { }
            column(AmountInWords; AmountInWords) { }
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
            column(PoNo; "External Document No.") { }
            column(PoDate; PoDate) { }
            column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
            column(Sell_to_E_Mail; "Sell-to E-Mail") { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(Payment_Terms_Code; PayTermName) { }
            column(Narration; Narration) { }
            column(DeemedExportValue; DeemedExportValue) { }
            /*  <------------------                  Labels              ----------------------------->*/
            column(ProformaInvLbl; ProformaInvLbl) { }
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
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemLinkReference = "Sales Header";
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(ItemNo; "No.") { }
                column(ItemDescription; Description) { }
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
                end;
            }
            trigger OnAfterGetRecord()
            var
                State: Record State;
                Customer: Record Customer;
                PaymentTerm: Record "Payment Terms";
                SalesCommentLine: Record "Sales Comment Line";
                DimensionVal: Record "Dimension Value";
                SalesPerson: Record "Salesperson/Purchaser";
                Salesline: Record "Sales Line";
                PurchaseLine: Record "Purchase Line";
                ShiptoAddress: Record "Ship-to Address";
            begin
                Clear(InvoiceDate);
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
                Clear(VirtualAcNo);
                Clear(PayTermName);
                Clear(Narration);
                Clear(DimensionValueName);
                Clear(BalAmount);
                Clear(AmountInWords);
                InvoiceDate := Format("Order Date", 0, '<Day,2>/<Month,2>/<Year4>');
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
                    // ShiptoPAN := "Custom PAN No.";
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
                // Payment Term Description from Payment Terms table
                if PaymentTerm.Get("Sales Header"."Payment Terms Code") then
                    PayTermName := PaymentTerm.Description;
                // comments/narration values from Sales Comment Line table
                SalesCommentLine.SetRange("Document Type", "Sales Header"."Document Type"::Invoice);
                SalesCommentLine.SetRange("No.", "Sales Header"."No.");
                SalesCommentLine.SetRange("Document Line No.", 0);
                if SalesCommentLine.FindSet() then
                    repeat
                        if Narration = '' then
                            Narration := SalesCommentLine.Comment
                        else
                            Narration := Narration + ', ' + SalesCommentLine.Comment;
                    until SalesCommentLine.Next() = 0;
                // Dimension Description from Dimension table
                If "Sales Header"."Shortcut Dimension 2 Code" <> '' then begin
                    DimensionVal.SetFilter(Code, "Shortcut Dimension 2 Code");
                    if DimensionVal.FindFirst() then
                        DimensionValueName := DimensionVal.Name;
                end;
                // Sales Person Name from Salesperson/Purchaser table
                if SalesPerson.Get("Sales Header"."Salesperson Code") then
                    EngName := SalesPerson.Name;
                // Getting the total in words of the sales lines from sales lines table
                Salesline.SetRange("Document Type", "Sales Header"."Document Type"::Invoice);
                Salesline.SetRange("Document No.", "Sales Header"."No.");
                if Salesline.FindSet() then begin
                    repeat
                        BalAmount += (((Salesline."Unit Price" * Salesline.Quantity) - (Salesline."Line Discount Amount" + Salesline."Inv. Discount Amount")) + Salesline."CGST Amount" + Salesline."SGST Amount" + Salesline."IGST Amount");
                    until Salesline.Next() = 0;
                    AmountInWords := AmountInWordsIndian(BalAmount);
                end;
                // Deemed Export value  start of ticket no.- 918 on 30/03/26
                Clear(DeemedExportValue);
                if "Sales Header"."Deemed Export" then
                    DeemedExportValue := 'This Sale is under “Deemed Export “against Form A ' + "Sales Header"."Deemed Export Instruction"
                else
                    DeemedExportValue := 'THIS IS COMPUTER GENERATED INVOICE HENCE, NO SIGNATURE REQUIRED.';
                // end of ticket no.- 918
            end;
        }
    }
    rendering
    {
        layout(LayoutName)
        {
            Caption = 'Sales Invoice Proforma Invoice';
            Type = RDLC;
            LayoutFile = 'Src\04_Reports\Layouts\SparesSalesInvoice.rdlc';
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
        PoDate: Text;
        PayTermName: Text[100];
        Narration: Text;
        DimensionValueName: Text[50];
        InvoiceDate: Text;
        EngName: Text[50];
        BalAmount: Decimal;
        NoText: array[2] of Text;
        AmountTotal: Text[50];
        AmountInWords: Text;
        TotalDiscAmt: Decimal;
        TaxableAmt: Decimal;
        TotalOutstandingAmt: Decimal;
        VirtualAcNo: Text[50];
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
        DeemedExportValue: Text;
        ProformaInvLbl: Label 'PROFORMA INVOICE';
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
        PayTremsLbl: Label 'Pay. Trems: ';
        SplTermLbl: Label 'Spl. Terms: ';
        BranchLbl: Label 'Branch: ';
        PINoLbl: Label 'PI NO.: ';
        PIDateLbl: Label 'PI Date: ';
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
}