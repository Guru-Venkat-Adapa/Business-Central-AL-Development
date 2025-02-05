codeunit 50200 "User Login Check"
{
    //  Subtype = EventSubscriber;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company Triggers", 'OnCompanyOpen', '', false, false)]
    // local procedure DenySpecificUserLogin()
    // var
    //     IPAddress: Record "IP Address Data";
    //     user: Record User;
    //     UserIpAddress: Text[50];
    //     userId: Text;
    //     check: Boolean;
    // begin
    //     userId := Database.UserId;
    //     UserIpAddress := getIP();
    //     if user.Get(userId) then begin
    //         IPAddress.SetRange("User ID", user."User Name");
    //         if IPAddress.FindSet() then
    //             repeat
    //                 if IPAddress."IP Address" = UserIpAddress then

    //             until IPAddress.Next() = 0;
    //         // Message(getIP());
    //     end;
    // end;

    // procedure getIP(): Text
    // var
    //     url: Text;
    //     HttpClient: HttpClient;
    //     RequestMessage: HttpRequestMessage;
    //     ResponseMessage: HttpResponseMessage;
    //     Response: Text;
    // begin
    //     url := 'https://api.ipify.org';
    //     RequestMessage.SetRequestUri(Url);
    //     RequestMessage.Method('GET');
    //     if HttpClient.Send(RequestMessage, ResponseMessage) then begin
    //         ResponseMessage.Content.ReadAs(Response);
    //         if not ResponseMessage.IsSuccessStatusCode then
    //             exit;

    //         exit(Response);
    //     end;
    // end;

    // var
    //     test: Record "Access Control";
    //     pageu: Page "User Subform";

}
