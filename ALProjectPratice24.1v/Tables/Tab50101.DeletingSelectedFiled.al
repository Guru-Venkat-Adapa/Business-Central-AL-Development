table 50101 DeletingSelectedFiled
{
    Caption = 'DeletingSelectedFiled';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; Email; Text[50])
        {
            Caption = 'Email';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    var
    // demo:Record "Guided Experience Item";
    // test:Page"Assisted Setup";
}
