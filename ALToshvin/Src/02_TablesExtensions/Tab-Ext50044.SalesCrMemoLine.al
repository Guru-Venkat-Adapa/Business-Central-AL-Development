tableextension 50044 "Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
{
    fields
    {
        //TBC-1072 ---->
        field(50003; "Item Instrument No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Instrument No.';
            Editable = false;
        }
        //TBC-1072 --->
    }
}
