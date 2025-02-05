page 50104 ItemChart_Doughnut
{
    ApplicationArea = All;
    Caption = ' ';
    PageType = CardPart;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            field(Heading; Heading)
            {
                ApplicationArea = All;
                ShowCaption = false;
                Editable = false;
                Style = StrongAccent;
                ToolTip = 'Specifies the status of the chart.';
            }
            usercontrol(ChartItem; BusinessChart)
            {
                ApplicationArea = All;
                trigger AddInReady()
                begin
                    setperiodBy();
                    refresh := true;
                end;

                trigger Refresh()
                begin
                    setperiodBy();
                end;

                trigger DataPointClicked(Point: JsonObject)
                var
                    Item: Record Item;
                    Value: Record "Value Entry";
                    Jsontoken: JsonToken;
                    ItemName: Text;
                begin
                    Point.Get('XValueString', Jsontoken);
                    ItemName := Jsontoken.AsValue().AsText();
                    item.SetRange(Description, ItemName);
                    if Item.FindFirst() then
                        Value.SetRange("Item No.", Item."No.");
                    value.SetRange("Item Ledger Entry Type", "Item Ledger Entry Type"::Purchase);
                    if Value.FindSet() then
                        Page.Run(Page::"Value Entries", Value);

                end;
            }
        }
    }
    var
        Buffer: Record "Business Chart Buffer";
        refresh: Boolean;
        Heading: Text;

    procedure setperiodBy()
    var
        item: Record Item;
        startDate: Date;
        endDate: Date;
        lastDate: Date;
        i: Integer;
    begin
        Heading := 'Top 5 Items by Quantity purchased';
        Clear(startDate);
        Clear(endDate);
        Clear(lastDate);
        endDate := DMY2Date(31, 12, Date2DMY(Today, 3));
        startDate := DMY2Date(01, 01, Date2DMY(Today, 3));
        i := 0;
        item.CalcFields(item_Ledeger_Amount);
        item.SetCurrentKey(item_Ledeger_Amount);
        item.SetAscending(item_Ledeger_Amount, false);
        Buffer.Initialize();
        Buffer.AddMeasure('Quantity', 1, Buffer."Data Type"::Decimal, "Business Chart Type"::Doughnut.AsInteger());
        Buffer.SetXAxis('Item', Buffer."Data Type"::String);
        if item.FindSet() then
            repeat
                Buffer.AddColumn(Format(item.Description));
                Buffer.SetValueByIndex(0, i, item.item_Ledeger_Amount);
                i += 1;
                if i >= 5 then break;
            until item.Next() = 0;
        Buffer.UpdateChart(CurrPage.ChartItem);
    end;
}

