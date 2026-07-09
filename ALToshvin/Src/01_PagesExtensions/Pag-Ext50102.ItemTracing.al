pageextension 50102 "Item Tracing" extends "Item Tracing"
{
    //TBC-970 --->
    layout
    {
        addafter("Document No.")
        {
            field(SalesOrderNo; SalesOrderNo)
            {
                ApplicationArea = All;
                Caption = 'Sales Order No.';
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(SalesOrderNo);
        SalesShipHeader.Reset();
        SalesShipHeader.SetRange("No.", Rec."Document No.");
        if SalesShipHeader.FindFirst() then
            SalesOrderNo := SalesShipHeader."Order No.";
    end;

    var
        SalesOrderNo: Code[20];
        SalesShipHeader: Record "Sales Shipment Header";
    //TBC-970 <---
}
