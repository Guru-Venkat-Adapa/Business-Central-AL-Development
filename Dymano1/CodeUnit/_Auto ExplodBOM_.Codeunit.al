codeunit 50111 "Auto ExplodBOM"
{
    trigger OnRun()
    begin
        ExplodeBOM();
    end;
    procedure ExplodeBOM()
    begin
        SalesHeader.Reset();
        SalesHeader.SetFilter("Shpfy Order Id", '<>%1', 0);
        SalesHeader.SetRange(SalesHeader.Status, SalesHeader.Status::Open);
        IF SalesHeader.FindSet()then repeat SalesLine.Reset();
                SalesLine.SetRange(SalesLine."Document No.", SalesHeader."No.");
                SalesLine.SetRange(SalesLine.Type, SalesLine.Type::Item);
                if SalesLine.FindSet()then repeat FromBOMComp.Reset();
                        FromBOMComp.SetRange("Parent Item No.", SalesLine."No.");
                        IF FromBOMComp.Count > 0 then IF CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", SalesLine)then;
                    until SalesLine.Next() = 0;
            until SalesHeader.Next() = 0;
    end;
    //++ TimeLine Changes
    procedure GetTimeLine(ShopifyOrderId: Text)NoteList: List of[Text];
    var
        Baseurl: Label 'https://dynamobc.myshopify.com/admin/api/2024-07/graphql.json';
        query: Text;
        accesTOken: Label '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';
        HttpClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        ContentHeaders: HttpHeaders;
        HttpContent: HttpContent;
        Response: Text;
        JsonToken: JsonToken;
    begin
        query:='query Order{order(id: "gid://shopify/Order/' + ShopifyOrderId + '") {events(first: 250) {edges {node {id message ... on BasicEvent {id message } ... on CommentEvent { id message } } } } } }';
        RequestMessage.SetRequestUri(Baseurl);
        RequestMessage.Method('POST');
        HttpContent.WriteFrom(query);
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/graphql');
        ContentHeaders.Add('X-Shopify-Access-Token', accesTOken);
        HttpContent.GetHeaders(ContentHeaders);
        RequestMessage.Content(HttpContent);
        if HttpClient.Send(RequestMessage, ResponseMessage)then begin
            ResponseMessage.Content.ReadAs(Response);
            if ResponseMessage.IsSuccessStatusCode then begin
                // Message(Response);
                if not JsonToken.ReadFrom(Response)then Error('Invalid JSon Object');
                GetListofMessagesorShopifyOrder(JsonToken, NoteList);
            end;
        end;
    end;
    procedure GetListofMessagesorShopifyOrder(var JsonToken: JsonToken; var MessageList: LIst of[Text])
    var
        JsonObject: JsonObject;
        JsonObject2: JsonObject;
        JsonObject3: JsonObject;
        JToken: JsonToken;
        MeesageToken: JsonToken;
        JsonArray: JsonArray;
        JsonValue: JsonValue;
        Messages: JsonObject;
        nodeToken: JsonToken;
    begin
        JsonObject:=JsonToken.AsObject();
        if JsonObject.Get('data', JToken)then JsonObject2:=JToken.AsObject();
        Clear(JsonObject);
        Clear(JToken);
        if JsonObject2.Get('order', JToken)then JsonObject:=JToken.AsObject();
        Clear(JToken);
        if JsonObject.Get('events', JToken)then JsonObject3:=JToken.AsObject();
        Clear(JToken);
        if JsonObject3.Get('edges', JToken)then JsonArray:=JToken.AsArray();
        foreach Jtoken in JsonArray do begin
            Clear(JsonObject);
            JsonObject:=JToken.AsObject();
            if JsonObject.Get('node', nodeToken)then begin
                if nodeToken.IsObject then begin
                    Messages:=nodeToken.AsObject();
                    if Messages.Get('message', MeesageToken)then MessageList.Add(MeesageToken.AsValue().AsText());
                //Message(MeesageToken.AsValue().AsText());
                end;
            end;
        end;
    end;
    //--TimeLine Changes
    var SalesHeader: Record "Sales Header";
    SalesLine: Record "Sales Line";
    FromBOMComp: Record "BOM Component";
    Item: Record 27;
}
