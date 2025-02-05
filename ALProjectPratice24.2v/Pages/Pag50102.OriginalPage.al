page 50102 OriginalPage
{
    ApplicationArea = All;
    Caption = 'Original Page';
    PageType = Worksheet;
    SourceTable = OriginalTable;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    // trigger OnValidate()
                    // begin
                    //     SetYear();
                    // end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DateRec: Record Date;
                    begin
                        DateRec.Reset();
                        DateRec.SetRange("Period Type", DateRec."Period Type"::Year);
                        DateRec.SetRange("Period No.", 2000, 2050);
                        if Page.RunModal(Page::"Select Year", DateRec) = Action::LookupOK then
                            Rec.Validate(Year, DateRec."Period No.");
                        SetYear();
                    end;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = All;
                    Caption = 'Month';
                    Editable = EditMonth;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DateRec: Record Date;
                    begin
                        DateRec.Reset();
                        DateRec.SetRange("Period Type", DateRec."Period Type"::Month);
                        DateRec.SetRange("Period Start", DMY2Date(1, 1, Rec.Year), DMY2Date(1, 12, Rec.Year));
                        if Page.RunModal(Page::"Select Year", DateRec) = Action::LookupOK then
                            Rec.Validate(Month, DateRec."Period No.");
                        GetStartandEndDate();
                    end;
                }
                field(MonthStartDate; Rec.MonthStartDate)
                {
                    ApplicationArea = All;
                    Caption = ' Month Start Date';
                }
                field(MonthEndDate; Rec.MonthEndDate)
                {
                    ApplicationArea = All;
                    Caption = 'Month End Date';
                }
            }
            repeater(Lines)
            {
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the Unique ID for a record';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the Name';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the Address';
                }
            }
        }
    }
    procedure SetYear()
    begin
        EditMonth := false;
        If Rec.Year <> 0 then begin
            EditMonth := true;
            Rec.MonthStartDate := 0D;
            Rec.MonthendDate := 0D;
            Rec.Month := 0;
        end;
    end;

    procedure GetStartandEndDate()
    var
        Day1: Integer;
        Day2: Integer;
        Year: Date;
        temp1: Integer;
        temp2: Integer;
        temp3: Integer;
    begin
        Evaluate(Day1, '01');
        if Rec.Month <> 0 then begin
            rec.MonthStartDate := DMY2Date(Day1, Rec.Month, Rec.Year);
            If (Rec.Month = 1) or (Rec.Month = 3) or (Rec.Month = 5) or (Rec.Month = 7) or (Rec.Month = 8) or (Rec.Month = 10) or (Rec.Month = 12) then begin
                Evaluate(Day2, '31');
                Rec.MonthEndDate := DMY2Date(Day2, Rec.Month, Rec.Year);
            end else if (Rec.Month = 2) then begin
                temp1 := Rec.Year DIV 4;
                temp2 := Rec.Year DIV 100;
                temp3 := Rec.Year DIV 400;
                if (Rec.Year - (temp1 * 4) = 0) and ((Rec.Year - (temp2 * 100) <> 0) or (Rec.Year - (temp3 * 400) = 0)) then
                    Evaluate(Day2, '29')
                else
                    Evaluate(Day2, '28');
                Rec.MonthEndDate := DMY2Date(Day2, Rec.Month, Rec.Year);
            end else begin
                Evaluate(Day2, '30');
                Rec.MonthEndDate := DMY2Date(Day2, Rec.Month, Rec.Year);
            end;
        end;
    end;

    var
        EditMonth: Boolean;
}
