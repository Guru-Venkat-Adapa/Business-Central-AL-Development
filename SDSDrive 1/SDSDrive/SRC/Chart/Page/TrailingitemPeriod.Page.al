page 60132 "Trailing Item Period"
{
    Caption = 'Items';
    PageType = CardPart;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            // field(Heading; Heading)
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'Status Text';
            //     Editable = false;
            //     Style = StrongAccent;
            //     ShowCaption = false;
            //     ToolTip = 'Specifies the status of the chart.';
            // }
            group(PurchaseCharts)
            {
                Caption = 'Purchase Chart Analysis';
                grid(Top5Item)
                {

                    usercontrol(Chart; BusinessChart)
                    {
                        ApplicationArea = Basic, Suite;

                        trigger AddInReady()
                        begin
                            getfiltertype();
                            refresh := true;
                        end;

                        trigger Refresh()
                        begin
                            getfiltertype();
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        var
                            value: Record "Value Entry";
                            jtoken: JsonToken;
                            filter: Text;
                            item: Record item;
                            date1: Date;
                            date2: Date;
                        begin
                            point.Get('XValueString', jtoken);
                            filter := jtoken.AsValue().AsText();
                            item.SetRange(Description, filter);
                            if item.FindFirst() then begin
                                value.SetRange("Item No.", item."No.");
                                value.SetRange("Item Ledger Entry Type", "Item Ledger Entry Type"::Sale);
                                if value.FindSet() then
                                    Page.Run(Page::"Value Entries", value);
                            end;
                        end;
                    }
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            group(Options)
            {
                Caption = 'Options';
                image = ShowChart;

                group("Chart Type")
                {
                    Caption = 'Chart Type';
                    Image = BarChart;
                    action(PieChart)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Pie Chart';
                        ToolTip = 'View the data in Pie layout.';

                        trigger OnAction()
                        begin
                            chart.SetChartType(chart."Chart Type"::Pie);
                            getfiltertype();
                        end;
                    }
                    action(DoughnutChart)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Doughnut Chart';
                        ToolTip = 'view the data in Doughnut Chart';

                        trigger OnAction()
                        begin
                            chart.SetChartType(chart."Chart Type"::Doughnut);
                            getfiltertype();
                        end;
                    }
                    action(ColumnChart)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Column Chart';
                        ToolTip = 'view the data in column layout.';

                        trigger OnAction()
                        begin
                            chart.SetChartType(chart."Chart Type"::Column);
                            getfiltertype();
                        end;
                    }
                    action(LineChart)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Line Chart';
                        ToolTip = 'view the data in Line layout.';

                        trigger OnAction()
                        begin
                            chart.SetChartType(chart."Chart Type"::Line);
                            getfiltertype();
                        end;
                    }
                }
            }


        }
    }

    var
        Buffer: Record "Business Chart Buffer";
        chart: Record "Trailing item Setup period";

        refresh: Boolean;
        Heading: Text;



    procedure getfiltertype()
    var
        User: Codeunit "chart helper";
    begin
        chart.SetRange("User ID", User.getUserIdforperioditem());
        chart.SetRange("Company Name", Database.CompanyName);
        if not chart.FindSet() then exit;
        if chart.FindSet() then
            setperiodBy();

    end;

    procedure setperiodBy()
    var
        item: Record Item;
        startDate: Date;
        endDate: Date;
        lastDate: Date;
        temp: Decimal;
        i: Integer;
        caption2: Text;
    begin
        Heading := 'Top Five Items By Sales Values';
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
        // Buffer.AddMeasure('Item Sales', 1, Buffer."Data Type"::Decimal, chart."Chart Type".AsInteger());
        Buffer.AddMeasure('Item Sales', 1, Buffer."Data Type"::Decimal, "Business Chart Type"::Line.Asinteger());

        Buffer.SetXAxis('Item', Buffer."Data Type"::String);
        if item.FindSet() then
            repeat
                Buffer.AddColumn(Format(item.Description));
                Buffer.SetValueByIndex(0, i, item.item_Ledeger_Amount);
                i += 1;
                if i >= 5 then break;
            until item.Next() = 0;
        Buffer.UpdateChart(CurrPage.Chart);
    end;



}