codeunit 50103 "Free Gift Management"
{
    //     [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Quantity', false, false)]
    //     local procedure AddfreeGift(var Rec: Record "Sales Line")
    //     begin
    //         if (Rec.Type = Rec.Type::Item) and (Customer.Get(Rec."Sell-to Customer No.")) then begin
    //             if FreeGift.Get(Customer."Customer Category SDM", Rec."No.") and (rec.Quantity > FreeGift."Minimum Order") then begin
    //                 OnBeforeFreeGiftSalesLineAdded(Rec);
    //                 SalesLine.Init();
    //                 SalesLine.TransferFields(Rec);
    //                 SalesLine."Line No." := Rec."Line No." + 10000;
    //                 SalesLine.Validate(Quantity,FreeGift."Gift Quantity");
    //                 SalesLine.Validate("Line Discount %", 100);
    //                 if SalesLine.Insert() then;
    //                 OnAfterFreeGiftSalesLineAdded(Rec,SalesLine);
    //             end;
    //         end;
    //     end;

    //     [IntegrationEvent(true, true)]
    //     local procedure OnBeforeFreeGiftSalesLineAdded(var Rce: Record "Sales Line")
    //     begin
    //     end;

    //     [IntegrationEvent(true, true)]
    //     local procedure OnAfterFreeGiftSalesLineAdded(var Rec: Record "Sales Line";var SalesLineGift:Record "Sales Line")
    //     begin
    //     end;
    // [EventSubscriber(ObjectType::Table,32,'OnAfterInsertEvent','',false,false)]
    //     local procedure OnAfterLedgerEntryInsert(var Rec: Record "Item Ledger Entry")
    //     begin
    //         if Rec."Entry Type" = rec."Entry Type"::Sale then begin
    //             if Customer.Get(Rec."Source No.") then begin
    //                 rec."Customer Category" := Customer."Customer Category SDM";
    //               //  Rec.Modify();
    //             end;
    //         end;
    //     end;

    //     var
    //         FreeGift: Record "Free Gifts";
    //         SalesLine: Record "Sales Line";
    //         Customer: Record Customer;
}
