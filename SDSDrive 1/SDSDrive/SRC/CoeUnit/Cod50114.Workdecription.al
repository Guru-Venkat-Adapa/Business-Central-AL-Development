// codeunit 60001 MyCodeunit
// {

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnBeforeSalesHeaderArchiveInsert', '', false, false)]
//     local procedure salesarchive(SalesHeader: Record "Sales Header"; var SalesHeaderArchive: Record "Sales Header Archive")
//     begin
//         SalesHeader.CalcFields("Work Description");
//         SalesHeaderArchive."Work Description" := SalesHeader."Work Description";
//     end;
// }