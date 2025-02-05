// pageextension 50133 "Case List nH Ext." extends "Case List nH"
// {
//     // layout
//     // {
//     //     modify("Campaign No.")
//     //     {
//     //         Visible = false;
//     //     }
//     //     modify("Opportunity No.")
//     //     {
//     //         Visible = false;
//     //     }
//     //     modify("Responsibility Center")
//     //     {
//     //         Visible = false;
//     //     }

//     // }
//     actions
//     {
//         addafter(DeleteMultiple)
//         {
//             action(transferData)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Transfer Data from Case to Inquiry';
//                 Image = Copy;
//                 trigger OnAction()
//                 var
//                     datatransf: Codeunit 50148;
//                 begin
//                     datatransf.transfer(Rec."No.");
//                 end;
//             }

//         }
//     }

// }
