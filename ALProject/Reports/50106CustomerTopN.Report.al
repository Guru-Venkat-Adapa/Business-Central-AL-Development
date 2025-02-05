report 50106 "Top N Customer"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Top N Customer';
    RDLCLayout = 'TopNCustomer.RDL';


    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin
                CalcFields("Sales (LCY)", "Balance (LCY)");
                if ("Sales (LCY)" = 0) and ("Balance (LCY)" = 0) then
                    CurrReport.Skip();
                temptable.Init();
                temptable."Customer No." := "No.";
                if (optiontype = optiontype::"Sales (LCY)") then begin
                    temptable."Amount (LCY)" := -"Sales (LCY)";
                    temptable."Amount 2 (LCY)" := -"Balance (LCY)";
                end else begin
                    temptable."Amount (LCY)" := -"Balance (LCY)";
                    temptable."Amount 2 (LCY)" := -"Sales (LCY)";
                end;
                temptable.Insert();
                if (noofrecords = 0) or (i < noofrecords) then
                    i += 1
                else begin
                    temptable.Find('+');
                    temptable.Delete();
                end;
            end;


            trigger OnPreDataItem()
            begin
                window.Open(text1);
                i := 0;
                temptable.DeleteAll();
            end;

        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(CustomerNo; Customer."No.")
            {
                IncludeCaption = true;
            }
            column(CustomerName; Customer.Name)
            {
                IncludeCaption = true;
            }
            column(SalesAmount; Customer."Sales (LCY)")
            {
                IncludeCaption = true;
            }
            column(BalanceAmount; Customer."Balance (LCY)")
            {
                IncludeCaption = true;
            }
            column(City; Customer.City)
            {
                IncludeCaption = true;
            }
            column(TotalSales; TotalSales)
            {
            }
            column(TotalBalance; TotalBalance)
            {
            }
            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                    if not temptable.Find('-') then
                        CurrReport.Break();
                end else
                    if temptable.Next = 0 then
                        CurrReport.Break();
                temptable."Amount (LCY)" := -temptable."Amount (LCY)";
                Customer.Get(temptable."Customer No.");
                Customer.CalcFields("Sales (LCY)", "Balance (LCY)");
                if MaxAmount = 0 then
                    MaxAmount := temptable."Amount (LCY)";
                temptable."Amount (LCY)" := -temptable."Amount (LCY)";

            end;

            trigger OnPreDataItem()
            begin
                if temptable.FindSet() then
                    repeat
                        //Customer.Get(temptable."Customer No.");
                        // Customer.CalcFields("Sales (LCY)", "Balance (LCY)");
                        // TotalSales+=-temptable."Amount (LCY)";
                        // TotalBalance+=temptable."Amount 2 (LCY)";
                        if optiontype = optiontype::"Sales (LCY)" then begin
                            TotalSales += -temptable."Amount (LCY)";
                            TotalBalance += -temptable."Amount 2 (LCY)";
                        end else begin
                            TotalSales += -temptable."Amount 2 (LCY)";
                            TotalBalance += -temptable."Amount (LCY)";
                        end;
                    until temptable.Next() = 0;
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(optiontype; optiontype)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show';
                        OptionCaption = 'Sales (LCY),Balance (LCY)';
                        ToolTip = 'specifies the data to be sorted based on the option';
                    }
                    field(noofrecords; noofrecords)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number of Customers';
                        ToolTip = 'Specifies how many data should be printed';

                        trigger OnValidate()
                        begin
                            if noofrecords <= 0 then
                                Message('No records to print');
                        end;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if noofrecords = 0 then
                noofrecords := 5;
        end;
    }

    var
        noofrecords: Integer;
        optiontype: Option "Sales (LCY)","Balance (LCY)";
        temptable: Record "Customer Amount" temporary;
        i: Integer;
        maxamount: Decimal;
        window: Dialog;
        text1: Label 'Sorting Customer #1##########';
        TotalSales: Decimal;
        TotalBalance: Decimal;
}
// trigger OnPreDataItem()
//             begin
//                 if custtemp.FindSet() then begin
//                     repeat
//                         if (ShowType = ShowType::"Sales (LCY)") then begin
//                             totalsales := -(custtemp."Amount (LCY)") + totalsales;
//                             totalbalance := -(custtemp."Amount 2 (LCY)") + totalbalance;
//                         end else begin
//                             totalsales := -(custtemp."Amount 2 (LCY)") + totalsales;
//                             totalbalance := -(custtemp."Amount (LCY)") + totalbalance;
//                         end;

//                     until custtemp.Next() = 0;
//                 end;
//             end;