page 50100 DemoJson
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Demojsontable;
    Caption = 'Demo Json Data';
    // CardPageId = DemoJsondataCard;
    layout
    {
        area(Content)
        {
            repeater(Data)
            {
                field(id; Rec.id)
                {
                    ApplicationArea = All;
                    Caption = 'Id';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    caption = 'Name';
                }
                field(Username; Rec.Username)
                {
                    Caption = 'User Name';
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    Caption = 'Email';
                    ApplicationArea = All;
                }
                field(Phno; Rec.Phno)
                {
                    Caption = 'Phone Number';
                    ApplicationArea = All;
                }
                field(Street; Rec.Street)
                {
                    ApplicationArea = All;
                    Caption = 'Street';
                }
                field(City; Rec.City)
                {
                    Caption = 'City';
                    ApplicationArea = All;
                }
                field(Pincode; Rec.Pincode)
                {
                    ApplicationArea = All;
                    Caption = 'Pin Code';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewJsonData)
            {
                ApplicationArea = All;
                Caption = 'View Json Data';
                Image = ViewDetails;
                trigger OnAction()
                var
                    Jsonread: Codeunit DemoJsonData;
                begin
                    Jsonread.ReadApiJsonData();
                end;
            }
            action(GetAllData)
            {
                ApplicationArea = All;
                Caption = 'Get All Json Data';
                Image = ViewDetails;
                trigger OnAction()
                var
                    Client: HttpClient;
                    Res: HttpResponseMessage;
                    data: Text;
                    JsonRead: Codeunit DemoJsonData;
                begin
                    // if Client.Get('https://jsonplaceholder.typicode.com/users', Res) then begin
                    //     Res.Content.ReadAs(data);
                    //     SetJsonObj(data);
                    // end;
                    JsonRead.WriteAllData(Rec);
                end;
            }
            action(DeleteAll)
            {
                Caption = 'Delete All Records';
                Image = "Invoicing-Delete";
                ApplicationArea = All;
                trigger OnAction()
                var
                    data: Record Demojsontable;
                begin
                    data.DeleteAll();
                    Message('All the records are deleted successfully');
                end;
            }
        }
    }

    local procedure SetJsonObj(Res: Text)
    var
        Json_Arr: JsonArray;
        Json_Obj: JsonObject;
        Json_val: JsonValue;
        i: Integer;
        JsonTable: Record Demojsontable;
        Json_token: JsonToken;
        Value_Token: JsonToken;
    begin
        if JsonTable.FindLast() then
            JsonTable.id += 1
        else
            JsonTable.id := 1;

        if Json_token.ReadFrom(Res) then begin
            if Json_token.IsArray then begin
                Json_Arr := Json_token.AsArray();

                for i := 0 to Json_Arr.Count - 1 do begin
                    Json_Arr.Get(i, Json_token);

                    if Json_token.IsObject then begin
                        Json_Obj := Json_token.AsObject();

                        if Json_Obj.Get('id', Value_Token) then begin
                            if Value_Token.IsValue then begin
                                JsonTable.id := Value_Token.AsValue().AsInteger();
                            end;
                        end;
                        if GetResultJsonValue(Json_Obj, 'name', Json_val) then
                            JsonTable.Name := Json_val.AsText();
                        if GetResultJsonValue(Json_Obj, 'email', Json_val) then
                            JsonTable.Email := Json_val.AsText();
                        if GetResultJsonValue(Json_Obj, 'username', Json_val) then
                            JsonTable.Username := Json_val.AsText();
                        if GetResultJsonValue(Json_Obj, 'phone', Json_val) then
                            JsonTable.Phno := Json_val.AsText();
                        if Json_Obj.Get('address', json_token) then begin
                            if json_token.IsObject then begin
                                Json_Obj := json_token.AsObject();
                                if GetResultJsonValue(Json_Obj, 'city', Json_val) then
                                    JsonTable.City := Json_val.AsText();
                                if GetResultJsonValue(Json_Obj, 'street', Json_val) then
                                    JsonTable.Street := Json_val.AsText();
                                if GetResultJsonValue(Json_Obj, 'zipcode', Json_val) then
                                    JsonTable.Pincode := Json_val.AsText();
                            end;
                        end;
                        JsonTable.Insert();
                        JsonTable.id += 1;
                    end;
                end;
            end;
        end;
    end;

    local procedure GetResultJsonValue(jobj: JsonObject; KeyName: Text; var jvalue: JsonValue): Boolean
    var
        jtoken: JsonToken;
    begin
        if not jobj.Get(KeyName, jtoken) then exit;
        jvalue := jtoken.AsValue();
        exit(true);
    end;
}