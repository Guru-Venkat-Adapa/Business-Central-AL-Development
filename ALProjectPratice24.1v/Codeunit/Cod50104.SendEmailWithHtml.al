codeunit 50104 "SendAutoEmailWithHtmlbody"
{
    procedure SendEMailtoCustomer(SalesQuoteNo: Code[20])
    var
        EmailMessage: Codeunit "Email Message";
        email: Codeunit Email;
        base64: Codeunit "Base64 Convert";
        InS: InStream;
        EMailBody: text;
        Outstrebody: OutStream;
        DocRef: RecordRef;
        FldRef: FieldRef;
        TempBlob: Codeunit "Temp Blob";
        i: Integer;
        Copys: Integer;
        MailRecp: List of [Text];
        SalesHeader: Record "Sales Header";
    begin
        MailRecp.Add('satish.s@shaligraminfotech.com');
        MailRecp.Add('balaji.k@shaligraminfotech.com');
        MailRecp.Add('guru.v@shaligraminfotech.com');
        Clear(EMailBody);
        Clear(ins);
        SalesHeader.get(SalesHeader."Document Type"::Quote, SalesQuoteNo);
        DocRef.GetTable(SalesHeader);
        FldRef := DocRef.Field(SalesHeader.FieldNo("No."));
        FldRef.SetRange(SalesHeader."No.");
        if DocRef.FindFirst() then begin
            Clear(TempBlob);
            TempBlob.CreateOutStream(Outstrebody);
            report.SaveAs(report::"SalesQuoteCustom", '', ReportFormat::Html, Outstrebody, DocRef);
            tempblob.CreateInStream(InS);
            InS.ReadText(EMailBody);
            EmailMessage.Create(MailRecp, SalesHeader."Bill-to Name" + ' ' + 'Sales Quote', EMailBody, true);
            Clear(TempBlob);
            TempBlob.CreateOutStream(Outstrebody);
            Report.SaveAs(Report::"SalesQuoteCustom", '', ReportFormat::Pdf, Outstrebody, DocRef);
            tempblob.CreateInStream(InS);
            EmailMessage.AddAttachment('Sales Quote.pdf', 'application/pdf', base64.ToBase64(InS));
            email.Send(EmailMessage);
        end;
    end;

    procedure ConfirmationEmail(SH: Record "Sales Header")
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        SL: Record "Sales Line";
        Subject: Text;
        Body: Text;
        SubjectLabel: Label 'Delivery Confirmation Email Template';
        Address: Text;
        BodyLabel: Label 'Dear %1,<br><br> Your %2 containing %3 x %4 @ %5 each (SKU: %6) has been successfully delivered at %7. <br> We hope you like it and would appreciate your feedback on your shopping experience and the product %8.';
        Item: Text;
        Quantity: Decimal;
        Price: Decimal;
    begin
        Address := SH."Sell-to Address" + ', ' + SH."Sell-to Address 2" + ', ' + SH."Sell-to City";
        Subject := StrSubstNo(SubjectLabel);
        SL.SetRange("Document No.", SH."No.");
        if SL.FindSet() then begin
            Item := SL.Description;
            Quantity := SL.Quantity;
            Price := SL."Line Amount";
        end;
        Body := StrSubstNo(BodyLabel, SH."Sell-to Customer Name", SH."No.", Item, Quantity, Price, 'SKU ID', Address, 'Click here...');
        EmailMessage.Create('guru.v@shaligraminfotech.com', Subject, Body);
        Email.Send(EmailMessage);
        Message('Email send successfully...');
    end;
    /***********************          Email Sending Part by part                   ************************/
    procedure ConformingEmail(SH: Record "Sales Header")
    begin
        if Confirm('Are you sure you want to send this email..?') then
            SimpleEMail(SH);
    end;

    procedure SimpleEMail(SH: Record "Sales Header")
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        EmailSceniro: Enum "Email Scenario";
        Subject: Text;
        Body: Text;
    begin
        EmailMessage.Create('satish.s@shaligraminfotech.com', HeaderforEmail(SH), HtmlBodyforEmail(SH));
        EmailMessage.SetBodyHTMLFormatted(true);
        // Email.OpenInEditor(EmailMessage, EmailSceniro::Default);
        Email.Send(EmailMessage);
        Message('email sent successfully.');
    end;

    procedure HeaderforEmail(SH: Record "Sales Header"): Text

    begin
        exit('Delivery Confirmation Email Template of ' + SH."No.");
    end;

    procedure HtmlBodyforEmail(SH: Record "Sales Header") Emailbody: Text

    begin
        GetHeaderofBody(SH, Emailbody);
        GetTableforLineofEmail(SH, Emailbody);
    end;

    procedure GetHeaderofBody(SH: Record "Sales Header"; var Emailbody: Text): Text

    begin
        Emailbody := 'Dear <b>' + SH."Bill-to Name" + '</b>,</br></br>' + 'Find the sales line details for sales order ' + SH."No." + '</br></br>';
    end;

    procedure GetTableforLineofEmail(SH: Record "Sales Header"; var EmailBody: Text)
    var
        SLine: Record "Sales Line";
    begin
        SLine.SetRange("Document Type", SH."Document Type"::Order);
        SLine.SetRange("Document No.", SH."No.");
        if SLine.FindSet() then begin
            EmailBody := EmailBody + '<table style="width:100%;border:1px solid black;">';
            EmailBody := EmailBody + '<tr>';
            EmailBody := EmailBody + '<th style="border:1px solid black;">Item No</th>';
            EmailBody := EmailBody + '<th style="border:1px solid black;">Description</th>';
            EmailBody := EmailBody + '<th style="border:1px solid black;">Quantity</th>';
            EmailBody := EmailBody + '<th style="border:1px solid black;">Qty. To Receive</th>';
            EmailBody := EmailBody + '</tr>';
            repeat
                EmailBody := EmailBody + '<tr>';
                EmailBody := EmailBody + '<td style="border:1px solid black;">' + SLine."No." + '</td>';
                EmailBody := EmailBody + '<td style="border:1px solid black;">' + SLine.Description + '</td>';
                EmailBody := EmailBody + '<td style="border:1px solid black;">' + Format(SLine.Quantity) + '</td>';
                EmailBody := EmailBody + '<td style="border:1px solid black;">' + Format(SLine."Quantity Shipped") + '</td>';
                EmailBody := EmailBody + '</tr>';
            until (SLine.Next() = 0);
            EmailBody := EmailBody + '</table>';
        end;
    end;

    // procedure AddAttachments(SH:Record "Sales Header")ReportInstream:InStream
    // var
    //     myInt: Integer;
    // begin

    // end;
}
