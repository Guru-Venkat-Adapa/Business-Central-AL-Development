// pageextension 50132 "Sales Order Arch Ext" extends "Sales Order Archive"
// {
//     layout
//     {
//         addafter(Status)
//         {
//             group("Work Description")
//             {
//                 Caption = 'Work Description';
//                 field(WorkDescription; WorkDescription)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     //Importance = Additional;
//                     MultiLine = true;
//                     ShowCaption = false;


//                     // trigger OnValidate()
//                     // begin
//                     //     Rec.SetWorkDescription(WorkDescription);
//                     // end;
//                 }

//             }
//         }

//     }

//     trigger OnAfterGetRecord()
//     begin
//         WorkDescription := Rec.GetWorkDescription();
//     end;



//     var
//         WorkDescription: Text;

//         saleOrder: Page "Sales Order";

// }
