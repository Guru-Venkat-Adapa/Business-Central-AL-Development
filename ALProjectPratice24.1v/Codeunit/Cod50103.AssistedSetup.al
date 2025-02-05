codeunit 50103 "Assisted Setup"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure registerGenLedSetup()
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        GuidedExperience.InsertAssistedSetup('General Ledger Setup', 'Gen Led Setup', 'Setup to customize the general ledger setup', 5, ObjectType::Page, Page::"Assisted Setup Gen Led Setup", enum::"Assisted Setup Group"::"Custom Setup", 'https://shaligraminfotech.com', Enum::"Video Category"::Analysis, 'https://shaligraminfotech.com');
    end;
}
