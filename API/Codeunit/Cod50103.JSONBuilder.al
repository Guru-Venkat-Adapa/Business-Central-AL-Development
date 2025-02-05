codeunit 50103 "JSON Builder"
{
    var
        JsonText: Text;
        Stack: List of [Text];
    //to start an object with {
    procedure WriteStartObject()
    begin
        if JsonText = '[' then
            JsonText += '{'
        else
            JsonText += ',{';
        Stack.Add('}');
    end;
    //To start a array with [
    procedure WriteStartArray(Name: Text)
    begin
        JsonText += '[';
        Stack.Add(']');
    end;
    // to end the object with }
    procedure WriteEndObject()
    begin
        JsonText += '}';
        if Stack.Count() > 0 then begin
            Stack.RemoveAt(Stack.Count());
            // if Stack.Count() > 0 then
            //     JsonText += ',';
        end;
    end;
    //to end array with ]
    procedure WriteEndArray()
    begin
        if Stack.Count() > 0 then
            JsonText += Stack.Get(Stack.Count());
        Stack.RemoveAt(Stack.Count());
    end;
    //to write the values into json object format 
    procedure WriteProperty(Name: Text; Value: Text)
    begin
        if JsonText[StrLen(JsonText)] <> '{' then
            JsonText += ',';
        JsonText += '"' + Name + '":"' + Value + '"';
    end;
    //to send hole josn object for inserting
    procedure GetJsonText(var ResultJsonText: Text)
    begin
        ResultJsonText := JsonText;
    end;

    // procedure GetJsonText(): Text
    // begin
    //     exit(JsonText);
    // end;
}
