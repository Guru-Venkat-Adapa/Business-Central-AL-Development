page 50109 "Top Vendors Chart Column"
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = "Purchase Header";
    Caption = ' ';
    RefreshOnActivate = true;

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
                    VendorTemp: Record Vendor;
                    TempBuffer: Record "Business Chart Buffer" temporary;
                    Vendor: Record Vendor;
                    VendorArray: array[5] of Record Vendor;
                    PurchasesArray: array[5] of Decimal;
                    i, j : Integer;
                begin
                    Heading := 'Top 5 Vendors by Purchase Amount';
                    TempBuffer.Initialize();
                    TempBuffer.AddMeasure('Toatl Amount', 1, TempBuffer."Data Type"::Decimal, 10);
                    TempBuffer.SetXAxis('Vendor', TempBuffer."Data Type"::String);
                    for i := 1 to 5 do begin
                        VendorArray[i] := VendorTemp;
                        PurchasesArray[i] := 0;
                    end;
                    if Vendor.FindSet() then
                        repeat
                            Vendor.CalcFields("Purchases (LCY)");
                            if Vendor."Purchases (LCY)" <> 0 then
                                for i := 1 to 5 do
                                    if PurchasesArray[i] < Vendor."Purchases (LCY)" then begin
                                        for j := 5 downto i + 1 do begin
                                            PurchasesArray[j] := PurchasesArray[j - 1];
                                            VendorArray[j] := VendorArray[j - 1];
                                        end;
                                        PurchasesArray[i] := Vendor."Purchases (LCY)";
                                        VendorArray[i] := Vendor;
                                        break;
                                    end;
                        until Vendor.Next() = 0;
                    for i := 1 to 5 do
                        if PurchasesArray[i] <> 0 then begin
                            TempBuffer.AddColumn(VendorArray[i].Name);
                            TempBuffer.SetValueByIndex(0, i - 1, PurchasesArray[i]);
                        end;
                    TempBuffer.UpdateChart(CurrPage.Chart);
                end;

                trigger DataPointClicked(Point: JsonObject)
                var
                    Vendor: Record Vendor;
                    VendorName: Text;
                    JsonToken: JsonToken;
                begin
                    Point.Get('XValueString', JsonToken);
                    VendorName := JsonToken.AsValue().AsText();
                    Vendor.SetFilter(Name, VendorName);
                    If Vendor.FindFirst() then
                        Page.Run(Page::"Vendor List", Vendor);
                end;
            }
        }
    }

    var
        Heading: Text;
}
