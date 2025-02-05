page 50110 "Top Vendors by Quantity"
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = "Purchase Line";
    Caption = ' ';

    layout
    {
        area(Content)
        {
            field(Heading; Heading)
            {
                ApplicationArea = All;
                Editable = false;
                Style = StrongAccent;
                ShowCaption = false;
                ToolTip = 'Chart Header';
            }
            usercontrol(Chart; BusinessChart)
            {
                ApplicationArea = All;

                trigger AddInReady()
                var
                    TempBuffer: Record "Business Chart Buffer" temporary;
                    PurchaseLine: Record "Purchase Line";
                    TempPurchLine: Record "Purchase Line" temporary;
                    Vendor: Record Vendor;
                    VendorList: array[5] of text;
                    QuantityList: array[5] of Decimal;
                    i, j : Integer;
                    TempVendor: Text;
                    TempQuantity: Decimal;
                    VendorKey: Code[20];
                    value: Code[20];
                    dic: Dictionary of [code[20], Integer];
                begin
                    Heading := 'Top 5 Vendors by Quantity Purchased';
                    TempBuffer.Initialize();
                    TempBuffer.AddMeasure('Quantity', 1, TempBuffer."Data Type"::Decimal, 18);
                    TempBuffer.SetXAxis('Vendor', TempBuffer."Data Type"::String);
                    if PurchaseLine.FindSet() then
                        repeat
                            if PurchaseLine.Quantity > 0 then begin
                                VendorKey := PurchaseLine."Buy-from Vendor No.";
                                if dic.ContainsKey(VendorKey) then
                                    dic.Set(VendorKey, dic.Get(VendorKey) + PurchaseLine.Quantity)
                                else
                                    dic.Add(VendorKey, PurchaseLine.Quantity);
                            end;
                        until PurchaseLine.Next() = 0;

                    j := 100;
                    TempPurchLine.DeleteAll();
                    foreach value in dic.Keys() do begin
                        TempPurchLine.Init();
                        TempPurchLine."Line No." := j;
                        TempPurchLine."Buy-from Vendor No." := value;
                        TempPurchLine.Quantity := dic.Get(value);
                        TempPurchLine.Insert();
                        j += 1;
                    end;

                    TempPurchLine.SetCurrentKey(TempPurchLine.Quantity);
                    TempPurchLine.SetAscending(TempPurchLine.Quantity, false);

                    i := 1;
                    if not TempPurchLine.GetAscending(Quantity) and TempPurchLine.FindSet() then
                        repeat
                            if i <= 5 then begin
                                Vendor.SetRange("No.", TempPurchLine."Buy-from Vendor No.");
                                if Vendor.FindFirst() then
                                    VendorList[i] := Vendor.Name;
                                QuantityList[i] := TempPurchLine.Quantity;
                                i += 1;
                            end;
                        until TempPurchLine.Next() = 0;

                    for i := 1 to 5 do begin
                        TempVendor := VendorList[i];
                        TempQuantity := QuantityList[i];
                        TempBuffer.AddColumn(TempVendor);
                        TempBuffer.SetValueByIndex(0, i - 1, TempQuantity);
                    end;

                    TempBuffer.UpdateChart(CurrPage.Chart);
                end;

                trigger DataPointClicked(Point: JsonObject)
                var
                    Vendor: Record Vendor;
                    PurchaseLine: Record "Purchase Line";
                    JsonToken: JsonToken;
                    VendorName: Text;
                begin
                    Point.Get('XValueString', JsonToken);
                    VendorName := JsonToken.AsValue().AsText();
                    Vendor.SetRange(Name, VendorName);
                    if Vendor.FindFirst() then begin
                        PurchaseLine.SetRange("Buy-from Vendor No.", Vendor."No.");
                        If PurchaseLine.FindSet() then
                            Page.Run(Page::"Purchase Lines", PurchaseLine);
                    end;
                end;
            }
        }
    }
    var
        Heading: Text;
}

