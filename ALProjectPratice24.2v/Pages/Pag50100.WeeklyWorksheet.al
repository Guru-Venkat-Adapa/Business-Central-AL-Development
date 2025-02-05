page 50100 "Weekly Worksheet"
{
    ApplicationArea = All;
    Caption = 'Weekly Worksheet';
    PageType = List;
    SourceTable = "Weekly Worksheet";
    UsageCategory = Lists;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            field("Week Day"; WeekDay)
            {
                ApplicationArea = All;
                Caption = 'Select the week';
                trigger OnValidate()
                begin
                    Setdays();
                    GetSalesQuotes();
                    GetSalesOrders();
                    GetSalesInvoices();
                end;
            }
            repeater(General)
            {
                Editable = false;
                field("Text Content"; Rec."Text Content")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Style = Strong;
                }
                field(Day1; Rec.Day1)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Day1Cap;
                }
                field(Day2; Rec.Day2)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Day2Cap;
                }
                field(Day3; Rec.Day3)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Day3Cap;
                }
                field(Day4; Rec.Day4)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Day4Cap;
                }
                field(Day5; Rec.Day5)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Day5Cap;
                }
                field(Day6; Rec.Day6)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Day6Cap;
                }
                field(Day7; Rec.Day7)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Day7Cap;
                }
            }
        }
    }
    // trigger OnAfterGetRecord()
    // begin
    //     Setdays();
    // end;

    trigger OnOpenPage()
    begin
        WeekDay := Today;
        Setdays();
        GetSalesQuotes();
        GetSalesOrders();
        GetSalesInvoices();
    end;

    procedure Setdays()
    begin
        Clear(Day1Cap);
        Clear(Day2Cap);
        Clear(Day3Cap);
        Clear(Day4Cap);
        Clear(Day5Cap);
        Clear(Day6Cap);
        Clear(Day7Cap);
        if WeekDay <> 0D then begin
            Monday := CalcDate('<-CW>', WeekDay);
            if Monday <> 0D then begin
                Day1Cap := Format(Monday);
                Day2Cap := Format(CalcDate('+1D', Monday));
                Day3Cap := Format(CalcDate('+2D', Monday));
                Day4Cap := Format(CalcDate('+3D', Monday));
                Day5Cap := Format(CalcDate('+4D', Monday));
                Day6Cap := Format(CalcDate('+5D', Monday));
                Day7Cap := Format(CalcDate('+6D', Monday));
            end;
        end;
    end;

    procedure GetSalesQuotes()
    var
        SalesHeader: Record "Sales Header";
        // SalesInvHeader: Record "Sales Invoice Header";
        Day1, Day2, Day3, Day4, Day5, Day6, Day7 : Date;
    // Num1, Num2, Num3, Num4, Num5, Num6, Num7 : integer;
    begin
        Evaluate(Day1, Day1Cap);
        Evaluate(Day2, Day2Cap);
        Evaluate(Day3, Day3Cap);
        Evaluate(Day4, Day4Cap);
        Evaluate(Day5, Day5Cap);
        Evaluate(Day6, Day6Cap);
        Evaluate(Day7, Day7Cap);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        if SalesHeader.FindSet() then begin
            WeeklyWorkSheet.SetRange("Text Content", 'Sales Quote');
            if WeeklyWorkSheet.FindSet() then begin
                SalesHeader.SetRange("Document Date", Day1);
                WeeklyWorkSheet.Day1 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day2);
                WeeklyWorkSheet.Day2 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day3);
                WeeklyWorkSheet.Day3 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day4);
                WeeklyWorkSheet.Day4 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day5);
                WeeklyWorkSheet.Day5 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day6);
                WeeklyWorkSheet.Day6 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day7);
                WeeklyWorkSheet.Day7 := SalesHeader.Count
            end;
            WeeklyWorkSheet.Modify(true);
        end;
    end;

    procedure GetSalesOrders()
    var
        SalesHeader: Record "Sales Header";
        Day1, Day2, Day3, Day4, Day5, Day6, Day7 : Date;
    begin
        Evaluate(Day1, Day1Cap);
        Evaluate(Day2, Day2Cap);
        Evaluate(Day3, Day3Cap);
        Evaluate(Day4, Day4Cap);
        Evaluate(Day5, Day5Cap);
        Evaluate(Day6, Day6Cap);
        Evaluate(Day7, Day7Cap);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        if SalesHeader.FindSet() then begin
            WeeklyWorkSheet.SetRange("Text Content", 'Sales Order');
            if WeeklyWorkSheet.FindSet() then begin
                SalesHeader.SetRange("Document Date", Day1);
                WeeklyWorkSheet.Day1 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day2);
                WeeklyWorkSheet.Day2 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day3);
                WeeklyWorkSheet.Day3 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day4);
                WeeklyWorkSheet.Day4 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day5);
                WeeklyWorkSheet.Day5 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day6);
                WeeklyWorkSheet.Day6 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day7);
                WeeklyWorkSheet.Day7 := SalesHeader.Count;
            end;
            WeeklyWorkSheet.Modify(true);
        end;
    end;

    procedure GetSalesInvoices()
    var
        SalesHeader: Record "Sales Header";
        Day1, Day2, Day3, Day4, Day5, Day6, Day7 : Date;
    begin
        Evaluate(Day1, Day1Cap);
        Evaluate(Day2, Day2Cap);
        Evaluate(Day3, Day3Cap);
        Evaluate(Day4, Day4Cap);
        Evaluate(Day5, Day5Cap);
        Evaluate(Day6, Day6Cap);
        Evaluate(Day7, Day7Cap);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        if SalesHeader.FindSet() then begin
            WeeklyWorkSheet.SetRange("Text Content", 'Sales Invoice');
            if WeeklyWorkSheet.FindSet() then begin
                SalesHeader.SetRange("Document Date", Day1);
                WeeklyWorkSheet.Day1 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day2);
                WeeklyWorkSheet.Day2 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day3);
                WeeklyWorkSheet.Day3 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day4);
                WeeklyWorkSheet.Day4 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day5);
                WeeklyWorkSheet.Day5 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day6);
                WeeklyWorkSheet.Day6 := SalesHeader.Count;

                SalesHeader.SetRange("Document Date", Day7);
                WeeklyWorkSheet.Day7 := SalesHeader.Count;
            end;
            WeeklyWorkSheet.Modify(true);
        end;
    end;

    var
        Day1Cap, Day2Cap, Day3Cap, Day4Cap, Day5Cap, Day6Cap, Day7Cap : text;
        Monday: Date;
        SalesLine: Record "Sales Line";
        WeekDay: Date;
        WeeklyWorkSheet: Record "Weekly Worksheet";
        table1: Record "Requisition Line";
        Page1: Page "Planning Worksheet";
        SalesQuotePage: Page "Sales Quote Subform";
        item: Page "Items by Location Matrix";
}
