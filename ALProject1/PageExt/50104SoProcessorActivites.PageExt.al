pageextension 50104 "So Processor Acivites Ext" extends "SO Processor Activities"
{
    layout
    {
        addafter(Returns)
        {
            cuegroup("Demo")
            {
                Caption = 'Demo';
                field("Demo Sales order Open"; Rec."Demo Sales order Open")
                {
                    Caption = 'Demo Sales Order open';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of sales order which are open';
                    DrillDownPageId = "Sales Order List";
                }
                field("Demo Customer"; Rec."Demo Customer")
                {
                    Caption = 'Demo Customer Location';
                    ApplicationArea = All;
                    DrillDownPageId = "Customer List";
                    ToolTip = 'Specifies the total customer from Yellow location with having 0 in sales(LCY),balance(LCY) and Bonus';
                }
                field("Demo Vendor"; Rec."Demo Vendor")
                {
                    Caption = 'Demo Vendor';
                    ApplicationArea = All;
                    DrillDownPageId = "Vendor List";
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        VendorCheck();

    end;

    procedure VendorCheck() temp: Integer;
    var
        vendor: Record Vendor;
    begin
        temp := 0;
        //    // Counting vendors using if conditiona d filter of balance <10000 or balance due=0 or payment =0
        //     if vendor.FindSet() then
        //         repeat
        //             vendor.CalcFields("Balance (LCY)", "Balance Due (LCY)", "Payments (LCY)");
        //     if (vendor."Balance (LCY)" < 10000) or (vendor."Balance Due (LCY)" = 0) or (vendor."Payments (LCY)" = 0) then begin
        //                     temp += 1;
        //                 end
        //                 else
        //                 Message('Hello');
        //             until vendor.Next() = 0;
        //         Rec."Demo Vendor" := temp;
        vendor.FilterGroup(-1);
        vendor.SetFilter("Location Code", 'Blue');
        vendor.SetFilter("Responsibility Center", 'London');
        vendor.SetFilter(Name, 'Big 5 Video');
        if vendor.FindSet() then
            repeat
                temp += 1;
            until vendor.Next() = 0;
        Rec."Demo Vendor" := temp;
    end;
}