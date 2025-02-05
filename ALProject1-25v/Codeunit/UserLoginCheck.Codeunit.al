codeunit 50100 "User Login Check"
{

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company Triggers", 'OnCompanyOpen', '', false, false)]
    // local procedure DenySpecificUserLogin()
    // var
    //     IPAddress: Record "IP Address Data";
    //     user: Record User;
    //     UserIpAddress: Text;
    //     userId: Text;
    // // check: Boolean;
    // begin
    //     // userId := Database.UserId;
    //     // UserIpAddress := getIP();
    //     // user.SetRange("User Name", userId);
    //     // if user.FindFirst() then begin
    //     //     IPAddress.SetRange("User ID", user."User Name");
    //     //     IPAddress.SetRange("IP Address", UserIpAddress);
    //     //     if not IPAddress.FindFirst() then
    //     //         // if IPAddress.IsEmpty then
    //     //         Error('The IP addresss is has no permission ');
    //     // end;
    //     // Message(getIP());
    // end;

    procedure getIP(): Text
    var
        url: Text;
        HttpClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Response: Text;
        RequestHeader: HttpHeaders;
    begin
        url := 'https://api.ipify.org';
        RequestMessage.SetRequestUri(Url);
        RequestHeader.Add('Content-Type', 'X-Forwarded-For');
        RequestMessage.Method('GET');
        if HttpClient.Send(RequestMessage, ResponseMessage) then begin
            ResponseMessage.Content.ReadAs(Response);
            if not ResponseMessage.IsSuccessStatusCode then
                exit;

            exit(Response);
        end;
    end;
}
