table 50118 "Free Gifts"
{
    DataClassification = CustomerContent;
    Caption='Free Gifts';
    DrillDownPageId="Free Gift List";
    LookupPageId="Free Gift List";

    fields
    {
        field(1;"Customer Category";Code[20])
        {
            DataClassification = CustomerContent;
            Caption='Customer Category';
            TableRelation="Customer Category";
        }
        field(2;"item No";Code[20])
        {
            Caption='Item No.';
            DataClassification=CustomerContent;
            TableRelation=Item;
        }
        field(3;"Minimum Order";Decimal)
        {
            DataClassification=CustomerContent;
            Caption='Mininum Order';
        }
        field(4;"Gift Quantity";Decimal)
        {
            DataClassification=CustomerContent;
            Caption='Gift Quantity';
        }
    }

    keys
    {
        key(Pk; "Customer Category","item No")
        {
            Clustered = true;
        }
    }
}