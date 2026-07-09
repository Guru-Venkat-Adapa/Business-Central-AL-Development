tableextension 50031 "No. Series" extends "No. Series"
{
    fields
    {
        field(50000; "PO Order No. Series"; Boolean)
        {
            Caption = 'PO Order No. Series';
            DataClassification = ToBeClassified;
        }
        //TBC - 925,922 -->
        field(50100; "Posting Warehouse No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        //TBC - 925,922 <--
    }
}
