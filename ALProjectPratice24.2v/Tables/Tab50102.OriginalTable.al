table 50102 OriginalTable
{
    Caption = 'OrginalTable';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ID; Code[20])
        {
            Caption = 'ID';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(4; Year; Integer)
        {
            DataClassification = ToBeClassified;
            MinValue = 2000;
            MaxValue = 2050;

        }
        field(5; Month; Integer)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 12;
        }
        field(6; MonthStartDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; MonthEndDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; FirstDay; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9; LastDay; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }

}
