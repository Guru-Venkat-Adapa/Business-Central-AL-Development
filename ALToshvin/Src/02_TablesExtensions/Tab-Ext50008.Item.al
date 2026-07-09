tableextension 50008 Item extends Item
{
    fields
    {
        field(50000; "CRM Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Item Reorder"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Reorder';
        }
        field(50002; "Primary Category 1"; Text[50])
        {
            Caption = 'Primary Category 1';
            DataClassification = CustomerContent;
        }
        field(50003; "Primary Category 2"; Text[50])
        {
            Caption = 'Primary Category 2';
            DataClassification = CustomerContent;
        }
        field(50004; "Primary Category 3"; Text[50])
        {
            Caption = 'Primary Category 3';
            DataClassification = CustomerContent;
        }
        field(50005; "Item Category 1"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50006; "Item Category 2"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50007; "Principal"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Principal';
        }
    }
}
