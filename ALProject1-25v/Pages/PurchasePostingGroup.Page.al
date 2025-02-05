page 50106 Purchase_Posting_Group
{
    ApplicationArea = All;
    Caption = ' ';
    PageType = CardPart;

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
                begin
                    setperiodBy();
                end;

                trigger Refresh()
                begin
                    setperiodBy();
                end;

                trigger DataPointClicked(Point: JsonObject)
                var
                    Purchline: Record "Purchase Line";
                    JsonToken: JsonToken;
                    ItemCode: Text;
                begin
                    Point.Get('XValueString', JsonToken);
                    ItemCode := JsonToken.AsValue().AsText();
                    Purchline.SetRange("Document Type", Purchline."Document Type"::Order);
                    Purchline.SetRange("Item Category Code", ItemCode);
                    if Purchline.FindSet() then
                        Page.Run(Page::"Purchase Lines", Purchline);
                end;
            }
        }
    }
    var
        Buffer: Record "Business Chart Buffer";
        Heading: Text;

    procedure setperiodBy()
    var
        ItemCategory: Record "Item Category";
        startDate: Date;
        endDate: Date;
        lastDate: Date;
        i: Integer;
    begin
        Heading := 'Item By Posting Group and Purchase Amount';
        Clear(startDate);
        Clear(endDate);
        Clear(lastDate);
        endDate := DMY2Date(31, 12, Date2DMY(Today, 3));
        startDate := DMY2Date(01, 01, Date2DMY(Today, 3));
        i := 0;
        ItemCategory.CalcFields(ToatlAmount);
        ItemCategory.SetCurrentKey(ToatlAmount);
        ItemCategory.SetAscending(ToatlAmount, false);
        Buffer.Initialize();
        Buffer.AddMeasure('Total Count', 1, Buffer."Data Type"::Decimal, "Business Chart Type"::Doughnut.AsInteger());
        Buffer.SetXAxis('Item Gen. Posting Code', Buffer."Data Type"::String);
        if ItemCategory.FindSet() and not ItemCategory.GetAscending(ToatlAmount) then
            repeat
                Buffer.AddColumn(Format(ItemCategory.Code));
                Buffer.SetValueByIndex(0, i, ItemCategory.ToatlAmount);
                i += 1;
            until ItemCategory.Next() = 0;
        Buffer.UpdateChart(CurrPage.Chart);
    end;
}
