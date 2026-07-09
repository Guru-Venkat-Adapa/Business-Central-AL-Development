table 50016 "Rate Per KM"
{
    Caption = 'Rate Per KM';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Name; Code[30])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(2; "Per KM Rate"; Decimal)
        {
            Caption = 'Per KM Rate';
            DataClassification = CustomerContent;


        }
    }
    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Name, "Per KM Rate")
        {
        }
    }

}
