codeunit 50004 TripGainExpenseVoucherWebToBC
{
    //TBC-876 ----------------->
    procedure CreateTripGainExpenseVoucherFromWeb(webexpensevoucherJsonInput: Text): Text
    var
        WebVoucherJSON: JsonObject;
        Status: Text;
        EmployeeNo: Code[20];
        Employee: Record Employee;
        CurrencyCode: Code[10];
        Currency: Record Currency;

        VoucherLineJsonToken: JsonToken;
        VoucherLinesJsonArray: JsonArray;
        VoucherLineJsonObject: JsonObject;

        AccountNo: Code[20];
        GLAccount: Record "G/L Account";

        VoucherHeader: Record "TripGain Voucher Header";
        VoucherLine: Record "TripGain Voucher Line";

        OutStr: OutStream;
        LineNo: Integer;
        TripGainID: Code[50];
    begin
        clear(EmployeeNo);
        clear(Status);
        clear(CurrencyCode);
        clear(AccountNo);


        // 🔹 Read JSON
        if not WebVoucherJSON.ReadFrom(webexpensevoucherJsonInput) then
            Error('Invalid JSON.');

        // 🔹 TripGain ID
        TripGainID := GetJsonToken(WebVoucherJSON, 'tripgainID').AsValue().AsText();
        if TripGainID = '' then
            Error('TripGain ID is missing.');

        // 🔹 Check duplicate TripGain ID
        VoucherHeader.Reset();
        VoucherHeader.SetRange("TripGain ID", TripGainID);
        if VoucherHeader.FindFirst() then
            exit(StrSubstNo('TripGain ID %1 already exists.', TripGainID));


        // 🔹 Validate Status
        Status := GetJsonToken(WebVoucherJSON, 'status').AsValue().AsText();
        if Status <> 'Approved' then
            Error('Only Approved vouchers allowed.');

        // 🔹 Validate Employee
        EmployeeNo := GetJsonToken(WebVoucherJSON, 'employeeNo').AsValue().AsText();
        if EmployeeNo = '' then
            Error('Employee ID is missing.');

        if not Employee.Get(EmployeeNo) then
            Error('Employee ID %1 does not exist in MBD.', EmployeeNo);

        // 🔹 Validate Currency
        CurrencyCode := GetJsonToken(WebVoucherJSON, 'currencyCode').AsValue().AsCode();
        if CurrencyCode = '' then
            Error('Currency Code is missing.');

        if not Currency.Get(CurrencyCode) then
            Error('Currency Code %1 does not exist in MBD.', CurrencyCode);

        // 🔹 Validate Lines
        if WebVoucherJSON.Get('lines', VoucherLineJsonToken) then begin
            VoucherLinesJsonArray := VoucherLineJsonToken.AsArray();

            foreach VoucherLineJsonToken in VoucherLinesJsonArray do begin
                VoucherLineJsonObject := VoucherLineJsonToken.AsObject();

                AccountNo := GetJsonToken(VoucherLineJsonObject, 'accountNo').AsValue().AsText();

                if AccountNo = '' then
                    Error('Account Number is missing in one of the lines.');

                GLAccount.Reset();
                GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                GLAccount.SetRange(Blocked, false);
                GLAccount.SetRange("No.", AccountNo);
                if not GLAccount.FindFirst() then
                    Error('G/L Account %1 does not exist or is blocked in MBD.', AccountNo);
            end;
        end;

        // 🔹 Insert Header
        VoucherHeader.Init();
        VoucherHeader."Entry No." := GetNextVoucherEntryNo();
        VoucherHeader."TripGain ID" := TripGainID;
        VoucherHeader."External Document No." := GetJsonToken(WebVoucherJSON, 'externalDocumentNo').AsValue().AsText();
        VoucherHeader."Posting Date" := GetJsonToken(WebVoucherJSON, 'postingDate').AsValue().AsDate();
        VoucherHeader."Employee No." := EmployeeNo;
        VoucherHeader."Currency Code" := CurrencyCode;
        VoucherHeader."Payment Method" := GetJsonToken(WebVoucherJSON, 'paymentMethod').AsValue().AsText();
        VoucherHeader.Status := Status;

        VoucherHeader."Input JSON".CreateOutStream(OutStr);
        OutStr.WriteText(webexpensevoucherJsonInput);

        VoucherHeader.Insert();

        // 🔹 Insert Lines
        if WebVoucherJSON.Get('lines', VoucherLineJsonToken) then begin
            VoucherLinesJsonArray := VoucherLineJsonToken.AsArray();
            LineNo := 10000;

            foreach VoucherLineJsonToken in VoucherLinesJsonArray do begin
                VoucherLineJsonObject := VoucherLineJsonToken.AsObject();

                VoucherLine.Init();
                VoucherLine."Entry No." := VoucherHeader."Entry No.";
                VoucherLine."Line No." := LineNo;
                VoucherLine."TripGain ID" := TripGainID;
                VoucherLine."Account No." := GetJsonToken(VoucherLineJsonObject, 'accountNo').AsValue().AsText();
                VoucherLine.Comments := GetJsonToken(VoucherLineJsonObject, 'description').AsValue().AsText();
                VoucherLine.Amount := GetJsonToken(VoucherLineJsonObject, 'amount').AsValue().AsDecimal();
                VoucherLine.Insert();

                LineNo += 10000;
            end;
        end;

        // 🔹 Create Journal
        CreateGenJournalFromVoucher(TripGainID);

        exit('Voucher Created Successfully');
    end;

    // ================= JOURNAL CREATION =================

    procedure CreateGenJournalFromVoucher(TripGainId: Code[50])
    var
        VoucherHeader: Record "TripGain Voucher Header";
        VoucherLine: Record "TripGain Voucher Line";
        GenJnlLine: Record "Gen. Journal Line";
        NoSeriesMgt: Codeunit "No. Series";
        RecNoSeries: Record "No. Series";
        LineNo: Integer;
        DocNo: Code[20];
    begin
        VoucherHeader.Reset();
        VoucherHeader.SetRange("TripGain ID", TripGainId);
        if not VoucherHeader.FindFirst() then
            exit;

        if VoucherHeader."BC Journal Completed" then
            exit;

        RecNoSeries.Reset();
        RecNoSeries.SetRange(Code, 'EMPEXP');
        if RecNoSeries.FindFirst() then
            DocNo := NoSeriesMgt.GetNextNo(RecNoSeries.Code, Today, true)
        else
            Error('No. Series EMPEXP not found.');

        VoucherLine.Reset();
        VoucherLine.SetRange("TripGain ID", TripGainId);
        VoucherLine.SetRange("BC Journal Created", false);

        LineNo := GetNextLineNo();

        if VoucherLine.FindSet() then
            repeat
                ClearLastError();

                if VoucherLine.Amount = 0 then begin
                    VoucherLine."BC Journal Created" := true;
                    VoucherLine."Error Message" := 'Skipped: Amount is zero';
                    VoucherLine.Modify();
                    continue;
                end;

                if CreateJournalLine(GenJnlLine, VoucherHeader, VoucherLine, LineNo, DocNo) then begin
                    VoucherLine."BC Journal Created" := true;
                    VoucherLine."Error Message" := '';
                    VoucherLine.Modify();

                    LineNo += 10000;
                end else begin
                    VoucherLine."Error Message" :=
                      CopyStr(GetLastErrorText(), 1, MaxStrLen(VoucherLine."Error Message"));
                    VoucherLine.Modify();
                end;

            until VoucherLine.Next() = 0;

        if IsAllLinesProcessed(TripGainId) then begin
            VoucherHeader."BC Journal Completed" := true;
            VoucherHeader.Modify();
        end;
    end;

    [TryFunction]
    local procedure CreateJournalLine(
    var GenJnlLine: Record "Gen. Journal Line";
    VoucherHeader: Record "TripGain Voucher Header";
    VoucherLine: Record "TripGain Voucher Line";
    LineNo: Integer;
    DocNo: Code[20])
    begin
        GenJnlLine.Init();
        GenJnlLine.Validate("Journal Template Name", 'EMPEXPENSE');
        GenJnlLine.Validate("Journal Batch Name", 'EXPENSE');
        GenJnlLine."Line No." := LineNo;

        GenJnlLine.Validate("Posting Date", VoucherHeader."Posting Date");
        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::" ");
        GenJnlLine.Validate("Document No.", DocNo);
        GenJnlLine.Validate("External Document No.", VoucherHeader."External Document No.");

        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.Validate("Account No.", VoucherLine."Account No.");

        GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::Employee);
        GenJnlLine.Validate("Bal. Account No.", VoucherHeader."Employee No.");

        GenJnlLine.Validate(Comment, VoucherLine.Comments);
        GenJnlLine.Validate(Amount, VoucherLine.Amount);
        GenJnlLine.Validate("Payment Method Code", VoucherHeader."Payment Method");

        GenJnlLine."TripGain ID" := VoucherHeader."TripGain ID";

        GenJnlLine.Insert(true);
    end;

    local procedure IsAllLinesProcessed(TripGainId: Code[50]): Boolean
    var
        VoucherLine: Record "TripGain Voucher Line";
    begin
        VoucherLine.SetRange("TripGain ID", TripGainId);
        VoucherLine.SetRange("BC Journal Created", false);
        exit(not VoucherLine.FindFirst());
    end;

    local procedure GetNextLineNo(): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", 'EMPEXPENSE');
        GenJnlLine.SetRange("Journal Batch Name", 'EXPENSE');

        if GenJnlLine.FindLast() then
            exit(GenJnlLine."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: Text): JsonToken
    var
        Token: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, Token) then
            Error('Missing JSON field: %1', TokenKey);

        exit(Token);
    end;

    local procedure GetNextVoucherEntryNo(): Integer
    var
        VoucherHeader: Record "TripGain Voucher Header";
        P: Page "General Journal";
    begin
        if VoucherHeader.FindLast() then
            exit(VoucherHeader."Entry No." + 1)
        else
            exit(1);
    end;

    //TBC-876 <----------------

}
