codeunit 50101 "Demo Customer Item Vendor"
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        case Rec."Parameter String".ToUpper() of
            'ITEM':
                RunForItem();

            'CUSTOMER':
                OnRunCustomer();
            'VENDOR':
                OnRunVendor();
        end;
    end;


    // local procedure RunForItem()
    // var
    //     DemoItem: Record "Demo Item Data";
    //     MainItem: Record Item;
    //     Srno: Integer;
    //     found: Boolean;
    // begin
    //     MainItem.Reset();
    //     MainItem.SetRange(Blocked, false);
    //     //Srno := 1;
    //     if MainItem.FindSet() then
    //         repeat
    //             DemoItem.Reset();
    //             if DemoItem.FindLast() then begin
    //                 Srno := DemoItem.SrNo;
    //             end;

    //             DemoItem.Reset();
    //             DemoItem.SetFilter(ItemNo, MainItem."No.");
    //             if not DemoItem.FindFirst() then begin
    //                 DemoItem.Init();
    //                 DemoItem.SrNo := Srno + 1;
    //                 DemoItem.ItemNo := MainItem."No.";
    //                 DemoItem.ItemName := MainItem.Description;
    //                 DemoItem.Insert(true);
    //                 found := true;
    //             end;
    //         until (MainItem.Next() = 0) or (found = true);
    // end;
    local procedure RunForItem()
    var
        DemoItem: Record "Demo Item";
        MainItem: Record Item;
        Srno: Integer;
        CountNo: Integer;
        found: Boolean;
    begin
        MainItem.Reset();
        MainItem.SetRange(Blocked, false);
        if MainItem.FindSet() then
            repeat
                DemoItem.Reset();
                if DemoItem.FindLast() then begin
                    Srno := DemoItem.Count();
                    //Evaluate(Srno,CountNo);
                end else begin
                    Srno := 0;
                end;
                DemoItem.Reset();
                DemoItem.SetFilter("Item No.", MainItem."No.");
                if not DemoItem.FindFirst() then begin
                    DemoItem.Init();
                    DemoItem.Id := Format(Srno + 1);
                    DemoItem."Item No." := MainItem."No.";
                    DemoItem."Item Name" := MainItem.Description;
                    DemoItem.Insert(true);
                    found := true;
                end;
            until (MainItem.Next() = 0) or (found = true);
    end;

    local procedure OnRunCustomer()
    begin
        Customer.Reset();
        Customer.SetRange(Blocked, Customer.Blocked::" ");
        if Customer.FindSet() then
            repeat
                copyCustomer.Reset();
                if copyCustomer.FindLast() then
                    slno := copyCustomer.Count()
                // Evaluate(slno, copyCustomer.Id)
                else begin
                    slno := 0;
                end;
                copyCustomer.Reset();
                copyCustomer.SetFilter("Customer No.", Customer."No.");
                if not copyCustomer.FindFirst() then begin
                    copyCustomer.Init();
                    copyCustomer.Id := Format(slno + 1);
                    copyCustomer."Customer No." := Customer."No.";
                    copyCustomer."Customer Name" := Customer.Name;
                    copyCustomer.Insert(true);
                    temp := true;
                end;
            until (Customer.Next() = 0) or (temp = true);
    end;

    local procedure OnRunVendor()
    begin
        Vendor.Reset();
        Vendor.SetRange(Blocked, vendor.Blocked::" ");
        if Vendor.FindSet() then
            repeat
                copyVendor.Reset();
                if copyVendor.FindLast() then begin
                    slno := copyVendor.Count();
                    // Evaluate(slno, copyVendor.Id);
                end
                else begin
                    slno := 0;
                end;
                copyVendor.Reset();
                copyVendor.SetFilter("Vendor No.", Vendor."No.");
                if not copyVendor.FindFirst() then begin
                    copyVendor.init();
                    copyVendor.id := Format(slno + 1);
                    copyVendor."Vendor No." := Vendor."No.";
                    copyVendor."Vendor Name" := Vendor.Name;
                    copyVendor.Insert(true);
                    temp := true;
                end;
            until (vendor.Next() = 0) or (temp = true);
    end;

    var
        slno: Integer;
        Customer: Record Customer;
        copyCustomer: Record "Demo Customer";
        Vendor: Record Vendor;
        copyVendor: Record "Demo Vendors";
        temp: Boolean;

}