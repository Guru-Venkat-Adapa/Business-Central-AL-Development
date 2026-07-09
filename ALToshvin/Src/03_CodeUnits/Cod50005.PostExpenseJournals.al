codeunit 50005 "Post Expense Journals"
{
    //TBC-876 ----------------->
    Subtype = Normal;

    trigger OnRun()
    begin
        ProcessJournals();
    end;

    // ================= MAIN =================
    procedure ProcessJournals()
    var
        VoucherHeader: Record "TripGain Voucher Header";
    begin
        VoucherHeader.SetRange("BC Journal Completed", true);
        VoucherHeader.SetRange("G/L Posted", false);
        if VoucherHeader.FindSet() then
            repeat
                PostSingleVoucher(VoucherHeader);
            until VoucherHeader.Next() = 0;
    end;

    // ================= POST SINGLE =================
    local procedure PostSingleVoucher(var VoucherHeader: Record "TripGain Voucher Header")
    var
        GenJnlLine: Record "Gen. Journal Line";
        ErrorMsg: Text;
    begin
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", 'EMPEXPENSE');
        GenJnlLine.SetRange("Journal Batch Name", 'EXPENSE');

        // 🔥 MOST IMPORTANT FILTER
        GenJnlLine.SetRange("TripGain ID", VoucherHeader."TripGain ID");

        if not GenJnlLine.FindFirst() then begin
            VoucherHeader."Error Message" := 'No journal lines found.';
            VoucherHeader.Modify();
            exit;
        end;

        ClearLastError();

        // 🔹 TRY FULL POSTING
        if TryPostJournal(GenJnlLine) then begin
            // ✅ SUCCESS
            VoucherHeader."G/L Posted" := true;
            VoucherHeader."Error Message" := '';
            VoucherHeader.Modify();

            MarkAllLinesSuccess(VoucherHeader."TripGain ID");
        end else begin
            // ❌ FAILED → DO LINE-WISE ERROR CAPTURE
            ErrorMsg := GetLastErrorText();

            VoucherHeader."Error Message" := ErrorMsg;
            VoucherHeader.Modify();

            CaptureLineErrors(VoucherHeader."TripGain ID");
        end;
    end;

    // ================= TRY POST =================
    [TryFunction]
    local procedure TryPostJournal(var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        GenJnlPostBatch.Run(GenJnlLine);
    end;

    // ================= MARK SUCCESS =================
    local procedure MarkAllLinesSuccess(TripGainId: Code[50])
    var
        VoucherLine: Record "TripGain Voucher Line";
    begin
        VoucherLine.SetRange("TripGain ID", TripGainId);

        if VoucherLine.FindSet() then
            repeat
                VoucherLine."Error Message" := '';
                VoucherLine.Modify();
            until VoucherLine.Next() = 0;
    end;

    // ================= LINE-WISE ERROR =================
    local procedure CaptureLineErrors(TripGainId: Code[50])
    var
        VoucherLine: Record "TripGain Voucher Line";
        ErrorMsg: Text;
    begin
        VoucherLine.SetRange("TripGain ID", TripGainId);

        if VoucherLine.FindSet() then
            repeat
                ClearLastError();

                if not ValidateSingleLine(VoucherLine) then begin
                    ErrorMsg := GetLastErrorText();
                    VoucherLine."Error Message" := ErrorMsg;
                end else begin
                    VoucherLine."Error Message" := '';
                end;

                VoucherLine.Modify();
            until VoucherLine.Next() = 0;
    end;

    // ================= VALIDATION LOGIC =================
    [TryFunction]
    local procedure ValidateSingleLine(VoucherLine: Record "TripGain Voucher Line")
    var
        GLAccount: Record "G/L Account";
        Employee: Record Employee;
    begin


        // 🔹 Account validation
        if not GLAccount.Get(VoucherLine."Account No.") then
            Error('G/L Account %1 does not exist.', VoucherLine."Account No.");

        if GLAccount.Blocked then
            Error('G/L Account %1 is blocked.', VoucherLine."Account No.");

    end;
    //TBC-876 <-----------------
}
