table 50101 Quater
{
    Caption = 'Quater';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; SelectQuater; Enum Quaterly)
        {
            Caption = 'SelectQuater';
            // trigger OnValidate()
            // var
            //     Today: Date;
            //     year: Text;
            //     TempSdate: Text;
            //     TempEdate: Text;
            //     Sdate: Date;
            //     Edate: Date;
            // begin
            //     If Rec.SelectQuater = Rec.SelectQuater::Q1 then begin
            //         Today := Today();
            //         Year := Format(Date2DMY(Today, 3));
            //         TempSdate := Format('04/01/' + year);
            //         TempEdate := Format('06/30/' + year);
            //         Evaluate(Sdate, TempSdate);
            //         Evaluate(Edate, TempEdate);
            //         Rec.StartDate := Sdate;
            //         Rec.EndDate := Edate;
            //     end;
            //     If Rec.SelectQuater = Rec.SelectQuater::Q2 then begin
            //         Today := Today();
            //         Year := Format(Date2DMY(Today, 3));
            //         TempSdate := Format('07/01/' + year);
            //         TempEdate := Format('09/30/' + year);
            //         Evaluate(Sdate, TempSdate);
            //         Evaluate(Edate, TempEdate);
            //         Rec.StartDate := Sdate;
            //         Rec.EndDate := Edate;
            //     end;
            //     If Rec.SelectQuater = Rec.SelectQuater::Q3 then begin
            //         Today := Today();
            //         Year := Format(Date2DMY(Today, 3));
            //         TempSdate := Format('10/01/' + year);
            //         TempEdate := Format('12/31/' + year);
            //         Evaluate(Sdate, TempSdate);
            //         Evaluate(Edate, TempEdate);
            //         Rec.StartDate := Sdate;
            //         Rec.EndDate := Edate;
            //     end;
            //     If Rec.SelectQuater = Rec.SelectQuater::Q4 then begin
            //         Today := Today();
            //         Year := Format(Date2DMY(Today, 3));
            //         TempSdate := Format('01/01/' + year);
            //         TempEdate := Format('03/31/' + year);
            //         Evaluate(Sdate, TempSdate);
            //         Evaluate(Edate, TempEdate);
            //         Rec.StartDate := Sdate;
            //         Rec.EndDate := Edate;
            //     end;
            // end;
            trigger OnValidate()
            begin
                GetDates();
            end;
        }
        field(2; StartDate; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Start Date';
        }
        field(3; EndDate; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Date';
        }
        field(4; LineNo; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; SelectQuater, LineNo)
        {
            Clustered = true;
        }
    }

    procedure GetDates()
    var
        CurrentMonth: Integer;
    begin
        CurrentMonth := Date2DMY(Today, 2);
        // If Rec.SelectQuater = Rec.SelectQuater::Q1 then begin
        //     IF (CurrentMonth = 1) or (CurrentMonth = 2) or (CurrentMonth = 3) then begin
        //         Rec.StartDate := DMY2Date(1, 4, Date2DMY(CalcDate('<CY-1Y>'), 3));
        //         Rec.EndDate := DMY2Date(30, 6, Date2DMY(CalcDate('<CY-1Y>'), 3));
        //     end else begin
        //         Rec.StartDate := DMY2Date(1, 4, Date2DMY(Today, 3));
        //         Rec.EndDate := DMY2Date(30, 6, Date2DMY(Today, 3));
        //     end;
        // end
        // else if Rec.SelectQuater = Rec.SelectQuater::Q2 then begin
        //     IF (CurrentMonth = 1) or (CurrentMonth = 2) or (CurrentMonth = 3) then begin
        //         Rec.StartDate := DMY2Date(1, 7, Date2DMY(CalcDate('<CY-1Y>'), 3));
        //         Rec.EndDate := DMY2Date(30, 9, Date2DMY(CalcDate('<CY-1Y>'), 3));
        //     end else begin
        //         Rec.StartDate := DMY2Date(1, 7, Date2DMY(Today, 3));
        //         Rec.EndDate := DMY2Date(30, 9, Date2DMY(Today, 3));
        //     end;
        // end
        // else If Rec.SelectQuater = SelectQuater::Q3 then begin
        //     IF (CurrentMonth = 1) or (CurrentMonth = 2) or (CurrentMonth = 3) then begin
        //         Rec.StartDate := DMY2Date(1, 10, Date2DMY(CalcDate('<CY-1Y>'), 3));
        //         Rec.EndDate := DMY2Date(31, 12, Date2DMY(CalcDate('<CY-1Y>'), 3));
        //     end else begin
        //         Rec.StartDate := DMY2Date(1, 10, Date2DMY(Today, 3));
        //         Rec.EndDate := DMY2Date(31, 12, Date2DMY(Today, 3));
        //     end;
        // end
        // else if Rec.SelectQuater = SelectQuater::Q4 then begin
        //     IF (CurrentMonth = 1) or (CurrentMonth = 2) or (CurrentMonth = 3) then begin
        //         Rec.StartDate := DMY2Date(1, 10, Date2DMY(CalcDate('<CY>'), 3));
        //         Rec.EndDate := DMY2Date(31, 12, Date2DMY(CalcDate('<CY>'), 3));
        //     end else begin
        //         Rec.StartDate := DMY2Date(1, 10, Date2DMY(CalcDate('<CY+Y>'), 3));
        //         Rec.EndDate := DMY2Date(31, 12, Date2DMY(CalcDate('<CY+Y>'), 3));
        //     end;
        // end;
        case SelectQuater of
            SelectQuater::Q1:
                IF (CurrentMonth = 1) or (CurrentMonth = 2) or (CurrentMonth = 3) then begin
                    Rec.StartDate := DMY2Date(1, 4, Date2DMY(CalcDate('<CY-1Y>'), 3));
                    Rec.EndDate := DMY2Date(30, 6, Date2DMY(CalcDate('<CY-1Y>'), 3));
                end else begin
                    Rec.StartDate := DMY2Date(1, 4, Date2DMY(Today, 3));
                    Rec.EndDate := DMY2Date(30, 6, Date2DMY(Today, 3));
                end;
            SelectQuater::Q2:
                IF (CurrentMonth = 1) or (CurrentMonth = 2) or (CurrentMonth = 3) then begin
                    Rec.StartDate := DMY2Date(1, 7, Date2DMY(CalcDate('<CY-1Y>'), 3));
                    Rec.EndDate := DMY2Date(30, 9, Date2DMY(CalcDate('<CY-1Y>'), 3));
                end else begin
                    Rec.StartDate := DMY2Date(1, 7, Date2DMY(Today, 3));
                    Rec.EndDate := DMY2Date(30, 9, Date2DMY(Today, 3));
                end;
            SelectQuater::Q3:
                IF (CurrentMonth = 1) or (CurrentMonth = 2) or (CurrentMonth = 3) then begin
                    Rec.StartDate := DMY2Date(1, 10, Date2DMY(CalcDate('<CY-1Y>'), 3));
                    Rec.EndDate := DMY2Date(31, 12, Date2DMY(CalcDate('<CY-1Y>'), 3));
                end else begin
                    Rec.StartDate := DMY2Date(1, 10, Date2DMY(Today, 3));
                    Rec.EndDate := DMY2Date(31, 12, Date2DMY(Today, 3));
                end;
            else
                IF (CurrentMonth = 1) or (CurrentMonth = 2) or (CurrentMonth = 3) then begin
                    Rec.StartDate := DMY2Date(1, 10, Date2DMY(CalcDate('<CY>'), 3));
                    Rec.EndDate := DMY2Date(31, 12, Date2DMY(CalcDate('<CY>'), 3));
                end else begin
                    Rec.StartDate := DMY2Date(1, 10, Date2DMY(CalcDate('<CY+1Y>'), 3));
                    Rec.EndDate := DMY2Date(31, 12, Date2DMY(CalcDate('<CY+1Y>'), 3));
                end;
        end;
    end;
}
