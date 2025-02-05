page 50102 FetchingHtmlTable
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Fetching Html Table(API)';
    layout
    {
        area(Content)
        {
            usercontrol(demo; "image import")
            {
                ApplicationArea = all;
                Visible = true;
                // trigger Ready()
                // var
                //     input: Text;
                // begin
                //     input := GetTrackingDetails();
                //     CurrPage.demo.Initializeimage(input);
                // end;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GetTable)
            {
                ApplicationArea = All;
                Caption = 'Get Html Table';
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    input: Text;
                begin
                    input := GetTrackingDetails();
                    CurrPage.demo.Initializeimage(input);
                end;

            }
        }
    }

    var
        myInt: Integer;


    procedure GetTrackingDetails(): Text
    Var
        client: HttpClient;
        cont: HttpContent;
        header: HttpHeaders;
        response: HttpResponseMessage;
        Jobject: JsonObject;
        tmpString: Text;
        TypeHelper: Codeunit "Type Helper";
        granttype: text;
        clienid: text;
        username: text;
        password: text;
        InputText: Text;
    Begin
        tmpString := 'User=tntcct&Password=qkLb8f9FR1&Con=TST122145601';
        cont.WriteFrom(tmpString);
        cont.ReadAs(tmpString);
        cont.GetHeaders(header);
        header.Add('charset', 'UTF-8');
        header.Remove('Content-Type');
        header.Add('Content-Type', 'application/x-www-form-urlencoded');
        client.Post('https://uat.tntexpress.com.au/CCT/TrackResultsConPost.asp?User=tntcct&Password=qkLb8f9FR1', cont, response);
        response.Content.ReadAs(InputText);
        exit(InputText);
    end;
}