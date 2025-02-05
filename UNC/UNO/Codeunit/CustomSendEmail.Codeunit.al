codeunit 50102 "Custom Send Email"
{
    procedure ConformingEmail(Fund: Record "Fund Transfer Header"; FundLine: Record "Fund Transfer Line")
    begin
        // if Confirm('Are you sure you want to send this email..?') then
        SimpleEMail(Fund);
    end;

    procedure SimpleEMail(Fund: Record "Fund Transfer Header")
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;

    begin
        EmailMessage.Create(Fund.ToCompEmail, HeaderforEmail(Fund), BodyforEmail(Fund));
        // EmailMessage.SetBodyHTMLFormatted(true);
        // Email.OpenInEditor(EmailMessage, EmailSceniro::Default);
        Email.Send(EmailMessage);
        Message('email sent successfully...!');
    end;

    procedure HeaderforEmail(Fund: Record "Fund Transfer Header"): Text

    begin
        exit('Fund Tranfer Details from' + Fund.FromCompany);
    end;

    procedure BodyforEmail(Fund: Record "Fund Transfer Header") Emailbody: Text

    begin
        // GetHeaderofBody(SH, Emailbody);
        // GetTableforLineofEmail(SH, Emailbody);
        Emailbody := 'Fund Amount is transfer' + Fund.FromCompany;
    end;

}
