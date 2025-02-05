codeunit 50101 Apidata
{
    procedure GetTrackingDetails()
    Var
        client: HttpClient;
        cont: HttpContent;
        header: HttpHeaders;
        response: HttpResponseMessage;
        tmpString: Text;
        // Jobject: JsonObject;
        // TypeHelper: Codeunit "Type Helper";
        // granttype: text;
        // clienid: text;
        // username: text;
        // password: text;
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
        Message(InputText);
    end;

    procedure WriteTable(var Table: Record "API Table"): Text
    var
        JsonBuilder: Codeunit "JSON Builder";
        Json: Record "API Table";
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        BodyText: Text;
        ResponseText: Text;
        Html: Text;
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        i: Integer;
        HtmlParser: Codeunit "HTML Parser";
        CellContent: Text;
        JsonText: Text;
        // FirstRowSkipped: Boolean;
        RowCounter: Integer;
        DateText: Text;
        DateValue: Date;
        TimeText: Text;
        TimeValue: Time;
        SRSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        Clear(BodyText);
        Clear(HttpContent);
        Clear(HttpClient);
        Clear(HttpHeaders);
        Clear(HttpRequestMessage);
        Clear(HttpResponseMessage);
        // Set headers and request content
        // BodyText := 'User=tntcct&Password=qkLb8f9FR1&Con=TST122145601';
        BodyText := Table.Credential;
        HttpContent.WriteFrom(BodyText);
        HttpContent.ReadAs(BodyText);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Add('charset', 'UTF-8');
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        // HttpClient.Post('https://uat.tntexpress.com.au/CCT/TrackResultsConPost.asp?User=tntcct&Password=qkLb8f9FR1', HttpContent, HttpResponseMessage);
        HttpClient.Post(Table.APILink, HttpContent, HttpResponseMessage);

        HttpResponseMessage.Content.ReadAs(ResponseText);
        if HttpResponseMessage.IsSuccessStatusCode then begin
            Html := ResponseText;
            // Initialize JSON builder
            JsonBuilder.WriteStartArray('');
            // Parse HTML response to extract table data
            HtmlParser.Initialize(Html);
            while HtmlParser.NextTag() do
                if HtmlParser.CurrentTag() = 'tr style="height:18px; overflow:hidden;"' then begin
                    RowCounter := 0;
                    JsonBuilder.WriteStartObject();
                    while HtmlParser.NextTag() do begin
                        if HtmlParser.CurrentTag() = '/tr' then
                            break;
                        if HtmlParser.CurrentTag() = 'font class="f4"' then begin
                            HtmlParser.ReadContent(CellContent);
                            //Assigning the values for font class="f4"
                            case RowCounter of
                                0:
                                    JsonBuilder.WriteProperty('Status', CellContent);
                                1:
                                    JsonBuilder.WriteProperty('Date', CellContent);
                                2:
                                    JsonBuilder.WriteProperty('Time', CellContent);
                                3:
                                    JsonBuilder.WriteProperty('Depot', CellContent);
                            end;
                            RowCounter := RowCounter + 1;
                        end;
                    end;
                    JsonBuilder.WriteEndObject();
                end;
            // end;
            JsonBuilder.WriteEndArray();
            JsonBuilder.GetJsonText(JsonText);
            JsonArray.ReadFrom(JsonText);
            SRSetup.Get();
            //for inserting json objct into BC table
            for i := 0 to JsonArray.Count() - 1 do begin
                JsonArray.Get(i, JsonToken);
                JsonObject := JsonToken.AsObject();
                Json.Init();
                // Generate a new ID for each record
                if Json.ID = '' then
                    Json.ID := NoSeriesMgt.GetNextNo(SRSetup."Customer Nos.", WorkDate(), true);
                JsonObject.Get('Status', JsonToken);
                Json.Status := JsonToken.AsValue().AsText();
                if JsonObject.Get('Date', JsonToken) then begin
                    DateText := JsonToken.AsValue().AsText();
                    if Evaluate(DateValue, DateText, 4) then // Assuming format is DMY
                        Json.Date := DateValue
                    else
                        Json.Date := 0D;
                end;
                if JsonObject.Get('Time', JsonToken) then begin
                    TimeText := JsonToken.AsValue().AsText();
                    if Evaluate(TimeValue, TimeText, 3) then // Adjust format as needed
                        Json.Time := TimeValue
                    else
                        Json.Time := 0T; // Assign a default time or handle error
                end;
                JsonObject.Get('Depot', JsonToken);
                Json.Depot := JsonToken.AsValue().AsText();

                if not Table.Get(Json.ID) then begin
                    Json.Insert(true);
                    Clear(Json.ID);
                end else
                    Message('Record %1 already exists', Json.ID);
            end;
        end else begin
            Error('Something went wrong. Web service returned the following error: Status Code: %1, Description: %2', HttpResponseMessage.HttpStatusCode, HttpResponseMessage.ReasonPhrase);
        end;
    end;

    procedure GETXMLData(var Table: Record "API Table"): Text
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        BodyText: Text;
        ResponseText: Text;
        Html: Text;
        JsonBuilder: Codeunit "JSON Builder";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        i: Integer;
        Json: Record "API Table";
        HtmlParser: Codeunit "HTML Parser";
        CellContent: Text;
        JsonText: Text;
        FirstRowSkipped: Boolean;
        RowCounter: Integer;
        DateText: Text;
        DateValue: Date;
        TimeText: Text;
        TimeValue: Time;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SRSetup: Record "Sales & Receivables Setup";
    begin
        Clear(BodyText);
        Clear(HttpContent);
        Clear(HttpClient);
        Clear(HttpHeaders);
        Clear(HttpRequestMessage);
        Clear(HttpResponseMessage);

        HttpClient.Post('http://www.tntexpress.com.au/link/Cnmhx2.asp?196787774', HttpContent, HttpResponseMessage);

        HttpResponseMessage.Content.ReadAs(ResponseText);
        // Message(ResponseText);
        if HttpResponseMessage.IsSuccessStatusCode then begin
            Html := ResponseText;
            // Initialize JSON builder
            JsonBuilder.WriteStartArray('');
            // Parse HTML response to extract table data
            HtmlParser.Initialize(Html);
            while HtmlParser.NextTag() do
                if HtmlParser.CurrentTag() = 'status' then begin
                    // RowCounter := 0;
                    JsonBuilder.WriteStartObject();
                    while HtmlParser.NextTag() do begin
                        if HtmlParser.CurrentTag() = '/status' then
                            break;
                        if HtmlParser.CurrentTag() = 'statusCode' then begin
                            HtmlParser.ReadContent(CellContent);
                            JsonBuilder.WriteProperty('statusCode', CellContent);
                        end;
                        if HtmlParser.CurrentTag() = 'statusDescription' then begin
                            HtmlParser.ReadContent(CellContent);
                            JsonBuilder.WriteProperty('statusDescription', CellContent);
                        end;
                        if HtmlParser.CurrentTag() = 'date' then begin
                            HtmlParser.ReadContent(CellContent);
                            JsonBuilder.WriteProperty('date', CellContent);
                        end;
                        if HtmlParser.CurrentTag() = 'time' then begin
                            HtmlParser.ReadContent(CellContent);
                            JsonBuilder.WriteProperty('time', CellContent);
                        end;
                        if HtmlParser.CurrentTag() = 'depotName' then begin
                            HtmlParser.ReadContent(CellContent);
                            JsonBuilder.WriteProperty('depotName', CellContent);
                        end;
                    end;
                    JsonBuilder.WriteEndObject();
                end;
            // end;
            JsonBuilder.WriteEndArray();
            JsonBuilder.GetJsonText(JsonText);
            JsonArray.ReadFrom(JsonText);
            SRSetup.Get();
            //for inserting json objct into BC table
            for i := 0 to JsonArray.Count() - 1 do begin
                JsonArray.Get(i, JsonToken);
                JsonObject := JsonToken.AsObject();
                Json.Init();
                // Generate a new ID for each record
                if Json.ID = '' then
                    Json.ID := NoSeriesMgt.GetNextNo(SRSetup."Customer Nos.", WorkDate(), true);
                JsonObject.Get('statusCode', JsonToken);
                Json.statusCode := JsonToken.AsValue().AsText();
                JsonObject.Get('statusDescription', JsonToken);
                Json.Status := JsonToken.AsValue().AsText();
                if JsonObject.Get('Date', JsonToken) then begin
                    DateText := JsonToken.AsValue().AsText();
                    if Evaluate(DateValue, DateText, 4) then // Assuming format is DMY
                        Json.Date := DateValue
                    else
                        Json.Date := 0D;
                end;
                if JsonObject.Get('Time', JsonToken) then begin
                    TimeText := JsonToken.AsValue().AsText();
                    if Evaluate(TimeValue, TimeText, 3) then // Adjust format as needed
                        Json.Time := TimeValue
                    else
                        Json.Time := 0T; // Assign a default time or handle error
                end;
                JsonObject.Get('Depot', JsonToken);
                Json.Depot := JsonToken.AsValue().AsText();

                if not Table.Get(Json.ID) then begin
                    Json.Insert(true);
                    Clear(Json.ID);
                end else
                    Message('Record %1 already exists', Json.ID);
            end;
        end else
            Error('Something went wrong. Web service returned the following error: Status Code: %1, Description: %2', HttpResponseMessage.HttpStatusCode, HttpResponseMessage.ReasonPhrase);
        // end;
    end;
}