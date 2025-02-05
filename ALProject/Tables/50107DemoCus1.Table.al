table 50107 "Demo Customer"
{
    DataClassification = ToBeClassified;
    Caption = 'Demo Customer';
    fields
    {
        field(1; "Id"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer id';
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
        }
        field(3; "Customer Name"; Code[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Name';
        }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }
    // trigger OnInsert()
    // var
    //     no: Integer;
    // begin
    //     no := 1;
    //     if Rec.FindSet() then
    //         repeat
    //             id := Format(no + 1);
    //         until Rec.Next() = 0;
    //     no += 1;
    // end;
}