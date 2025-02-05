table 50124 DemoXmlFile
{
    DataClassification = ToBeClassified;
    Caption = 'Xml File Import and Export';
    fields
    {
        field(1; EmpId; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Id';
        }
        field(2; EmpName; Text[50])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
        }
        field(3; Technology; Text[50])
        {
            Caption = 'Technology';
            DataClassification = CustomerContent;
        }
        field(4; JoiningYear; Date)
        {
            Caption = 'Joining Year';
            DataClassification = CustomerContent;
        }
        field(5; Phno; BigInteger)
        {
            Caption = 'Phone Number';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; EmpId)
        {
            Clustered = true;
        }
    }

}