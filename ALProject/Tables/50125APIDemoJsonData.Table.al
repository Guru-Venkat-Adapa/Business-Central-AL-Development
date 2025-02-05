table 50125 Demojsontable
{
    DataClassification = CustomerContent;
    Caption = 'Demo Json Table';
    fields
    {
        field(1; id; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'id';
            trigger OnValidate()
            var
            TestCode:Codeunit DemoJsonData;
            begin
                TestCode.WritepiJsonData(Rec);
            end;
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; Username; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'User Name';
        }
        field(4; Email; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; Phno; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Phone Number';
        }
        field(6; Street; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(7; City; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(8; Pincode; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Pin Code';
        }
    }
    keys
    {
        key(Pk; id)
        {
            Clustered = true;
        }
    }
}