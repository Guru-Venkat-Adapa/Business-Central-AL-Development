xmlport 50103 xmlportfordemo
{
    Caption = 'Xmlport For Demo Data';
    Format = Xml;
    Encoding = UTF16;
    UseDefaultNamespace = true;
    Direction = Both;
    DefaultNamespace = 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2';
    Namespaces = cbc = 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', cac = 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', ns4 = 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2', xsi = 'http://www.w3.org/2001/XMLSchema-instance';
    schema
    {
        textelement(Control)
        {
            tableelement(DemoXmlFile; DemoXmlFile)
            {
                fieldelement(EmpId; DemoXmlFile.EmpId)
                { }
                fieldelement(EmpName; DemoXmlFile.EmpName)
                { }
                fieldelement(Technology; DemoXmlFile.Technology)
                { }
                fieldelement(JoiningYear; DemoXmlFile.JoiningYear)
                { }
                fieldelement(Phno; DemoXmlFile.Phno)
                { }
            }
        }
    }
}