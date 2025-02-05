page 50112 "Automation Data"
{
    PageType = API;
    Caption = 'Power Automation Data';
    APIPublisher = 'guru';
    APIGroup = 'shaligrmGroup';
    APIVersion = 'v2.0';
    EntityName = 'powerAutomatesetup';
    EntitySetName = 'powerAutomatesetups';
    SourceTable = GetAutomateData;
    DelayedInsert = true;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Controller)
            {
                field(slNo; Rec."Sl No.") { }
                field(registrationNo; Rec."Registration No.") { }
                field(name; Rec.Name) { }
                field(address; Rec.Address) { }
                field(phoneNumber; Rec."Phone Number") { }
                field(email; Rec.Email) { }
            }
        }
    }
}