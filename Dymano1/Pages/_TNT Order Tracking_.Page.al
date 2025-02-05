page 50106 "TNT Order Tracking"
{
    PageType = API;
    Caption = 'TNT Order Tracking';
    APIPublisher = 'Shaligram';
    APIGroup = 'app1';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'customer';
    EntitySetName = 'TNTDashBoard';
    SourceTable = Integer;
    DelayedInsert = true;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group("Tracking Details")
            {
                Caption = 'Tracking Details';

                field(TrackingNo; TrackingNo)
                {
                    ApplicationArea = All;
                    Caption = 'Tracking No.';
                    Style = Favorable;
                    Editable = false;
                }
                field(Receiver; Receiver)
                {
                    ApplicationArea = All;
                    Caption = 'Receiver Name';
                    Style = Favorable;
                    Editable = false;
                }
                field(conId; conId)
                {
                    ApplicationArea = All;
                    Caption = 'Consignment ID';
                    Style = Favorable;
                    Editable = false;
                }
            }
            group("Current Status")
            {
                Caption = 'Current Status';

                field(LaststatusDescription; statusDescription[EntryNo])
                {
                    ApplicationArea = All;
                    Caption = 'Current Status';
                    Style = Favorable;
                    Editable = false;
                }
                field(LstDate; date[EntryNo])
                {
                    ApplicationArea = All;
                    Caption = 'Last Updated Date';
                    Style = Favorable;
                    Editable = false;
                }
                field(LastTime; time[EntryNo])
                {
                    ApplicationArea = All;
                    Caption = 'Last Updated Time';
                    Style = Favorable;
                    Editable = false;
                }
                field(LastDepot; depotName[EntryNo])
                {
                    ApplicationArea = All;
                    Caption = 'Current Depot Name';
                    Style = Favorable;
                    Editable = false;
                }
            }
            repeater(Control1)
            {
                Editable = false;
                FreezeColumn = statusCode;

                field(statusCode; statusCode[Rec.Number])
                {
                    Caption = 'Status Code';
                    ApplicationArea = all;
                    Style = StrongAccent;
                }
                field(statusDescription; statusDescription[Rec.Number])
                {
                    Caption = 'Status Description';
                    ApplicationArea = all;
                    Style = StrongAccent;
                }
                field(date; date[Rec.Number])
                {
                    Caption = 'Date';
                    ApplicationArea = all;
                    Style = StrongAccent;
                }
                field(time; time[Rec.Number])
                {
                    Caption = 'Time';
                    ApplicationArea = all;
                    Style = StrongAccent;
                }
                Field(depotName; depotName[Rec.Number])
                {
                    Caption = 'Depot Name';
                    ApplicationArea = all;
                    Style = StrongAccent;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetRange(Number, 1, 10);
        GetTrackingDetails(OrderTrackingParam);
    end;
    procedure SetValue(DocumentNo: Code[50])
    var
        Saleshdr: Record "Sales Header";
    begin
        IF Saleshdr.GET(Saleshdr."Document Type"::Order, DocumentNo)then begin
            Saleshdr.TestField("Tracking reference No.");
            OrderTrackingParam:=Saleshdr."Tracking reference No.";
        end;
    end;
    procedure GetTrackingDetails(TrackingNoL: Code[100]): Boolean var
        client: HttpClient;
        response: HttpResponseMessage;
        xmlContent: Text;
        xmlDoc: XmlDocument;
        root: XmlElement;
        nodes: XmlNodeList;
        node: XmlNode;
        i: Integer;
        InStr: InStream;
        xmlNod: XmlNode;
        xmlNod2: XmlNode;
        xmlNodList: XmlNodeList;
        xmlBuff: Record "XML Buffer";
    begin
        //GET https://<accountname>.blob.core.windows.net/?comp=list&<sastoken>
        if not client.Get('http://www.tntexpress.com.au/link/Cnmhx2.asp?' + TrackingNoL, response)then begin
            response.Content.ReadAs(xmlContent);
            exit;
        end;
        if not response.Content().ReadAs(xmlContent)then exit;
        if not XmlDocument.ReadFrom(xmlContent, xmlDoc)then exit;
        if xmlDoc.SelectNodes('//statusHistory', xmlNodList)then begin
            Foreach xmlNod in xmlNodList do begin
                xmlNod.SelectSingleNode('conId', xmlNod2);
                conId:=xmlNod2.AsXmlElement().InnerText;
                xmlNod.SelectSingleNode('conNumber', xmlNod2);
                TrackingNo:=xmlNod2.AsXmlElement().InnerText;
                xmlNod.SelectSingleNode('receiver', xmlNod2);
                Receiver:=xmlNod2.AsXmlElement().InnerText;
            END;
        end;
        if xmlDoc.SelectNodes('//status', xmlNodList)then begin
            foreach xmlNod in xmlNodList do begin
                EntryNo+=1;
                xmlNod.SelectSingleNode('statusCode', xmlNod2);
                statusCode[EntryNo]:=xmlNod2.AsXmlElement().InnerText;
                xmlNod.SelectSingleNode('statusDescription', xmlNod2);
                statusDescription[EntryNo]:=xmlNod2.AsXmlElement().InnerText;
                xmlNod.SelectSingleNode('date', xmlNod2);
                date[EntryNo]:=xmlNod2.AsXmlElement().InnerText;
                xmlNod.SelectSingleNode('time', xmlNod2);
                time[EntryNo]:=xmlNod2.AsXmlElement().InnerText;
                xmlNod.SelectSingleNode('depotName', xmlNod2);
                depotName[EntryNo]:=xmlNod2.AsXmlElement().InnerText;
            end;
        end;
        exit(true);
    end;
    var TrackingNo: Code[20];
    Receiver: Code[100];
    conId: Code[50];
    statusCode: array[10]of Code[10];
    statusDescription: array[10]of Text;
    date: array[10]of Text;
    time: array[10]of Text;
    depotName: array[10]of Text;
    EntryNo: Integer;
    OrderTrackingParam: Code[100];
}
