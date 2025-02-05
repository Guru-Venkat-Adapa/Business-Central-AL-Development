codeunit 50109 ExtraLineSO
{
    [EventSubscriber(ObjectType::Page, 46, 'OnAfterValidateEvent', 'Quantity', true, true)]
    procedure AddItemCharge(var Rec: Record "Sales Line")
    var
        ItemCharge: Record "Item Charge";
        SalesLine: Record "Sales Line";
    begin
        // SalesLine.GET(Rec."Document Type", Rec."Document No.", Rec."Line No.");
        // ItemCharge.SetRange(Item, Rec.Description);
        // if ItemCharge.FindSet() then begin
        //     repeat
        //         Rec.Init();
        //         Rec.Type := SalesLine.Type::"Charge (Item)";
        //         Rec."Line No." := Rec."Line No." + 10000;
        //         Rec."No." := ItemCharge."No.";
        //         Rec.Description := ItemCharge.Description;
        //         rec.Quantity := (ItemCharge.ItemQty * SalesLine.Quantity) / 100;
        //         Rec.Insert(true);
        //     until ItemCharge.Next() = 0;
        // end;
        ItemCharge.SetRange(Item, Rec.Description);
        SalesLine.SetRange("Document No.", Rec."Document No.");
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Line No.", Rec."Line No.");
        if ItemCharge.FindSet() then begin
            repeat
                Rec.Init();
                rec."Line No." := Rec."Line No." + 1;
                Rec.Type := SalesLine.Type::"Charge (Item)";
                Rec."No." := ItemCharge."No.";
                Rec.Description := ItemCharge.Description;
                Rec.Quantity := (ItemCharge.ItemQty * SalesLine.Quantity) / 100;
                Rec.Insert(true);
            until ItemCharge.Next() = 0;
        end;
    end;
}