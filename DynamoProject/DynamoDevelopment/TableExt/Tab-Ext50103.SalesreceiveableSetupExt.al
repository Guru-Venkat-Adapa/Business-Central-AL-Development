// tableextension 50103 "Sales & receiveable Setup Ext" extends "Sales & Receivables Setup"
// {
//     fields
//     {
//         field(50100; "Custom Payment Journal"; code[20])
//         {
//             Caption = 'Custom Payment Journal';
//             DataClassification = ToBeClassified;
//             TableRelation = "No. Series";
//         }
//     }
// }
// pageextension 50116 "Sales & Rev Page Ext" extends "Sales & Receivables Setup"
// {
//     layout
//     {
//         // Add changes to page layout here
//         addafter("Customer Nos.")
//         {
//             field("Custom Payment Journal"; Rec."Custom Payment Journal")
//             {
//                 Caption = 'Custom Payment Journal';
//                 ApplicationArea = All;
//             }
//         }
//     }
// }
