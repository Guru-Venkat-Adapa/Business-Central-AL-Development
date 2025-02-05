table 50108 "Demo Item"
{
    DataClassification = ToBeClassified;
    Caption = 'Demo Item';
    fields
    {
        field(1; "Id"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Id';
        }
        field(2; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
        field(3; "Item Name"; Code[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Name';
        }
    }

    keys
    {
        key(Pk; Id)
        {
            Clustered = true;
        }
    }
    // trigger OnInsert()
    // var
    //     No: Integer;
    // begin
    //     No := 1;
    //     No += 1;
    //     Id := Format(No);
    // end;
}