pageextension 50100 SalesOrderExt extends "Sales Order List"
{
    // layout
    // {
    //     addfirst(factboxes)
    //     {
    //         part(SalesLine; "Sales Order Subform")
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Sales Lines Details';
    //             SubPageLink = "Document No." = field("No.");
    //         }
    //     }
    // }
    layout
    {
        addbefore("Ship-to Name")
        {
            field("Ship-to Address"; Rec."Ship-to Address")
            {
                ApplicationArea = All;
                Caption = 'Ship-to Address';
                ToolTip = 'Specifies the address that products on the sales document will be shipped to.';

            }
        }
    }

    actions
    {
        addbefore("Sales Reservation Avail.")
        {
            action("Bill of Lad")
            {
                ApplicationArea = all;
                Image = Report;
                Caption = 'Bill of Lading';
                ToolTip = 'Specifies the Bill of Lading';
                trigger OnAction()
                var
                    reports: Report "Bill of Lad";
                begin
                    reports.Run();
                end;
            }
        }
        // Add changes to page actions here
    }
}