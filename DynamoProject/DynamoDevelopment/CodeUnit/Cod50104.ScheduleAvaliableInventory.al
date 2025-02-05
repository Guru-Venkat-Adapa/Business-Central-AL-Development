// codeunit 50104 ScheduleAvaliableInventory
// {
//     // trigger OnRun()
//     // begin
//     //     GetScheduleInventory();
//     // end;

//     procedure GetScheduleInventory()
//     begin
//         Item.Reset();
//         Item.SetFilter("No.", '<>%1', '');
//         If Item.FindSet() then
//             repeat
//                 Item.ScheduleAvaliableInventory := Item."Qty. on Purch. Order" + Item."Qty. to Recive Bl Puch Order";
//                 Item.Modify(false);
//             until Item.Next() = 0;
//     end;

//     var
//         Item: Record Item;
// }
