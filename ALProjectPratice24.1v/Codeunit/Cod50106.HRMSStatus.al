codeunit 50106 "HRMS Status"
{
    var
        Day1, Day2, Day3, Day4, Day5, Day6, Day7 : text[20];


    procedure SetDate(Start: Record WeeklyTimeSheet)

    begin
        Clear(Day1);
        Clear(Day2);
        Clear(Day3);
        Clear(Day4);
        Clear(Day5);
        Clear(Day6);
        Clear(Day7);
        if Start.WeekStartDate <> 0D then begin
            Start.WeekStartDate := CalcDate('<-CW>', Start.WeekStartDate);
            if Start.WeekStartDate <> 0D then begin
                Day1 := 'Monday(' + Format(Start.WeekStartDate) + ')';
                Day2 := 'Tuesday(' + Format(CalcDate('<+1D>', Start.WeekStartDate)) + ')';
                Day3 := 'Wednesday(' + Format(CalcDate('<+2D>', Start.WeekStartDate)) + ')';
                Day4 := 'Thursday(' + Format(CalcDate('<+3D>', Start.WeekStartDate)) + ')';
                Day5 := 'Friday(' + Format(CalcDate('<+4D>', Start.WeekStartDate)) + ')';
                Day6 := 'Saturday(' + Format(CalcDate('<+5D>', Start.WeekStartDate)) + ')';
                Day7 := 'Sunday(' + Format(CalcDate('<+6D>', Start.WeekStartDate)) + ')';
            end;
        end;
        Message(Day1);
        Message(Day2);
        Message(Day3);
        Message(Day4);
        Message(Day5);
        Message(Day6);
        Message(Day7);

    end;

    procedure SimpleEMail(Start: Record WeeklyTimeSheet)
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        EmailSceniro: Enum "Email Scenario";
        Subject: Text;
        Body: Text;
    begin
        EmailMessage.Create('guru.v@shaligraminfotech.com', HeaderforEmail(Start), HtmlBodyforEmail(Start));
        EmailMessage.SetBodyHTMLFormatted(true);
        Email.OpenInEditor(EmailMessage, EmailSceniro::Default);
        // Email.Send(EmailMessage);
        // Message('email sent successfully.');
    end;

    procedure HeaderforEmail(Start: Record WeeklyTimeSheet): Text

    begin
        exit('Weekly Status');
    end;

    procedure HtmlBodyforEmail(Start: Record WeeklyTimeSheet) Emailbody: Text

    begin
        GetTableforLineofEmail(Start, Emailbody);
    end;


    // procedure GetTableforLineofEmail(Start: Record WeeklyTimeSheet; var EmailBody: Text)
    // begin
    //     Clear(Day1);
    //     Clear(Day2);
    //     Clear(Day3);
    //     Clear(Day4);
    //     Clear(Day5);
    //     // Clear(Day6);
    //     // Clear(Day7);
    //     if Start.WeekStartDate <> 0D then begin
    //         // Start.WeekStartDate := CalcDate('<-CW>', Start.WeekStartDate);
    //         if Start.WeekStartDate <> 0D then begin
    //             Day1 := Format(Start.WeekStartDate);
    //             Day2 := Format(CalcDate('<+1D>', Start.WeekStartDate));
    //             Day3 := Format(CalcDate('<+2D>', Start.WeekStartDate));
    //             Day4 := Format(CalcDate('<+3D>', Start.WeekStartDate));
    //             Day5 := Format(CalcDate('<+4D>', Start.WeekStartDate));
    //             // Day6 := Format(CalcDate('<+5D>', Start.WeekStartDate));
    //             // Day7 := Format(CalcDate('<+6D>', Start.WeekStartDate));
    //         end;
    //     end;
    //     EmailBody := EmailBody + '<table style="width:100%;border:1px solid black;">';
    //     EmailBody := EmailBody + '<tr>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">Date</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">Present Hours</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">Logged Hours</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">Day</th>';
    //     EmailBody := EmailBody + '</tr>';
    //     EmailBody := EmailBody + '<tr>';
    //     EmailBody := EmailBody + '<td style="border:1px solid black; text-align:center;"><b>' + Day1 + '</b></td>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">8H 12M</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">8H 0M</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">Working Day</th>';
    //     EmailBody := EmailBody + '</tr>';
    //     EmailBody := EmailBody + '<tr>';
    //     EmailBody := EmailBody + '<td style="border:1px solid black;text-align:center;"><b>' + Day2 + '</b></td>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">8H 25M</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">8H 15M</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">Working Day</th>';
    //     EmailBody := EmailBody + '</tr>';
    //     EmailBody := EmailBody + '<tr>';
    //     EmailBody := EmailBody + '<td style="border:1px solid black;text-align:center;"><b>' + Day3 + '</b></td>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">8H 30M</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">8H 20M</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">Working Day</th>';
    //     EmailBody := EmailBody + '</tr>';
    //     EmailBody := EmailBody + '<tr>';
    //     EmailBody := EmailBody + '<td style="border:1px solid black;text-align:center;"><b>' + Day4 + '</b></td>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">8H 15M</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">8H 0M</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">Working Day</th>';
    //     EmailBody := EmailBody + '</tr>';
    //     EmailBody := EmailBody + '<tr>';
    //     EmailBody := EmailBody + '<td style="border:1px solid black;text-align:center;"><b>' + Day5 + '</b></td>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">8H 20M</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">8H 10M</th>';
    //     EmailBody := EmailBody + '<th style="border:1px solid black;">Working Day</th>';
    //     EmailBody := EmailBody + '</tr>';
    //     EmailBody := EmailBody + '</table>';
    // end;
    procedure GetTableforLineofEmail(Start: Record WeeklyTimeSheet; var EmailBody: Text)
    var
        i, J : Integer;
        Day: Date;
        StartDate, EndDate : text;
    begin

        i := Start.WeekEndDate - Start.WeekStartDate;
        StartDate := Format(Start.WeekStartDate);
        StartDate := Format(Start.WeekEndDate);
        EmailBody := EmailBody + '<table style="width:100%;border:1px solid black;">';
        EmailBody := EmailBody + '<tr>';
        EmailBody := EmailBody + '<th style="border:1px solid black;">Date</th>';
        EmailBody := EmailBody + '<th style="border:1px solid black;">Present Hours</th>';
        EmailBody := EmailBody + '<th style="border:1px solid black;">Logged Hours</th>';
        EmailBody := EmailBody + '<th style="border:1px solid black;">Day</th>';
        EmailBody := EmailBody + '</tr>';
        for J := 0 to i do begin
            Start.WeekStartDate := Start.WeekStartDate;
            EmailBody := EmailBody + '<tr>';
            EmailBody := EmailBody + '<td style="border:1px solid black; text-align:center;"><b>' + Format(Start.WeekStartDate) + '</b></td>';
            EmailBody := EmailBody + '<th style="border:1px solid black;">8H 12M</th>';
            EmailBody := EmailBody + '<th style="border:1px solid black;">8H 0M</th>';
            EmailBody := EmailBody + '<th style="border:1px solid black;">Working Day</th>';
            EmailBody := EmailBody + '</tr>';
            Start.WeekStartDate := CalcDate('<+1D>', Start.WeekStartDate);
        end;
        EmailBody := EmailBody + '</table>';
    end;
}
