page 50100 "Order Tracking Dialog"
{
    ApplicationArea = all;
    PageType = API;
    Caption = 'Order Tracking Dialog';
    APIPublisher = 'Shaligram';
    APIGroup = 'OrderTracking';
    APIVersion = 'beta';
    EntityName = 'OrderTracking';
    EntitySetName = 'Orderdetails';
    DelayedInsert = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(OrderInfo)
            {
                Caption = 'Order Information';

                field(OrderNo; OrderNo)
                {
                    ApplicationArea = All;
                    Caption = 'Order No.';
                    Style = Favorable;
                }
                field(CustNo; CustNo)
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                    Style = Favorable;
                }
                field(CustomerName; CustomerName)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    Style = Favorable;
                }
                field(OrderDate; OrderDate)
                {
                    ApplicationArea = All;
                    Caption = 'Order Date';
                    Style = Favorable;
                }
            }
            group(TrackingInfo)
            {
                Caption = 'Tracking Information';

                field(TrackingNo; TrackingNo)
                {
                    ApplicationArea = All;
                    Caption = 'Tracking No.';
                }
                field(CurrDateTime; CurrDateTime)
                {
                    ApplicationArea = All;
                    Caption = 'Current Date & Time';
                }
                field(Status; displayName)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                }
                // field(code; code)
                // {
                //     ApplicationArea = All;
                //     Caption = 'code';
                // }
                field(DeliveryDateTime; eventDateTime)
                {
                    ApplicationArea = All;
                    Caption = 'Delivery Date & Time';
                }
                field(serviceType; serviceType)
                {
                    ApplicationArea = All;
                    Caption = 'Service Type';
                }
                field(Reference; ourReference)
                {
                    ApplicationArea = All;
                    Caption = 'Reference';
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                }
            }
            group(ProofOfdevlevery)
            {
                Caption = 'Proof Of Delivery';

                field(DProof1;'Proof Of Delivery')
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Visible = IsVisible1;
                }
                field(DProof2;'Proof Of Delivery')
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Visible = IsVisible2;
                }
                field(DProof3;'Proof Of Delivery')
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Visible = IsVisible3;
                }
                field(DProof4;'Proof Of Delivery')
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Visible = IsVisible4;
                }
                field(DProof5;'Proof Of Delivery')
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Visible = IsVisible5;
                }
                field(Download1;'Download Document')
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    Visible = IsVisible1;

                    trigger OnDrillDown()
                    begin
                        DownloadProofDocument(ProofOfDeliverValue[1], TrackingNo);
                    end;
                }
                field(Download2;'Download Document')
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    Visible = IsVisible2;

                    trigger OnDrillDown()
                    begin
                        DownloadProofDocument(ProofOfDeliverValue[2], TrackingNo);
                    end;
                }
                field(Download3;'Download Document')
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    Visible = IsVisible3;

                    trigger OnDrillDown()
                    begin
                        DownloadProofDocument(ProofOfDeliverValue[3], TrackingNo);
                    end;
                }
                field(Download4;'Download Document')
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    Visible = IsVisible4;

                    trigger OnDrillDown()
                    begin
                        DownloadProofDocument(ProofOfDeliverValue[4], TrackingNo);
                    end;
                }
                field(Download5;'Download Document')
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    Visible = IsVisible5;

                    trigger OnDrillDown()
                    begin
                        DownloadProofDocument(ProofOfDeliverValue[5], TrackingNo);
                    end;
                }
            }
        }
    }
    procedure SetValue(var DocumentNo: Code[50]; var DocumentType: Enum "Sales Document Type")
    var
        SalesDocument: Record "Sales Header";
    begin
        IF SalesDocument.GET(DocumentType, DocumentNo)then begin
            OrderNo:=SalesDocument."No.";
            CustNo:=SalesDocument."Sell-to Customer No.";
            CustomerName:=SalesDocument."Sell-to Customer Name";
            OrderDate:=SalesDocument."Order Date";
            TrackingNo:=SalesDocument."Tracking reference No.";
            CurrDateTime:=System.CurrentDateTime();
        end;
        if not(TrackingNo = '')then begin
            Mainfreight(TrackingNo, false);
        end
        else
            Error('Tracking No is not Available');
    end;
    procedure SetValue(var DocumentNo: Code[50])
    var
        PostedSalesDocument: Record "Sales Invoice Header";
    begin
        IF PostedSalesDocument.GET(DocumentNo)then begin
            OrderNo:=PostedSalesDocument."No.";
            CustNo:=PostedSalesDocument."Sell-to Customer No.";
            CustomerName:=PostedSalesDocument."Sell-to Customer Name";
            OrderDate:=PostedSalesDocument."Order Date";
            //TrackingNo := PostedSalesDocument."SIT Tracking No";
            CurrDateTime:=System.CurrentDateTime();
        end;
        if not(TrackingNo = '')then begin
            Mainfreight(TrackingNo, false);
        end
        else
            Error('Tracking No is not Available');
    end;
    procedure Mainfreight(var Tracking_No: Text; SendbyPDF: Boolean): Text var
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
        HttpHeaders.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content:=HttpContent;
        HttpRequestMessage.GetHeaders(HttpHeaders);
        //HttpHeaders.Add('Authorization', 'Secret ngD11nhMn3NxZ-09k9RuZFI89ceREpdL_1biH5OGgRrNZBa81RT9EJiu4jr5gp4IlCkTOYBlLGXm880UwMfvbGH-7xP3Dr8WOgErrL9tWUuSAlCqrHrcMkh-t3SOIEy6kWYvxMX63EFSgdysrzQGBN__nxI-ft7PA3UEKkw3z98Z515hC8cpF9FqwE4E37KGKGcP7_yR6_OEFq9BLnwSKg2');
        HttpHeaders.Add('Authorization', TracSetup."Mainfrieght API Key");
        //HttpRequestMessage.SetRequestUri('https://api.mainfreight.com/Tracking/1.1/References?serviceType=TransportAU&reference=' + Tracking_No);
        HttpRequestMessage.SetRequestUri(TracSetup."Mainfrieght URL" + Tracking_No);
        HttpRequestMessage.Method:='GET';
        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);
        HttpResponseMessage.Content().ReadAs(responseText);
        if JsonArray.ReadFrom(ResponseText)then begin
            JsonToken.ReadFrom(ResponseText);
            JsonArray.Get(0, FoundJsonToken);
            FoundJsonObject:=FoundJsonToken.AsObject();
            FoundJsonObject.Get('ourReference', JsonToken);
            ourReference:=JsonToken.AsValue().AsText();
            FoundJsonObject.Get('serviceType', JsonToken);
            serviceType:=JsonToken.AsValue().AsText();
            FoundJsonObject.Get('relatedItems', JsonToken);
            JsonArray:=JsonToken.AsArray();
            foreach JsonToken in JsonArray do begin
                NoofDocument+=1;
                jsonObject:=JsonToken.AsObject();
                jsonObject.Get('value', JsonToken);
                ProofOfDeliverValue[NoofDocument]:=JsonToken.AsValue().AsText();
                IF SendbyPDF then exit(ProofOfDeliverValue[NoofDocument]);
            end;
            FoundJsonObject.Get('events', JsonToken);
            JsonArray:=JsonToken.AsArray();
            JsonArray.Get(0, JsonToken);
            FoundJsonObject:=JsonToken.AsObject();
            FoundJsonObject.Get('eventDateTime', JsonToken);
            eventDateTime:=JsonToken.AsValue().AsText();
            Clear(JsonToken);
            FoundJsonObject.Get('code', JsonToken);
            code:=JsonToken.AsValue().AsText();
            Clear(JsonToken);
            FoundJsonObject.Get('displayName', JsonToken);
            displayName:=JsonToken.AsValue().AsText();
        end;
        if not HttpResponseMessage.IsSuccessStatusCode then Error('Something went wrong, Web service return following error:,\\' + 'Status Code: %1\' + 'Description: %2', HttpResponseMessage.HttpStatusCode, HttpResponseMessage.ReasonPhrase);
    end;
    procedure DownloadProofDocument(DocumentURL: Text; TrackingNo: Text[20])
    var
        Item: Record Item;
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        InStr: InStream;
        FileName: Text;
    begin
        FileName:=TrackingNo + ' Delevery Document.PDF';
        Client.Get(DocumentURL, Response);
        Response.Content.ReadAs(InStr);
        DownloadFromStream(InStr, 'Proof Of Delevery', '', '', FileName)end;
    procedure FieldActivate()i: Integer;
    begin
        for i:=1 to NoofDocument do begin
            IF i = 1 then IsVisible1:=true
            ELSE IF i = 2 then IsVisible2:=true
                ELSE IF i = 3 then IsVisible3:=true
                    ELSE IF i = 4 then IsVisible4:=true
                        ELSE IF i = 5 then IsVisible5:=true end;
    end;
    procedure SendDeliveryStatus(EmailSubject: Text; CustomerNo: Code[20])
    var
        myInt: page 8883;
    begin
        ;
    end;
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        FieldActivate;
    end;
    var DeleveryStatus: Text;
    OrderNo: Code[20];
    CustNo: Code[20];
    CustomerName: Text;
    OrderDate: Date;
    TrackingNo: Text;
    CurrDateTime: DateTime;
    ourReference: Text;
    serviceType: Text;
    eventDateTime: Text;
    code: Text;
    displayName: Text;
    Type: Text;
    ProofOfDeliverType: array[5]of Text[250];
    ProofOfDeliverValue: array[5]of Text[250];
    NoofDocument: Integer;
    IsVisible1: Boolean;
    IsVisible2: Boolean;
    IsVisible3: Boolean;
    IsVisible4: Boolean;
    IsVisible5: Boolean;
}
