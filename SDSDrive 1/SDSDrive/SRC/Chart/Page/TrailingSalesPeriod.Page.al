page 60133 "Trailing sales Period"
{
    Caption = 'Sales Analysis';
    PageType = CardPart;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            field(Heading; Heading)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Status Text';
                Editable = false;
                Style = StrongAccent;
                ShowCaption = false;
                ToolTip = 'Specifies the status of the chart.';
            }
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


                end;
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
        Sales: Record "Sales Header";
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

        Buffer.Initialize();
        Buffer.AddMeasure('Sales Quote', 1, Buffer."Data Type"::Decimal, chart."Chart Type".AsInteger());
        Buffer.AddMeasure('Sales Order', 2, Buffer."Data Type"::Decimal, chart."Chart Type".AsInteger());
        Buffer.SetXAxis('Sales Quote', Buffer."Data Type"::String);
        Buffer.SetXAxis('Sales Order', Buffer."Data Type"::String);

        repeat
            Sales.SetFilter(SystemCreatedAt, StrSubstNo(Format(startDate) + '..' + Format(CalcDate('<CM>', startDate))));
            Sales.SetRange("Document Type", Sales."Document Type"::Quote);
            if Sales.FindSet() then begin
                Buffer.AddColumn(Format('Sales Quote'));
                Buffer.SetValueByIndex(0, i, Sales.count);
            end
            else begin
                Buffer.AddColumn(Format('Sales Quote'));
                Buffer.SetValueByIndex(0, i, 0);
            end;

            Sales.SetFilter(SystemCreatedAt, StrSubstNo(Format(startDate) + '..' + Format(CalcDate('<CM>', startDate))));
            Sales.SetRange("Document Type", Sales."Document Type"::order);
            if Sales.FindSet() then begin
                Buffer.AddColumn(Format('Sales Order'));
                Buffer.SetValueByIndex(0, i, Sales.count);
            end
            else begin
                Buffer.AddColumn(Format('Sales Order'));
                Buffer.SetValueByIndex(0, i, 0);
            end;
            i += 1;
            startDate := CalcDate('<+M>', startDate);
        until i >= 11;
        Buffer.UpdateChart(CurrPage.Chart);
    end;



}