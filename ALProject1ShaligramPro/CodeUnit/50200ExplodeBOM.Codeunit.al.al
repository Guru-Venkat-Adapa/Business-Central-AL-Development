codeunit 50200 ExplodeBOM
{
    trigger OnRun()
    begin

    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Explode BOM", 'OnBeforeConfirmExplosion', '', false, false)]
    // local procedure RemoveIshandle(var SalesLine: Record "Sales Line"; var HideDialog: Boolean; var Selection: Integer; var NoOfBOMComp: Integer)
    // begin
    //     HideDialog := true;
    // end;
}