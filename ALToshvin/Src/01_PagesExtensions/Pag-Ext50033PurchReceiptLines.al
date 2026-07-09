// pageextension 50033 "Purch Receipt Lines Ext" extends "Purch. Receipt Lines"
// {
//     layout
//     {
//         addafter("Document No.")
//         {
//             field("Posted Warehouse Rec No"; Rec."Posted Warehouse Rec No")
//             {
//                 ApplicationArea = All;
//                 Caption = 'posted Warehouse Recpt. No.';
//                 ToolTip = 'Specifies the values of Posted Warehouse Rec No filed';
//                 Editable = false;
//             }
//         }
//     }
// }
