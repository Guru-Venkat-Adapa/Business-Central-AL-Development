pageextension 50102 "Posted Sales Shipment Ext" extends "Posted Sales Shipment"
{
    actions
    {
        addafter("&Track Package")
        {
            action(PrintShipment)
            {
                ApplicationArea = all;
                Image = Print;
                Caption = 'Shipper Label';
                ToolTip = 'Specifies the Shipment Label';
                trigger OnAction()
                var
                    reports: Report PostedSalesShipment;
                begin
                    Rec.SetRange("No.", Rec."No.");
                    reports.SetTableView(Rec);
                    reports.RunModal();
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(shipmentLabel; PrintShipment) { }
        }
    }

}
