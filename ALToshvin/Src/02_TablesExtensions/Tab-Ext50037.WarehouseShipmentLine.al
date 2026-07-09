tableextension 50037 "Warehouse Shipment Line" extends "Warehouse Shipment Line"
{
    fields
    {
        //TBC-950 -->
        field(50100; "Lot No."; Code[50])
        {
            Caption = 'Last Lot No.';
            DataClassification = ToBeClassified;
        }
        //TBC-950 <--
    }
}
