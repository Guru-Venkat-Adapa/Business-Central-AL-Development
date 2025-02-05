codeunit 50102 "HTML Parser"
{
    var
        HtmlContent: Text;
        CurrentPosition: Integer;
        CurrentTagText: Text;
        CurrentIndex: Integer;
    //resets the position variables used to track the current position within the HTML content during parsing.
    procedure Initialize(Html: Text)
    begin
        HtmlContent := Html;
        CurrentPosition := 1;
        CurrentIndex := 0;
    end;
    //for finding the next tags i.e. < or >
    procedure NextTag(): Boolean
    var
        StartPos: Integer;
        EndPos: Integer;
    begin
        StartPos := StrPos(HtmlContent, '<');
        if StartPos = 0 then begin
            exit(false);
        end;

        EndPos := StrPos(CopyStr(HtmlContent, StartPos + 1), '>') + StartPos;
        if EndPos <= StartPos then begin
            exit(false);
        end;

        CurrentTagText := CopyStr(HtmlContent, StartPos + 1, EndPos - StartPos - 1);
        CurrentPosition := EndPos + 1;
        HtmlContent := CopyStr(HtmlContent, EndPos + 1);
        exit(true);
    end;
    //to return current tag
    procedure CurrentTag(): Text
    begin
        exit(CurrentTagText);
    end;
    //used to return the value of the content from html format
    procedure ReadContent(var Content: Text)
    var
        StartPos: Integer;
        EndPos: Integer;
    begin
        StartPos := 1;
        EndPos := StrPos(HtmlContent, '<');

        if EndPos = 0 then begin
            Content := CopyStr(HtmlContent, StartPos);
            CurrentPosition := StrLen(HtmlContent) + 1;
        end else begin
            Content := CopyStr(HtmlContent, StartPos, EndPos - 1);
            CurrentPosition := EndPos;
        end;

        HtmlContent := CopyStr(HtmlContent, EndPos);
        CurrentIndex += 1;
    end;
}
