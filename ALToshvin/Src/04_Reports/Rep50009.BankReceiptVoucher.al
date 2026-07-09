report 50009 "Bank Receipt Voucher"
{
    ApplicationArea = All;
    Caption = 'Custom Bank Receipt Voucher';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\04_Reports\Layouts\BankReceiptVoucher.rdl';
    dataset
    {
        dataitem(BankAccountLedgerEntry; "Bank Account Ledger Entry")
        {
            RequestFilterFields = "Entry No.";
            column(DocumentNo; "Document No.") { }
            column(DocumentDate; "Document Date") { }
            column(Cheque_No_; "Cheque No.") { }
            column(Cheque_Date; "Cheque Date") { }
            column(Amount; Amount) { }
            column(Name; Name) { }
            column(Address; Address) { }
            column(Address2; Address2) { }
            column(City; City) { }
            column(County; County) { }
            column(CountryRegionCode; CountryRegionCode) { }
            column(PostCode; PostCode) { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(AccountCode; AccountCode) { }
            column(Department; Department) { }
            column(ModeOfTransport; ModeOfTransport) { }
            column(AmountInWords; AmountInWords) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyPostCode; companyinfo."Post Code") { }
            column(CompanyGSTNo; CompanyInfo."GST Registration No.") { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(CompanyRegNo; CompanyInfo."Registration No.") { }
            column(CurrentDate; CurrentDate) { }
            column(CurrentTime; CurrentTime) { }
            column(User_ID; "User ID") { }
            column(Narration; Narration) { }
            dataitem("GLEntry"; "G/L Entry")
            {
                DataItemLinkReference = BankAccountLedgerEntry;
                DataItemLink = "Entry No." = field("Entry No.");
                DataItemTableView = sorting("Entry No.");

                column(Comment; Comment) { }
            }

            trigger OnAfterGetRecord()
            var
            begin
                Clear(Name);
                Clear(Address);
                Clear(Address2);
                Clear(City);
                Clear(County);
                Clear(PostCode);
                Clear(CountryRegionCode);
                Clear(ModeOfTransport);
                Clear(AccountCode);
                Clear(Department);
                Clear(AmountInWords);

                Clear(Department);
                DimensionName.Reset();
                DimensionName.SetRange(Code, BankAccountLedgerEntry."Global Dimension 1 Code");
                if DimensionName.FindFirst() then
                    Department := DimensionName.Name;

                Clear(AccountCode);
                Clear(Name);
                Clear(Address);
                Clear(Address2);
                Clear(City);
                Clear(County);
                Clear(CountryRegionCode);
                Clear(PostCode);
                Clear(ModeOfTransport);
                if "Bal. Account Type" = "Bal. Account Type"::Customer then begin
                    if Cust.Get(BankAccountLedgerEntry."Bal. Account No.") then begin
                        AccountCode := "Bal. Account No.";
                        Name := Cust.Name;
                        Address := Cust.Address;
                        Address2 := Cust."Address 2";
                        City := Cust.City;
                        County := Cust.County;
                        CountryRegionCode := Cust."Country/Region Code";
                        PostCode := Cust."Post Code";
                        ModeOfTransport := Cust."Payment Method Code";
                    end;
                end else
                    if "Bal. Account Type" = "Bal. Account Type"::Vendor then begin
                        if Vend.Get("Bal. Account No.") then begin
                            AccountCode := "Bal. Account No.";
                            Name := Vend.Name;
                            Address2 := Vend.Address;
                            Address2 := Vend."Address 2";
                            City := Vend.City;
                            County := Vend.County;
                            CountryRegionCode := Vend."Country/Region Code";
                            PostCode := Vend."Post Code";
                            ModeOfTransport := Vend."Payment Method Code";
                        end;
                    end;
                Clear(AmountInWords);
                AmountInWords := AmountInWordsIndian(BankAccountLedgerEntry.Amount);
                CurrentDate := Today;
                CurrentTime := Time;

                Clear(Narration);
                PostedNarration.Reset();
                PostedNarration.SetRange("Document No.", BankAccountLedgerEntry."Document No.");
                PostedNarration.SetRange("Transaction No.", BankAccountLedgerEntry."Transaction No.");
                PostedNarration.SetLoadFields(Narration);
                if PostedNarration.FindSet() then
                    repeat
                        Narration += PostedNarration.Narration;
                    until PostedNarration.Next() = 0;
            end;
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
        Name: Text[100];
        Address: Text[100];
        Address2: Text[50];
        City: Text[30];
        County: Text[30];
        CountryRegionCode: Code[10];
        PostCode: Code[20];
        Cust: Record Customer;
        Vend: Record Vendor;
        ModeOfTransport: Code[10];
        AccountCode: Code[20];
        DimensionName: Record "Dimension Value";
        Department: Text[100];
        AmountInWords: Text;
        CurrentDate: Date;
        CurrentTime: Time;
        Narration: Text;
        PostedNarration: Record "Posted Narration";
}
