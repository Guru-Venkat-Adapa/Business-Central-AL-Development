report 50103 "No Of Lines"
{
    ApplicationArea = All;
    Caption = 'Sales Header Batch';
    UsageCategory = ReportsAndAnalysis;
    Permissions = tabledata 36 = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(Number = const(1));
            trigger OnPreDataItem();
            begin

                if SalesHeader.FindSet() then begin
                    repeat
                        Clear(lines);
                        SalesLine.SetRange("Document No.", SalesHeader."No.");
                        if SalesLine.FindSet() then begin
                            Clear(lines);
                            lines := SalesLine.Count;
                            SalesHeader."No. of Lines" := lines;
                        end
                        else begin
                            SalesHeader."No. of Lines" := 0;
                        end;
                        SalesHeader.Modify();
                    until SalesHeader.Next() = 0;
                end;
            end;

            // trigger OnAfterGetRecord()
            // begin
            //     // Update "No. of Lines" field whenever a Sales Header record is retrieved
            //     Clear(SalesLine);
            //     SalesLine.SetRange("Document No.", SalesHeader."No.");
            //     if SalesLine.FindSet() then begin
            //         SalesHeader."No. of Lines" := SalesLine.Count;
            //         SalesHeader.Modify();
            //     end;
            // end;
        }

    }


    var
        lines: Integer;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
}
