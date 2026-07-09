tableextension 50027 "Posted Whse. Ship Header Ext" extends "Posted Whse. Shipment Header"
{
    fields
    {
        field(50100; "Sales Type"; Enum "Transfer Order Sales Type")
        {
            Caption = 'Sales Type';
            DataClassification = ToBeClassified;
        }
        field(50101; "Requisition Purpose"; Text[100])
        {
            Caption = 'Requisition Purpose';
            DataClassification = CustomerContent;
        }
        field(50102; "Part Requisition Form"; Text[100])
        {
            Caption = 'Part Requisition Form';
            DataClassification = CustomerContent;
        }
        field(50103; "Expected RDC Return Date"; Date)
        {
            Caption = 'Expected RDC Return Date';
            DataClassification = CustomerContent;
        }

        field(50108; Note; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        //TBC-973 -->
        field(50110; "Party PO Received Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        //TBC-973 <--
    }
}
