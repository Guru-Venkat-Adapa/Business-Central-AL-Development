codeunit 50110 "Event Managment"
{
    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Order);
        If SalesHeader.FindSet()then repeat SendDeliveryStatus(SalesHeader);
            until SalesHeader.Next() = 0;
    end;
    procedure SendOrderConfirmation(Rec: Record "Sales Header")
    var
        Customer: Record Customer;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        RecieverMail: List of[Text];
        TempBlob: Codeunit "Temp Blob";
        Base64: Codeunit "Base64 Convert";
        Istream: InStream;
        OStream: OutStream;
        Recref: RecordRef;
        SalesHeader: Record "Sales Header";
        MailDescription: Text;
        Attachment: Text;
        FldRef: FieldRef;
    begin
        Customer.Get(Rec."Sell-to Customer No.");
        //RecieverMail.Add(Customer."E-Mail");
        RecieverMail.Add('Satish.s@shaligraminfotech.com');
        Subject:='Order Reference Number: ' + Rec."No." + ' Confirmation';
        if SalesHeader.Get(Rec."Document Type", Rec."No.")then begin
            Recref.GetTable(SalesHeader);
            FldRef:=Recref.Field(SalesHeader.FieldNo("No."));
            FldRef.SetRange(SalesHeader."No.");
            if Recref.FindFirst()then begin
                Clear(TempBlob);
                TempBlob.CreateOutStream(OStream);
                Report.SaveAs(Report::"Order Confirmation", '', ReportFormat::Html, OStream, Recref);
                TempBlob.CreateInStream(Istream);
                Istream.ReadText(Body);
                //MailDescription := 'Hello ' + Rec."Sell-to Customer Name" + ',' + '<BR> <BR>' + 'Thank you for your business. Your order confirmation is attached to this message.' + '<BR> <BR>';
                EmailMessage.Create(RecieverMail, Subject, '', true);
                EmailMessage.AppendToBody(MailDescription);
                EmailMessage.AppendToBody(Body);
                Clear(TempBlob);
                TempBlob.CreateOutStream(OStream);
                Report.SaveAs(Report::"Order Confirmation", '', ReportFormat::Pdf, OStream, Recref);
                TempBlob.CreateInStream(Istream);
                Attachment:=CompanyName + ' - ' + ' Sales Quote ' + Rec."No." + '.pdf';
                EmailMessage.AddAttachment(Attachment, 'application/pdf', Base64.ToBase64(Istream));
                Email.OpenInEditor(EmailMessage);
            end;
        end;
    end;
    procedure AddEmailBodyLines(SalesHdr: Record "Sales Header"; var EmailBody: Text)
    var
        PurchaseLine: Record "Sales Line";
        BodyFormat1: Label '<th style="width:50%;border:2px solid black;">';
    begin
        PurchaseLine.SetRange("Document Type", SalesHdr."Document Type");
        PurchaseLine.SetRange("Document No.", SalesHdr."No.");
        if PurchaseLine.FindSet()then begin
            EmailBody:='<table style="width:50%;border:2px solid black;">';
            EmailBody:=EmailBody + '<tr>';
            EmailBody:=EmailBody + '<tr>';
            EmailBody:=EmailBody + BodyFormat1 + 'Customer No.</th>';
            EmailBody:=EmailBody + BodyFormat1 + 'Order No</th>';
            EmailBody:=EmailBody + BodyFormat1 + 'Delivery Status</th>';
            EmailBody:=EmailBody + BodyFormat1 + 'Date</th>';
            EmailBody:=EmailBody + '</tr>';
            EmailBody:=EmailBody + '<tr>';
            EmailBody:=EmailBody + BodyFormat1 + SalesHdr."Sell-to Customer No." + '</th>';
            EmailBody:=EmailBody + BodyFormat1 + SalesHdr."No." + '</th>';
            EmailBody:=EmailBody + BodyFormat1 + 'Delivered' + '</th>';
            EmailBody:=EmailBody + BodyFormat1 + Format(Today) + '</th>';
            EmailBody:=EmailBody + '</tr>';
            EmailBody:=EmailBody + BodyFormat1 + 'Item No</th>';
            EmailBody:=EmailBody + BodyFormat1 + 'Description</th>';
            EmailBody:=EmailBody + BodyFormat1 + 'Quantity</th>';
            EmailBody:=EmailBody + BodyFormat1 + 'Qty. To Receive</th>';
            EmailBody:=EmailBody + '</tr>';
            repeat EmailBody:=EmailBody + '<tr>';
                EmailBody:=EmailBody + BodyFormat1 + PurchaseLine."No." + '</th>';
                EmailBody:=EmailBody + BodyFormat1 + PurchaseLine.Description + '</th>';
                EmailBody:=EmailBody + BodyFormat1 + Format(PurchaseLine.Quantity) + '</th>';
                EmailBody:=EmailBody + BodyFormat1 + Format(PurchaseLine."Amount Including VAT") + '</th>';
                EmailBody:=EmailBody + '</tr>';
            until(PurchaseLine.Next() = 0);
            EmailBody:=EmailBody + '</table>';
            EmailBody:=EmailBody + '</br></br>';
        end;
    end;
    procedure SendDeliveryStatus(var Rec: Record "Sales Header")
    var
        Customer: Record Customer;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        RecieverMail: List of[Text];
        TempBlob: Codeunit "Temp Blob";
        Base64: Codeunit "Base64 Convert";
        Istream: InStream;
        OStream: OutStream;
        Recref: RecordRef;
        SalesHeader: Record "Sales Header";
        MailDescription: Text;
        Attachment: Text;
        FldRef: FieldRef;
        TrackPage: Page "Order Tracking Dialog";
        DownloadURl: Text;
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        TrackNo: Text;
    begin
        Customer.Get(Rec."Sell-to Customer No.");
        //RecieverMail.Add(Customer."E-Mail");
        RecieverMail.Add('Satish.s@shaligraminfotech.com');
        Subject:='Order Number: ' + Rec."No." + ' Has been Delivered';
        if SalesHeader.Get(Rec."Document Type", Rec."No.")then begin
            Recref.GetTable(SalesHeader);
            FldRef:=Recref.Field(SalesHeader.FieldNo("No."));
            FldRef.SetRange(SalesHeader."No.");
            if Recref.FindFirst()then begin
                Clear(TempBlob);
                TempBlob.CreateOutStream(OStream);
                Report.SaveAs(Report::"delivery status", '', ReportFormat::Html, OStream, Recref);
                TempBlob.CreateInStream(Istream);
                Istream.ReadText(Body);
                //MailDescription := 'Hello ' + Rec."Sell-to Customer Name" + ',' + '<BR> <BR>' + 'Thank you for your business. Your order confirmation is attached to this message.' + '<BR> <BR>';
                EmailMessage.Create(RecieverMail, Subject, '', true);
                EmailMessage.AppendToBody(MailDescription);
                EmailMessage.AppendToBody(Body);
                Attachment:=SalesHeader."Tracking reference No." + ' Delevery Document.PDF';
                TrackNo:=SalesHeader."Tracking reference No.";
                Client.Get(TrackPage.Mainfreight(TrackNo, true), Response);
                Response.Content.ReadAs(Istream);
                //Attachment := CompanyName + ' - ' + ' Sales Quote ' + Rec."No." + '.pdf';
                EmailMessage.AddAttachment(Attachment, 'application/pdf', Base64.ToBase64(Istream));
                Email.OpenInEditor(EmailMessage);
            end;
        end;
    end;
    procedure Mainfreight(): Text var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        BodyText: Text;
        ResponseText: Text;
        JsonArray: JsonArray;
        FoundjsonArray: JsonArray;
        JsonToken: JsonToken;
        jsonObject: jsonObject;
        FoundJsonToken: JsonToken;
        FoundJsonObject: JsonObject;
        RelatedItemJsonObject: JsonObject;
        TracSetup: Record "Tracking Setup";
    begin
        TracSetup.GET();
        Clear(BodyText);
        Clear(HttpContent);
        Clear(HttpClient);
        Clear(HttpHeaders);
        Clear(HttpRequestMessage);
        Clear(HttpResponseMessage);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Clear();
        // HttpHeaders.Add('Accept', 'text/html');
        HttpHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        HttpContent.WriteFrom('User=tntcct&Password=qkLb8f9FR1&Con=TST122145601');
        HttpRequestMessage.Content:=HttpContent;
        HttpRequestMessage.GetHeaders(HttpHeaders);
        //HttpHeaders.Add('Authorization', 'Secret ngD11nhMn3NxZ-09k9RuZFI89ceREpdL_1biH5OGgRrNZBa81RT9EJiu4jr5gp4IlCkTOYBlLGXm880UwMfvbGH-7xP3Dr8WOgErrL9tWUuSAlCqrHrcMkh-t3SOIEy6kWYvxMX63EFSgdysrzQGBN__nxI-ft7PA3UEKkw3z98Z515hC8cpF9FqwE4E37KGKGcP7_yR6_OEFq9BLnwSKg2');
        // HttpHeaders.Add('Authorization', TracSetup."Mainfrieght API Key");
        //HttpRequestMessage.SetRequestUri('https://api.mainfreight.com/Tracking/1.1/References?serviceType=TransportAU&reference=' + Tracking_No);
        //HttpRequestMessage.
        HttpRequestMessage.SetRequestUri('https://uat.tntexpress.com.au/CCT/TrackResultsConPost.asp');
        HttpRequestMessage.Method:='POST';
        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);
        HttpResponseMessage.Content().ReadAs(responseText);
        if not HttpResponseMessage.IsSuccessStatusCode then Error('Something went wrong, Web service return following error:,\\' + 'Status Code: %1\' + 'Description: %2', HttpResponseMessage.HttpStatusCode, HttpResponseMessage.ReasonPhrase);
    end;
    procedure MyProcedure()
    var
        myInt: Integer;
        Gpt_JsonObject_L: JsonObject;
        Gpt_JsonText_L: Text;
        Content: HttpContent;
        Client: HttpClient;
        Headers: HttpHeaders;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        JSONResponse: Text;
        JObject: JsonObject;
    begin
        // Gpt_JsonObject_L.Add('model', 'text-davinci-003');
        // Gpt_JsonObject_L.Add('prompt', 'how are you?');
        // Gpt_JsonObject_L.Add('temperature', 0.2);
        //Gpt_JsonObject_L.Add('');
        //Gpt_JsonObject_L.WriteTo(Gpt_JsonText_L);
        Gpt_JsonText_L:='User=tntcct&Password=qkLb8f9FR1&Con=TST122145601';
        Request.Method:='POST';
        Request.SetRequestUri('https://uat.tntexpress.com.au/CCT/TrackResultsConPost.asp');
        Headers.Clear();
        Request.GetHeaders(Headers);
        //Headers.Add('Authorization', 'Bearer ' + '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');
        Content.WriteFrom(Gpt_JsonText_L);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');
        Request.Content:=Content;
        if not Client.Send(Request, Response)then Error('API Authorization token request failed...');
        JSONResponse:='';
        Response.Content().ReadAs(JSONResponse);
        if not JObject.ReadFrom(JSONResponse)then Error('Invalid response, expected a JSON object');
        Message(JSONResponse);
    end;
    procedure GetToken()ResponseText: text;
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
    Begin
        tmpString:='User=tntcct&Password=qkLb8f9FR1&Con=TST122145601';
        cont.WriteFrom(tmpString);
        cont.ReadAs(tmpString);
        cont.GetHeaders(header);
        header.Add('charset', 'UTF-8');
        header.Remove('Content-Type');
        header.Add('Content-Type', 'application/x-www-form-urlencoded');
        client.Post('https://uat.tntexpress.com.au/CCT/TrackResultsConPost.asp?User=tntcct&Password=qkLb8f9FR1', cont, response);
        response.Content.ReadAs(ResponseText);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Explode BOM", 'OnInsertOfExplodedBOMLineToSalesLine', '', false, false)]
    local procedure OnInsertOfExplodedBOMLineToSalesLine(var ToSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line"; BOMComponent: Record "BOM Component"; var SalesHeader: Record "Sales Header"; LineSpacing: Integer)
    begin
        ToSalesLine.Validate("Shpfy Order No.", SalesLine."Shpfy Order No.");
        ToSalesLine.Validate("Shpfy Order Line Id", SalesLine."Shpfy Order Line Id");
        ToSalesLine.Validate("Line Discount %", BOMComponent."Discount %");
    //ToSalesLine.Modify();
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Explode BOM", 'OnBeforeConfirmExplosion', '', false, false)]
    local procedure OnBeforeConfirmExplosion(var SalesLine: Record "Sales Line"; var Selection: Integer; var HideDialog: Boolean; var NoOfBOMComp: Integer)
    begin
        HideDialog:=true;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues(var SalesLine: Record "Sales Line"; Item: Record Item; SalesHeader: Record "Sales Header"; var xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    begin
        SalesLine."Item Margins":=Item."Profit %";
    end;
    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    // local procedure OnAfterValidateEventQuantity(var Rec: Record "Sales Line")
    // var
    //     Item: Record Item;
    // begin
    //     //Commit();
    //     IF Item.Get(Rec."No.") THEN;
    //     Item.CalcFields("Assembly BOM");
    //     IF (Rec."Document Type" = Rec."Document Type"::Order) AND (Rec.Quantity <> 0) and (Item."Assembly BOM") then
    //         IF GuiAllowed then begin
    //             if Rec."Prepmt. Amt. Inv." <> 0 then
    //                 Error(Text001);
    //             CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
    //             DocumentTotals.SalesDocTotalsNotUpToDate();
    //         end;
    //     Commit();
    // end;
    [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", 'OnAfterQuantityOnAfterValidate', '', false, false)]
    local procedure OnAfterQuantityOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    var
        Item: Record Item;
    begin
    // SalesLine."Explode Bundle" := true;
    // IF Item.Get(SalesLine."No.") THEN;
    // Item.CalcFields("Assembly BOM");
    // IF (SalesLine.Quantity <> 0) and (Item."Assembly BOM") then
    //     IF GuiAllowed then begin
    //         if SalesLine."Prepmt. Amt. Inv." <> 0 then
    //             Error(Text001);
    //         CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", SalesLine);
    //         DocumentTotals.SalesDocTotalsNotUpToDate();
    //     end;
    end;
    var DocumentTotals: Codeunit "Document Totals";
    Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
    Test: Record "Tracking Setup";
    abc: Page "Purchase Order";
}
