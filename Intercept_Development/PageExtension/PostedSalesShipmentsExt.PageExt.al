pageextension 50101 "Posted Sales Shipments Ext" extends "Posted Sales Shipments"
{
    // views
    // {
    //     addfirst
    //     {
    //         view(SortingbyNo)
    //         {
    //             Caption = 'Sorting by No.';
    //             OrderBy = ascending("No.");
    //         }
    //     }
    // }
    actions
    {
        addafter("Shipping Labels")
        {
            action("Bill of Lad")
            {
                ApplicationArea = all;
                Image = Report;
                Caption = 'Bill of Lading';
                ToolTip = 'Specifies the Bill of Lading';
                trigger OnAction()
                var
                    reports: Report BOLofSalesShipment;
                begin
                    reports.Run();
                end;
            }
        }
        // Add changes to page actions here
    }
    // trigger OnOpenPage()
    // var
    //     PostedSalesShipment: Record "Sales Shipment Header";
    // begin
    //     Rec.SetCurrentKey("No.");
    //     Rec.SetAscending("No.", false);
    // end;
}
