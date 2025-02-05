pageextension 50118 "Sales Order List Ext" extends "Sales Order List"
{
    layout
    {
        // addafter(Status)
        // {
        //     field("Customer Type"; Rec."Customer Type")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'customer type';
        //     }
        //     field(Stages; Rec.Stages)
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'stages';
        //     }
        //     field("Order Margin"; Rec."Order Margin")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'order margin';
        //     }
        //     field("Referral Source"; Rec."Referral Source")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'referral source';
        //     }
        // }
        addafter("Referral Source")
        {
            field("Payment Received %"; Rec."Payment Received %")
            {
                Caption = 'Payment Received %';
                ToolTip = 'Specifies the payment percentage done for the order';
            }
        }
    }
    actions
    {
        addlast("&Print")
        {
            action("Order Tracking")
            {
                Caption = 'Import Tracking Data';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    Code: Codeunit "Import Tracking Data fromExcel";
                begin
                    Code.ReadExcelSheet();
                    Code.ImportExcelData();
                end;
            }
        }
        // addlast("&Print")
        // {
        //     action(DeleteWareHouseshipmeent)
        //     {
        //         ApplicationArea = All;
        //         Caption = 'Delete Warehouse shipments data';
        //         trigger OnAction()
        //         var
        //             Ware: Record "Warehouse Shipment Header";
        //         begin
        //             Ware.SetRange(Ware."No.", Ware."No.");
        //             if Ware.FindSet() then begin
        //                 Ware.DeleteAll();
        //             end;
        //         end;
        //     }
        // }
    }
    // var
    //     Email: Page "Email Editor";
    //     Quotereport: report 50101;
    //     Invoicereport: report 50102;
}

