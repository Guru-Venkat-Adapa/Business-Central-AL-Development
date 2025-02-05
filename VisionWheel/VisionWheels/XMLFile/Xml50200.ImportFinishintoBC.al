namespace VisionWheels.VisionWheels;

xmlport 50200 "Import Finish into BC"
{
    Format = VariableText;
    Direction = Import;
    TextEncoding = UTF8;
    UseRequestPage = false;
    TableSeparator = '';//New line
    Caption = 'Import Finish into BC';
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(Finish; "Finish ")
            {
                fieldelement(Code; Finish."Code")
                {
                }
                fieldelement(Description; Finish.Description)
                {
                }
            }
        }
    }
}
