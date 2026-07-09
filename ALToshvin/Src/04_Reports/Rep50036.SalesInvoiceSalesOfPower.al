report 50036 "Sales Invoice Sales Of Power"
{
    ApplicationArea = All;
    Caption = 'Sales Invoice Sales Of Power';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\Reports\Layouts\SalesInvoiceSalesOfPower.rdl';
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(No_; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Sell_to_Address; "Sell-to Address") { }
            column(Sell_to_Address_2; "Sell-to Address 2") { }
            column(Sell_to_City; "Sell-to City") { }
            column(Sell_to_County; "Sell-to County") { }
            column(Sell_to_Country_Region_Code; "Sell-to Country/Region Code") { }
            column(Sell_to_Post_Code; "Sell-to Post Code") { }
            column(External_Document_No_; "External Document No.") { }
            column(ComInfo_PAN; ComInfo."P.A.N. No.") { }
            column(ComInfo_CIN; ComInfo."CIN No.") { }

            column(CUrrentTime; CUrrentTime) { }
            column(AmountInWords; AmountInWords) { }
            dataitem(Location; Location)
            {
                DataItemLink = Code = field("Location Code");
                DataItemLinkReference = "Sales Invoice Header";
                DataItemTableView = sorting(Code);

                column(Address;
                Address)
                { }
                column(Address_2; "Address 2") { }
                column(City; City) { }
                column(County; County) { }
                column(Country_Region_Code; "Country/Region Code") { }
                column(Post_Code; "Post Code") { }
                column(GST_Registration_No_; "GST Registration No.") { }
                column(Phone_No_; "Phone No.") { }


            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter('G/L Account'));
                DataItemLinkReference = "Sales Invoice Header";

                column(GL_No_; AccountName) { }
                column(Line_Amount; "Line Amount") { }
                column(Amt; Amt) { }


                dataitem("Sales Comment Line"; "Sales Comment Line")
                {
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.");
                    DataItemLink = "No." = field("Document No."), "Document Line No." = field("Line No.");
                    DataItemLinkReference = "Sales Invoice Line";
                    column(Remark; Comment) { }
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(AccountName);
                    if GLAccount.Get("Sales Invoice Line"."No.") then
                        AccountName := GLAccount.Name;


                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Amt);
                Clear(AmountInWords);
                SalesInvoiceLine.Reset();
                SalesInvoiceLine.SetRange("Document No.", "Sales Invoice Header"."No.");
                SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::"G/L Account");
                if SalesInvoiceLine.FindSet() then
                    repeat
                        Amt += SalesInvoiceLine."Line Amount";
                    until SalesInvoiceLine.Next() = 0;

                if Amt <> 0 then
                    AmountInWords := AmountInWordsIndian(Amt)
                else
                    AmountInWords := '';

                Clear(CUrrentTime);
                CUrrentTime := Time;
            end;
        }
    }

    trigger OnPreReport()
    begin
        ComInfo.Get();
        ComInfo.CalcFields(Picture);
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
        ComInfo: Record "Company Information";
        Amt: Decimal;
        GLAccount: Record "G/L Account";
        AccountName: Text;
        AmountInWords: Text;
        CUrrentTime: Time;
        SalesInvoiceLine: Record "Sales Invoice Line";
}
