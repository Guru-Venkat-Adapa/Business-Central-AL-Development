pageextension 50104 "Sales Quote Ext" extends "Sales Quote"
{
    actions
    {
        addlast(Action59)
        {
            action(SendEmail)
            {
                ApplicationArea = All;
                Image = SendAsPDF;
                Caption = 'Send Email as PDF';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    EmailwithHtl: Codeunit 50104;
                begin
                    EmailwithHtl.SendEMailtoCustomer(Rec."No.");
                end;
            }
        }
    }
    procedure SendReportByEmail(var SQ: Record "Sales Header")
    var
        SalesQuoteCustom: Report SalesQuoteCustom;
        recRef: RecordRef;
        SalesQ: Record "sales header";
        tmpBlob: Codeunit "Temp Blob";
        cnv64: Codeunit "Base64 Convert";
        InStr: InStream;
        OutStr: OutStream;
        txtB64: Text;
        format: ReportFormat;
        email: Codeunit Email;
        emailMsg: Codeunit "Email Message";
        FileName: Text;
        ConvertI: Text;
        subject: Text;
        subjectlabel: Label 'Hello %1';
        body: Text;
        bodylabel: Label 'Dear %2<br><br>The Sales Document %1';
    begin
        SalesQ.Reset();
        if SQ.FindFirst() then begin
            SalesQ.SetRange("No.", SQ."No.");
            SalesQ.SetRange("Document Type", SQ."Document Type"::Quote);
            if SalesQ.FindSet() then begin
                recRef.GetTable(SalesQ);
                tmpBlob.CreateOutStream(OutStr);
                if Report.SaveAs(Report::SalesQuoteCustom, '', format::Html, OutStr, recRef) then begin
                    tmpBlob.CreateInStream(InStr);
                    txtB64 := cnv64.ToBase64(InStr, true);
                    subject := StrSubstNo(subjectlabel, SQ."Bill-to Name");
                    emailMsg.Create('guru.v@shaligraminfotech.com', 'Subject', 'Body');
                    emailMsg.AddAttachment('SalesQuote.Pdf', 'application/pdf', txtB64);
                    email.Send(emailMsg);
                    Message('mail sent');
                end;
            end;
        end;
    end;

    // var
    //     email: Page "Email Editor";
    //     emailrec: Record "Email Outbox";
}

