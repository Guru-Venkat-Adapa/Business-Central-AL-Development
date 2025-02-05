// pageextension 50130 "Change log Entries Ext" extends "Change Log Entries"
// {
//     actions
//     {
//         addlast(processing)
//         {
//             action(ExportintoExcel)
//             {
//                 Caption = 'Export into Excel';
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 trigger OnAction()
//                 begin
//                     Message('Hello Guru Venkat');
//                 end;
//             }
//         }
//     }
// }
