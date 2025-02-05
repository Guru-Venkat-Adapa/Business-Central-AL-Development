// // report 50121 "Payment Term Code"
// // {
// //     UsageCategory = ReportsAndAnalysis;
// //     ApplicationArea = All;
// //     ProcessingOnly = true;
// //     Caption = 'Payment Term Code';
// //     dataset
// //     {
// //         dataitem("Sales Invoice Header Data"; "Sales Invoice Header")
// //         {
// //             DataItemTableView = sorting("No.");
// //             RequestFilterFields = "Sell-to Customer No.";
// //         }
// //     }

// //     requestpage
// //     {
// //         SaveValues = true;

// //         layout
// //         {
// //             area(content)
// //             {
// //                 group(Options)
// //                 {
// //                     Caption = 'Options';
// //                     field("Start Date"; StartDate)
// //                     {
// //                         ApplicationArea = Basic, Suite;
// //                         Caption = 'Start Date';
// //                         ToolTip = 'Specifies the date from which the report or batch job processes information.';
// //                         ShowMandatory = true;
// //                     }
// //                     field("End Date"; EndDate)
// //                     {
// //                         ApplicationArea = Basic, Suite;
// //                         Caption = 'End Date';
// //                         ToolTip = 'Specifies the date to which the report or batch job processes information.';
// //                         ShowMandatory = true;
// //                     }
// //                 }
// //             }
// //         }
// //     }
// //     trigger OnPostReport()
// //     var
// //         myInt: Integer;
// //     begin
// //         Setheader();
// //     end;

// //     var
// //         TempExcelBuffer: Record "Excel Buffer" temporary;
// //         "Payment Terms": Record "Payment Terms";
// //         "Sales Invoice Header": Record "Sales Invoice Header";
// //         StartDate: Date;
// //         EndDate: Date;


// //     local procedure Setheader()
// //     var
// //         CustomerSet1: list of [Code[50]];
// //         CustomerSet2: list of [Code[50]];
// //         InvoiceSet1: list of [Code[50]];
// //         InvoiceSet2: list of [Code[50]];
// //         MaxCount: Integer;
// //         MinCount: Integer;
// //         i: Integer;
// //     begin
// //         TempExcelBuffer.Reset();
// //         TempExcelBuffer.DeleteAll();
// //         TempExcelBuffer.NewRow();

// //         "Payment Terms".SetFilter(Code, '%1|%2', '14 Days', 'CM');
// //         if "Payment Terms".FindSet() then begin
// //             // TempExcelBuffer.AddColumn(' ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //             // TempExcelBuffer.AddColumn('All Customers', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //             // TempExcelBuffer.AddColumn(' ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

// //             // TempExcelBuffer.NewRow();
// //             // TempExcelBuffer.AddColumn('Payment Type', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //             // TempExcelBuffer.AddColumn('Bank', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //             // TempExcelBuffer.AddColumn('Payment Type', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //             // TempExcelBuffer.AddColumn('Cash', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

// //             // TempExcelBuffer.NewRow();

// //             repeat
// //                 TempExcelBuffer.AddColumn('Payment Type', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //                 TempExcelBuffer.AddColumn("Payment Terms".Code, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //             until "Payment Terms".Next() = 0;
// //             TempExcelBuffer.NewRow();

// //             TempExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //             TempExcelBuffer.AddColumn('', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //             TempExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //             TempExcelBuffer.AddColumn('', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

// //             TempExcelBuffer.NewRow();

// //             "Sales Invoice Header".SetFilter("Payment Terms Code", '%1|%2', '14 DAYS', 'CM');
// //             if "Sales Invoice Header".FindSet() then
// //                 repeat
// //                     if ("Sales Invoice Header"."Payment Terms Code" = '14 DAYS') and (not CustomerSet1.Contains("Sales Invoice Header"."Sell-to Customer No.")) then begin
// //                         CustomerSet1.Add("Sales Invoice Header"."Sell-to Customer Name");
// //                         InvoiceSet1.Add("Sales Invoice Header"."No.")
// //                     end
// //                     else if ("Sales Invoice Header"."Payment Terms Code" = 'CM') and (not CustomerSet2.Contains("Sales Invoice Header"."Sell-to Customer No.")) then begin
// //                         CustomerSet2.Add("Sales Invoice Header"."Sell-to Customer Name");
// //                         InvoiceSet2.Add("Sales Invoice Header"."No.");
// //                     end;
// //                 until "Sales Invoice Header".Next() = 0;

// //             MaxCount := CustomerSet1.Count;
// //             if CustomerSet2.Count > CustomerSet1.Count then
// //                 MaxCount := CustomerSet2.Count;

// //             for i := 1 to MaxCount do begin
// //                 TempExcelBuffer.NewRow();
// //                 if i > CustomerSet1.Count then
// //                     TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text)
// //                 else begin
// //                     TempExcelBuffer.AddColumn(CustomerSet1.Get(i), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //                     TempExcelBuffer.AddColumn(InvoiceSet1.Get(i), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //                 end;
// //                 if i > CustomerSet2.Count then
// //                     TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text)
// //                 else begin
// //                     TempExcelBuffer.AddColumn(CustomerSet2.Get(i), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //                     TempExcelBuffer.AddColumn(InvoiceSet2.Get(i), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
// //                 end;
// //             end;

// //             TempExcelBuffer.CreateNewBook('Payment Term Code');
// //             TempExcelBuffer.WriteSheet('Payment Term Code', CompanyName, UserId);
// //             TempExcelBuffer.CloseBook();
// //             TempExcelBuffer.SetFriendlyFilename(StrSubstNo('Payment_Term Code', CurrentDateTime, UserId));
// //             TempExcelBuffer.OpenExcel();
// //         end;
// //     end;
// // }
// report 50101 "Payment Term Code"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     ProcessingOnly = true;
//     Caption = 'Payment Term Code';
//     requestpage
//     {
//         // SaveValues = true;

//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options';
//                     field("Start Date"; StartDate)
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Start Date';
//                         ToolTip = 'Specifies the date from which the report or batch job processes information.';
//                         ShowMandatory = true;
//                     }
//                     field("End Date"; EndDate)
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'End Date';
//                         ToolTip = 'Specifies the date to which the report or batch job processes information.';
//                         ShowMandatory = true;
//                     }
//                     field(SellToCustomer; SellToCustomer)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Sell to Customer';
//                         ToolTip = 'Specifies the customer to which the report or batch job processes information.';
//                         TableRelation = Customer."No.";
//                     }
//                 }
//             }
//         }
//     }

//     trigger OnPostReport()
//     var
//         myInt: Integer;
//     begin
//         Setheader(SellToCustomer, StartDate, EndDate);
//     end;

//     var
//         TempExcelBuffer: Record "Excel Buffer" temporary;
//         "Payment Terms": Record "Payment Terms";
//         "Sales Invoice Header": Record "Sales Invoice Header";
//         "Sales Invoice Header2": Record "Sales Invoice Header";
//         StartDate: Date;
//         EndDate: Date;
//         SellToCustomer: Code[50];

//     local procedure Setheader(CodeNo: Code[50]; StartDate: Date; Endate: Date)
//     var
//         CustomerSet1: list of [Code[20]];
//         CustomerSet2: list of [Code[20]];
//         MaxCount, MaxSalesHeader : Integer;
//         i, j : Integer;
//     begin
//         TempExcelBuffer.Reset();
//         TempExcelBuffer.DeleteAll();
//         TempExcelBuffer.NewRow();

//         "Payment Terms".SetFilter(Code, '%1|%2', '14 Days', 'CM');
//         if "Payment Terms".FindSet() then begin
//             TempExcelBuffer.AddColumn('Payment Codes', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
//             TempExcelBuffer.NewRow();

//             repeat
//                 TempExcelBuffer.AddColumn("Payment Terms".Code, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
//                 TempExcelBuffer.AddColumn('', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
//             until "Payment Terms".Next() = 0;
//             "Sales Invoice Header".SetFilter("Payment Terms Code", '%1|%2', '14 DAYS', 'CM');
//             if "Sales Invoice Header".FindSet() then
//                 if CodeNo = '' then begin
//                     if (StartDate <> 0D) and (EndDate <> 0D) then
//                         "Sales Invoice Header".SetFilter("Posting Date", '%1..%2', StartDate, EndDate);

//                     if "Sales Invoice Header".FindSet() then begin
//                         repeat
//                             if ("Sales Invoice Header"."Payment Terms Code" = '14 DAYS') and (not CustomerSet1.Contains("Sales Invoice Header"."Sell-to Customer No.")) then
//                                 CustomerSet1.Add("Sales Invoice Header"."Sell-to Customer No.")
//                             else if ("Sales Invoice Header"."Payment Terms Code" = 'CM') and (not CustomerSet2.Contains("Sales Invoice Header"."Sell-to Customer No.")) then
//                                 CustomerSet2.Add("Sales Invoice Header"."Sell-to Customer No.");
//                         until "Sales Invoice Header".Next() = 0;
//                     end else begin
//                         repeat
//                             if ("Sales Invoice Header"."Payment Terms Code" = '14 DAYS') and (not CustomerSet1.Contains("Sales Invoice Header"."Sell-to Customer No.")) then
//                                 CustomerSet1.Add("Sales Invoice Header"."Sell-to Customer No.")
//                             else if ("Sales Invoice Header"."Payment Terms Code" = 'CM') and (not CustomerSet2.Contains("Sales Invoice Header"."Sell-to Customer No.")) then
//                                 CustomerSet2.Add("Sales Invoice Header"."Sell-to Customer No.");
//                         until "Sales Invoice Header".Next() = 0;
//                     end;
//                 end else begin
//                     if (StartDate <> 0D) and (EndDate <> 0D) then
//                         "Sales Invoice Header".SetFilter("Posting Date", '%1..%2', StartDate, EndDate);

//                     if "Sales Invoice Header".FindSet() then begin
//                         CustomerSet1.Add(CodeNo);
//                         CustomerSet2.Add(CodeNo);
//                     end else begin
//                         CustomerSet1.Add(CodeNo);
//                         CustomerSet2.Add(CodeNo);
//                     end;
//                 end;


//             MaxCount := CustomerSet1.Count;
//             if CustomerSet2.Count > CustomerSet1.Count then
//                 MaxCount := CustomerSet2.Count;

//             for i := 1 to MaxCount do begin
//                 TempExcelBuffer.NewRow();
//                 if i > CustomerSet1.Count then
//                     TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text)
//                 else
//                     TempExcelBuffer.AddColumn('Customer No.' + CustomerSet1.Get(i), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
//                 TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
//                 if i > CustomerSet2.Count then
//                     TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text)
//                 else
//                     TempExcelBuffer.AddColumn('Customer No.' + CustomerSet2.Get(i), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

//                 TempExcelBuffer.NewRow();

//                 if CustomerSet1.Count >= i then begin
//                     "Sales Invoice Header".SetFilter("Sell-to Customer No.", CustomerSet1.Get(i));
//                     "Sales Invoice Header".SetFilter("Payment Terms Code", '14 DAYS');
//                 end;
//                 if CustomerSet2.Count >= i then begin
//                     "Sales Invoice Header2".SetFilter("Sell-to Customer No.", CustomerSet2.Get(i));
//                     "Sales Invoice Header2".SetFilter("Payment Terms Code", 'CM');
//                 end;

//                 if "Sales Invoice Header".FindSet() or "Sales Invoice Header2".FindSet() then begin
//                     MaxSalesHeader := "Sales Invoice Header".Count;
//                     if "Sales Invoice Header".Count < "Sales Invoice Header2".Count then
//                         MaxSalesHeader := "Sales Invoice Header2".Count;

//                     for j := 1 to MaxSalesHeader do begin
//                         if (j > "Sales Invoice Header".Count) or (CustomerSet1.Count < i) then
//                             TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text)
//                         else
//                             TempExcelBuffer.AddColumn("Sales Invoice Header"."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

//                         TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

//                         if (j > "Sales Invoice Header2".Count) or (CustomerSet2.Count < i) then
//                             TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text)
//                         else
//                             TempExcelBuffer.AddColumn("Sales Invoice Header2"."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

//                         "Sales Invoice Header".Next();
//                         "Sales Invoice Header2".Next();
//                         TempExcelBuffer.NewRow();
//                     end;
//                 end;
//             end;

//             TempExcelBuffer.CreateNewBook('Payment Term Code');
//             TempExcelBuffer.WriteSheet('Payment Term Code', CompanyName, UserId);
//             TempExcelBuffer.CloseBook();
//             TempExcelBuffer.SetFriendlyFilename(StrSubstNo('Payment_Term Code', CurrentDateTime, UserId));
//             TempExcelBuffer.OpenExcel();
//         end;
//     end;
// }