xmlport 50201 "Import Comment Lines"
{
    Caption = 'Import Comment Lines';
    Direction = Import;
    Format = VariableText;
    TextEncoding = UTF8;
    UseRequestPage = false;
    TableSeparator = '';
    FieldDelimiter = '|';
    FieldSeparator = '^';
    schema
    {
        textelement(RootNode)
        {
            tableelement(Comment_Line; "Comment Line")
            {
                fieldattribute(TableName; Comment_Line."Table Name")
                { }
                fieldattribute(No; Comment_Line."No.") { }
                fieldattribute(Line_No; Comment_Line."Line No.") { }
                fieldattribute(Date; Comment_Line.Date) { }
                fieldattribute(Code; Comment_Line.Code) { }
                fieldattribute(Comment; Comment_Line.Comment) { }

            }
        }
    }
}