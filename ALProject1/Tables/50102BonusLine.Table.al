table 50102 "Bonus Line"
{
    DataClassification = ToBeClassified;
    Caption='Bonus Line';
    fields
    {
       field(1;"Document No.";Code[20])
       {
        Caption='Document No.';
        DataClassification=CustomerContent;
        TableRelation="bonus Header";
       }
       field(2;"Type";Enum "Bonus Type")
       {
        DataClassification=CustomerContent;
        Caption='Type';
       }
       field(3;"Item No.";Code[20])
       {
        DataClassification=CustomerContent;
        Caption='Item No.';
        TableRelation=if(Type=filter(Item))Item;
       }
       field(4;"Bonus Perc.";Integer)
       {
        DataClassification=CustomerContent;
        Caption='Bonus Perc.';
        MinValue=0;
        MaxValue=100;
       }
    }

    keys
    {
        key(Pk; "Document No.","Type","Item No.")
        {
            Clustered = true;
        }
    }

}