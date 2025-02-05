codeunit 50100 DemoJsonData
{
    procedure ReadApiJsonData()
    var
        Client: HttpClient;
        Res: HttpResponseMessage;
        Content: HttpContent;
        Output: Text;
    begin
        Client.Get('https://jsonplaceholder.typicode.com/users', Res);
        if Res.IsSuccessStatusCode then
            Content := Res.Content
        else
            Message('found errors %1,%2', Res.HttpStatusCode, Res.ReasonPhrase);
        Content.ReadAs(Output);
        Message(Output);
    end;

    procedure WritepiJsonData(var Data: Record Demojsontable)
    var
        Client: HttpClient;
        Res: HttpResponseMessage;
        Content: HttpContent;
        Output: Text;
        Jobj: JsonObject;
        Jtoken: JsonToken;
        Childoutput: Text;
        ChildJobj: JsonObject;
        ChildJtoken: JsonToken;
    begin
        Client.Get('https://jsonplaceholder.typicode.com/users/' + Format(Data.id), Res);
        if Res.IsSuccessStatusCode then begin
            Content := Res.Content;
            Content.ReadAs(Output);
            Jobj.ReadFrom(Output);
            Jobj.Get('name', Jtoken);
            Data.Name := Jtoken.AsValue().AsText();
            Jobj.Get('username', Jtoken);
            Data.Username := Jtoken.AsValue().AsText();
            Jobj.Get('email', Jtoken);
            Data.Email := Jtoken.AsValue().AsText();
            Jobj.Get('phone', Jtoken);
            Data.Phno := Jtoken.AsValue().AsText();
            Jobj.Get('address', Jtoken);

            if Jtoken.IsObject then begin
                Jtoken.WriteTo(Childoutput);
                ChildJobj.ReadFrom(Childoutput);
                ChildJobj.get('street', ChildJtoken);
                Data.Street := ChildJtoken.AsValue().AsText();
                ChildJobj.get('city', ChildJtoken);
                Data.City := ChildJtoken.AsValue().AsText();
                ChildJobj.get('zipcode', ChildJtoken);
                Data.Pincode := ChildJtoken.AsValue().AsText();
            end;
        end
        else
            Message('found errors %1,%2', Res.HttpStatusCode, Res.ReasonPhrase);
    end;

    procedure WriteAllData(var table: Record Demojsontable)
    var
        jsonMang: Codeunit "JSON Management";
        ArrayJSONManagement: Codeunit "JSON Management";
        httpClient: HttpClient;
        response: HttpResponseMessage;
        content: HttpContent;
        Result: Text;
        jsonObject: JsonObject;
        Jsontemp: Text;
        Jsontoken: JsonToken;
        i: integer;
        json: Record Demojsontable;
        AddressObject: JsonObject;
        addressJson: JsonToken;
        address: Text;
    begin
        httpClient.Get('https://jsonplaceholder.typicode.com/users', response);
        if response.IsSuccessStatusCode then begin
            content := response.Content;
            content.ReadAs(Result);
            ArrayJSONManagement.InitializeCollection(Result);
            for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
                ArrayJSONManagement.GetObjectFromCollectionByIndex(Jsontemp, i);
                jsonMang.InitializeObject(Jsontemp);
                jsonObject.ReadFrom(Jsontemp);
                json.Init();
                jsonObject.Get('id', Jsontoken);
                json.id := Jsontoken.AsValue().AsInteger();
                jsonObject.Get('name', Jsontoken);
                json.name := Jsontoken.AsValue().AsText();
                jsonObject.Get('username', Jsontoken);
                json.username := Jsontoken.AsValue().AsText();
                jsonObject.Get('email', Jsontoken);
                json.Email := Jsontoken.AsValue().AsText();
                jsonObject.Get('phone', Jsontoken);
                Json.Phno := Jsontoken.AsValue().AsText();

                jsonObject.Get('address', Jsontoken);
                if Jsontoken.IsObject then begin
                    Jsontoken.WriteTo(address);
                    AddressObject.ReadFrom(address);
                    AddressObject.Get('street', addressJson);
                    json.Street := addressJson.AsValue().AsText();
                    // address := Jsontoken.AsValue().AsText();
                    AddressObject.Get('city', addressJson);
                    json.City := addressJson.AsValue().AsText();
                    // address += ' ,' + Jsontoken.AsValue().AsText();
                    AddressObject.Get('zipcode', addressJson);
                    json.Pincode := addressJson.AsValue().AsText();
                end;
                // address += ' ,' + Jsontoken.AsValue().AsText();
                // json.address := address;
                if not table.Get(json.id) then begin
                    json.Insert();
                end else
                    Message('Record %1 already exists', json.id);
            end;
        end else begin
            Message('%1', response.HttpStatusCode);
        end;

    end;

}